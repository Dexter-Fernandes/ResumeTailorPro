#!/usr/bin/env bash
#
# html2pdf.sh -- batch export tailored CVs and cover letters to PDF.
#
# Sweeps every */*/HTML/ directory and renders each .html to the sibling pdf/
# directory under the same basename. A PDF is built when it is missing or older
# than its HTML source; otherwise it is left alone.
#
# Rendering is headless Chrome. The template carries its own @page A4 rules, so
# no geometry is imposed here -- only Chrome's header/footer furniture is
# suppressed.

set -euo pipefail

CHROME_BIN="${CHROME_BIN:-google-chrome}"
FONT_HOST="fonts.googleapis.com"
# The host root 404s by design, so probe the stylesheet the template actually links.
FONT_PROBE_URL="https://$FONT_HOST/css2?family=Archivo:wght@400&display=swap"

NAME_WIDTH=44

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

force=0
dry_run=0
filters=()

usage() {
  cat <<'EOF'
Usage: html2pdf.sh [OPTIONS] [PATH ...]

Renders every */*/HTML/*.html into the sibling pdf/ directory, keeping the
basename. Builds a PDF when it is missing or older than its HTML source.

Options:
  --force      Rebuild every PDF, ignoring timestamps
  --dry-run    Report what would be built without rendering
  -h, --help   Show this message

Arguments:
  PATH ...     Limit the sweep to matching tracks or directories,
               e.g. `html2pdf.sh CV Software` or `html2pdf.sh SLAM/Resumes`

Exit status is 0 when every render succeeded, 1 if any failed. Page-count
warnings do not affect exit status.

Environment:
  CHROME_BIN   Chrome executable to use (default: google-chrome)
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)   force=1 ;;
    --dry-run) dry_run=1 ;;
    -h|--help) usage; exit 0 ;;
    --)        shift; filters+=("$@"); break ;;
    -*)        printf 'error: unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
    *)         filters+=("$1") ;;
  esac
  shift
done

if ! command -v "$CHROME_BIN" >/dev/null 2>&1; then
  printf 'error: %s not found. Set CHROME_BIN to your Chrome executable.\n' "$CHROME_BIN" >&2
  exit 1
fi

TMPDIR_RUN="$(mktemp -d)"
cleanup() { rm -rf -- "$TMPDIR_RUN"; }
trap cleanup EXIT

# Percent-encode a path into a file:// URI. Filenames here contain spaces and
# parentheses, which Chrome will not reliably parse unencoded.
file_uri() {
  local path="$1" out="" i char
  for (( i = 0; i < ${#path}; i++ )); do
    char="${path:i:1}"
    case "$char" in
      [a-zA-Z0-9._~/-]) out+="$char" ;;
      *)                printf -v char '%%%02X' "'$char"; out+="$char" ;;
    esac
  done
  printf 'file://%s' "$out"
}

# True when the path matches any user-supplied filter, or when none were given.
matches_filter() {
  local rel="$1" f
  (( ${#filters[@]} == 0 )) && return 0
  for f in "${filters[@]}"; do
    f="${f#./}"; f="${f%/}"
    [[ "$rel" == "$f" || "$rel" == "$f"/* ]] && return 0
  done
  return 1
}

# Keep the report in aligned columns. Tailored CV basenames routinely run past
# 70 characters, so elide the middle rather than let the status column drift.
elide() {
  local s="$1" keep_tail=18 head_len
  (( ${#s} <= NAME_WIDTH )) && { printf '%s' "$s"; return; }
  head_len=$(( NAME_WIDTH - keep_tail - 3 ))
  printf '%s...%s' "${s:0:head_len}" "${s: -keep_tail}"
}

page_count() {
  command -v pdfinfo >/dev/null 2>&1 || return 0
  pdfinfo "$1" 2>/dev/null | awk '/^Pages:/ { print $2 }'
}

render() {
  local src="$1" dest="$2" tmp_out
  tmp_out="$TMPDIR_RUN/out.pdf"
  rm -f -- "$tmp_out"

  # Chrome renders its own error page rather than failing when it cannot read a
  # file, which would yield a plausible-looking but wrong PDF. Catch that here.
  [[ -r "$src" && -s "$src" ]] || return 1

  # --virtual-time-budget plus --run-all-compositor-stages-before-draw gives the
  # Google Fonts request time to land before the page is printed. Without it
  # Archivo silently falls back to system-ui and the document repaginates.
  "$CHROME_BIN" \
    --headless=new \
    --disable-gpu \
    --user-data-dir="$TMPDIR_RUN/profile" \
    --no-first-run \
    --disable-extensions \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="$tmp_out" \
    "$(file_uri "$src")" >/dev/null 2>&1 || return 1

  # Chrome exits 0 on some failures, so the magic bytes are the real gate.
  [[ -s "$tmp_out" ]] || return 1
  [[ "$(head -c4 -- "$tmp_out")" == "%PDF" ]] || return 1

  mkdir -p -- "$(dirname -- "$dest")"
  mv -f -- "$tmp_out" "$dest"
}

# Advisory only: an offline run still produces a PDF, just with the wrong face
# and therefore the wrong pagination.
if command -v curl >/dev/null 2>&1; then
  if ! curl -sf --max-time 3 -o /dev/null "$FONT_PROBE_URL" >/dev/null 2>&1; then
    printf 'note: %s unreachable -- Archivo will fall back to system-ui and pagination may differ\n\n' \
      "$FONT_HOST"
  fi
fi

built=0
current=0
warnings=0
errors=0
found=0

while IFS= read -r -d '' src; do
  rel="${src#"$ROOT"/}"
  html_dir="$(dirname -- "$src")"
  section_dir="$(dirname -- "$html_dir")"
  section="${section_dir#"$ROOT"/}"

  matches_filter "$section" || continue

  found=1
  base="$(basename -- "$src")"
  dest="$section_dir/pdf/${base%.html}.pdf"
  label="$(elide "${base%.html}")"

  if (( ! force )) && [[ -f "$dest" && ! "$src" -nt "$dest" ]]; then
    # printf '  %-24s %-*s up to date\n' "$section" "$NAME_WIDTH" "$label"
    (( ++current ))
    continue
  fi

  if (( dry_run )); then
    if [[ -f "$dest" ]]; then
      printf '  %-24s %-*s would rebuild\n' "$section" "$NAME_WIDTH" "$label"
    else
      printf '  %-24s %-*s would build\n' "$section" "$NAME_WIDTH" "$label"
    fi
    (( ++built ))
    continue
  fi

  if ! render "$src" "$dest"; then
    printf '  %-24s %-*s ERROR    render failed\n' "$section" "$NAME_WIDTH" "$label"
    (( ++errors ))
    continue
  fi

  (( ++built ))
  pages="$(page_count "$dest")"

  if [[ -z "$pages" ]]; then
    printf '  %-24s %-*s built\n' "$section" "$NAME_WIDTH" "$label"
  else
    page_word="pages"
    [[ "$pages" == "1" ]] && page_word="page"
    if [[ "$section" == */Resumes && "$pages" != "2" ]]; then
      printf '  %-24s %-*s built    %s %s  ! expected 2\n' \
        "$section" "$NAME_WIDTH" "$label" "$pages" "$page_word"
      (( ++warnings ))
    else
      printf '  %-24s %-*s built    %s %s\n' \
        "$section" "$NAME_WIDTH" "$label" "$pages" "$page_word"
    fi
  fi
done < <(
  cd -- "$ROOT" || exit 1
  find . -mindepth 3 -maxdepth 3 -type d -name HTML -print0 |
    while IFS= read -r -d '' d; do
      find "$ROOT/${d#./}" -mindepth 1 -maxdepth 1 -type f -name '*.html' -print0
    done
)

if (( ! found )); then
  if (( ${#filters[@]} )); then
    printf 'No HTML files matched: %s\n' "${filters[*]}"
  else
    printf 'No HTML files found under */*/HTML/\n'
  fi
  exit 0
fi

verb="built"
(( dry_run )) && verb="to build"

printf '\n%d %s, %d up to date, %d warning%s, %d error%s\n' \
  "$built" "$verb" \
  "$current" \
  "$warnings" "$( (( warnings == 1 )) || printf s )" \
  "$errors" "$( (( errors == 1 )) || printf s )"

(( errors == 0 ))
