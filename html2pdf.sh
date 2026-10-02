#!/usr/bin/env bash
#
# html2pdf.sh -- export tailored CVs and cover letters to PDF.
#
# With no file arguments, sweeps every */*/HTML/ directory and renders each
# .html to the sibling pdf/ directory under the same basename. A PDF is built
# when it is missing or older than its HTML source; otherwise it is left alone.
# Given .html files, renders exactly those, always.
#
# Rendering is headless Chrome, fully offline, with Archivo served from
# assets/fonts. The template carries its own @page A4 rules, so no geometry is
# imposed here -- only Chrome's header/footer furniture is suppressed.
#
# Why local fonts: Google Fonts serves Archivo as a variable font to modern
# browsers, and Chrome's PDF backend cannot subset-embed those. It emits Type 3
# fonts instead: glyphs drawn as vector procedures, ~4x the file size and a
# weaker text layer for ATS parsers. --refresh-fonts fetches static per-weight
# instances, which embed as TrueType subsets. Rendering offline also removes
# the font-loading race, so pagination is the same on every run.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$ROOT/assets/fonts"
WEIGHTS=(400 500 600 700 800)

MIN_TEXT_CHARS=1000

force=0
out=""
filters=()
files=()

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

usage() {
  cat <<'EOF'
Usage: html2pdf.sh [OPTIONS] [PATH ...]
       html2pdf.sh [OPTIONS] FILE.html ...

With no FILE arguments, renders every */*/HTML/*.html into the sibling pdf/
directory, keeping the basename. Builds a PDF when it is missing or older than
its HTML source.

Given FILE.html arguments, renders exactly those files regardless of
timestamps. A file inside an HTML/ directory goes to the sibling pdf/;
anything else goes next to its source.

Options:
  --force          Rebuild every PDF, ignoring timestamps
  -o, --output F   Output path (single FILE.html only)
  --refresh-fonts  Re-download Archivo into assets/fonts and exit
  -h, --help       Show this message

Arguments:
  PATH ...         Limit the sweep to matching tracks or directories,
                   e.g. `html2pdf.sh CV Software` or `html2pdf.sh SLAM/Resumes`

Exit status is 0 when every render succeeded, 1 if any failed. Warnings (page
count, fonts, text layer) do not affect exit status.

Environment:
  CHROME_BIN       Chrome executable to use (default: first of google-chrome,
                   chromium, brave-browser, microsoft-edge-stable found)
EOF
}

# Google serves static per-weight files only to old user agents; a modern one
# gets the variable font this whole script exists to avoid.
refresh_fonts() {
  command -v python3 >/dev/null 2>&1 || die "--refresh-fonts needs python3"
  mkdir -p -- "$FONT_DIR"
  FONT_DIR="$FONT_DIR" python3 - "${WEIGHTS[@]}" <<'PY'
import os, re, sys, urllib.request
weights = sys.argv[1:]
dest = os.environ["FONT_DIR"]
legacy_ua = ("Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 "
             "(KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36")
url = ("https://fonts.googleapis.com/css2?family=Archivo:wght@"
       + ";".join(weights) + "&display=swap")
req = urllib.request.Request(url, headers={"User-Agent": legacy_ua})
css = urllib.request.urlopen(req, timeout=30).read().decode()

faces = {}
for block in re.findall(r"@font-face \{(.*?)\}", css, re.S):
    if "U+0000-00FF" not in block:       # latin subset only
        continue
    w = re.search(r"font-weight: (\d+)", block).group(1)
    faces[w] = re.search(r"url\((\S+?)\)", block).group(1)

missing = [w for w in weights if w not in faces]
if missing:
    sys.exit("could not find latin subset for weight(s): " + ", ".join(missing))
if len(set(faces.values())) != len(faces):
    sys.exit("Google returned one file for several weights (variable font); "
             "the legacy-UA trick has stopped working")

for w, u in sorted(faces.items()):
    path = os.path.join(dest, f"Archivo-{w}.woff2")
    urllib.request.urlretrieve(u, path)
    print(f"  Archivo-{w}.woff2  {os.path.getsize(path)} bytes")
PY
}

fonts_present() {
  local w
  for w in "${WEIGHTS[@]}"; do
    [[ -s "$FONT_DIR/Archivo-$w.woff2" ]] || return 1
  done
}

add_arg() {
  if [[ "$1" == *.html ]]; then
    [[ -f "$1" ]] || die "no such file: $1"
    files+=("$(realpath -- "$1")")
  else
    filters+=("$1")
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)         force=1 ;;
    -o|--output)     [[ $# -ge 2 && -n "$2" ]] || die "$1 needs a path"; out="$2"; shift ;;
    --refresh-fonts) refresh_fonts; exit 0 ;;
    -h|--help)       usage; exit 0 ;;
    --)              shift; for a in "$@"; do add_arg "$a"; done; break ;;
    -*)              printf 'error: unknown option: %s\n\n' "$1" >&2; usage >&2; exit 2 ;;
    *)               add_arg "$1" ;;
  esac
  shift
done

(( ${#files[@]} && ${#filters[@]} )) && die "give either .html files or sweep filters, not both"
[[ -z "$out" || ${#files[@]} -eq 1 ]] || die "-o needs exactly one .html file"
(( ${#files[@]} )) && force=1
command -v python3 >/dev/null 2>&1 || die "python3 is required"

if [[ -n "${CHROME_BIN:-}" ]]; then
  command -v "$CHROME_BIN" >/dev/null 2>&1 || die "CHROME_BIN=$CHROME_BIN not found"
  CHROME=("$CHROME_BIN")
else
  CHROME=()
  for c in google-chrome google-chrome-stable chromium chromium-browser \
           brave-browser microsoft-edge-stable; do
    command -v "$c" >/dev/null 2>&1 && { CHROME=("$c"); break; }
  done
  (( ${#CHROME[@]} )) || die "no Chrome/Chromium found. Set CHROME_BIN to your Chrome executable."
fi

if ! fonts_present; then
  echo "Archivo not fully installed in assets/fonts, fetching..."
  refresh_fonts
fi

TMPDIR_RUN="$(mktemp -d)"
cleanup() { rm -rf -- "$TMPDIR_RUN"; }
trap cleanup EXIT

# Percent-encoded file:// URI. Filenames here contain spaces and parentheses,
# which Chrome will not reliably parse unencoded.
file_uri() {
  python3 -c 'import pathlib,sys; print(pathlib.Path(sys.argv[1]).as_uri(), end="")' "$1"
}

# Appended last in <head>, so these @font-face rules win over the Google Fonts
# ones for the same family/weight/style. print-color-adjust keeps the coloured
# rules and section bars from being stripped as background decoration.
FONT_CSS=""
for w in "${WEIGHTS[@]}"; do
  FONT_CSS+="@font-face{font-family:'Archivo';font-style:normal;font-weight:$w;font-display:block;src:url($(file_uri "$FONT_DIR/Archivo-$w.woff2")) format('woff2');}"
done
HEAD_INJECT="<style>${FONT_CSS}@media print{*{-webkit-print-color-adjust:exact;print-color-adjust:exact;}}</style>"

# A PDF in an HTML/ directory goes to the sibling pdf/; anything else sits
# next to its source.
dest_for() {
  local src="$1" dir base
  dir="$(dirname -- "$src")"
  base="$(basename -- "${src%.html}")"
  if [[ "$(basename -- "$dir")" == HTML ]]; then
    printf '%s/pdf/%s.pdf' "$(dirname -- "$dir")" "$base"
  else
    printf '%s.pdf' "${src%.html}"
  fi
}

# The directory shown in the report and matched by filters, e.g. CV/Resumes.
section_of() {
  local dir rel
  dir="$(dirname -- "$1")"
  [[ "$(basename -- "$dir")" == HTML ]] && dir="$(dirname -- "$dir")"
  case "$dir" in
    "$ROOT")   rel="." ;;
    "$ROOT"/*) rel="${dir#"$ROOT"/}" ;;
    *)         rel="$dir" ;;
  esac
  printf '%s' "$rel"
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

page_count() {
  command -v pdfinfo >/dev/null 2>&1 || return 0
  pdfinfo "$1" 2>/dev/null | awk '/^Pages:/ { print $2 }'
}

fail_reason=""

render() {
  local src="$1" dest="$2" build="$TMPDIR_RUN/page.html" tmp_out="$TMPDIR_RUN/out.pdf" base_tag
  rm -f -- "$tmp_out"

  # Chrome renders its own error page rather than failing when it cannot read a
  # file, which would yield a plausible-looking but wrong PDF. Catch that here.
  [[ -r "$src" && -s "$src" ]] || { fail_reason="unreadable or empty"; return 1; }

  # The render copy lives in the temp dir; <base> keeps the source's relative
  # URLs resolving against its real directory.
  base_tag="<base href=\"$(file_uri "$(dirname -- "$src")")/\">"
  if ! awk -v base="$base_tag" -v inject="$HEAD_INJECT" '
      !b && /<head[^>]*>/ { sub(/<head[^>]*>/, "&" base); b = 1 }
      !d && /<\/head>/    { sub(/<\/head>/, inject "</head>"); d = 1 }
      { print }
      END { if (!b || !d) exit 3 }
    ' "$src" > "$build"; then
    fail_reason="no <head>...</head> to inject fonts into"
    return 1
  fi

  # Every hostname fails to resolve, so the Google Fonts stylesheet never
  # competes with the local faces and nothing waits on the network.
  "${CHROME[@]}" \
    --headless=new \
    --disable-gpu \
    --user-data-dir="$TMPDIR_RUN/profile" \
    --no-first-run \
    --no-default-browser-check \
    --disable-extensions \
    --host-resolver-rules="MAP * ~NOTFOUND" \
    --no-pdf-header-footer \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=10000 \
    --print-to-pdf="$tmp_out" \
    "$(file_uri "$build")" >/dev/null 2>&1 || { fail_reason="Chrome failed"; return 1; }

  # Chrome exits 0 on some failures, so the magic bytes are the real gate.
  [[ -s "$tmp_out" && "$(head -c4 -- "$tmp_out")" == "%PDF" ]] ||
    { fail_reason="no valid PDF produced"; return 1; }

  mkdir -p -- "$(dirname -- "$dest")"
  mv -f -- "$tmp_out" "$dest"
}

# Post-render checks. Prints one "; "-joined line of problems, or nothing.
check_pdf() {
  local pdf="$1" section="$2" pages="$3" fonts chars issues=()

  if [[ "$section" == */Resumes && -n "$pages" && "$pages" != "2" ]]; then
    issues+=("expected 2 pages")
  fi
  if [[ "$section" == */"Cover Letters" && -n "$pages" && "$pages" != "1" ]]; then
    issues+=("expected 1 page")
  fi

  if command -v pdffonts >/dev/null 2>&1; then
    fonts="$(pdffonts "$pdf" 2>/dev/null)"
    if grep -q 'Type 3' <<<"$fonts"; then
      issues+=("Type 3 fonts, run --refresh-fonts")
    elif ! grep -qi archivo <<<"$fonts"; then
      issues+=("Archivo not embedded")
    fi
  fi

  if command -v pdftotext >/dev/null 2>&1; then
    chars="$(pdftotext "$pdf" - 2>/dev/null | tr -d '[:space:]' | wc -c)"
    (( chars < MIN_TEXT_CHARS )) && issues+=("only $chars text chars, ATS may see nothing")
  fi

  local joined
  printf -v joined '%s; ' "${issues[@]}"
  (( ${#issues[@]} )) && printf '%s' "${joined%; }"
  return 0
}

if (( ${#files[@]} )); then
  srcs=("${files[@]}")
else
  mapfile -d '' srcs < <(
    cd -- "$ROOT" &&
      find . -mindepth 4 -maxdepth 4 -type f -path './*/*/HTML/*.html' -print0 | sort -z |
      while IFS= read -r -d '' f; do printf '%s\0' "$ROOT/${f#./}"; done
  )
fi

built=0
current=0
warnings=0
errors=0
found=0

for src in "${srcs[@]}"; do
  section="$(section_of "$src")"
  matches_filter "$section" || continue

  found=1
  base="$(basename -- "$src")"
  dest="${out:-$(dest_for "$src")}"
  row="$(printf '  %-24s %s' "$section" "${base%.html}")"

  if (( ! force )) && [[ -f "$dest" && ! "$src" -nt "$dest" ]]; then
    (( ++current ))
    continue
  fi

  if ! render "$src" "$dest"; then
    echo "$row ERROR    $fail_reason"
    (( ++errors ))
    continue
  fi

  (( ++built ))
  pages="$(page_count "$dest")"
  size="$(du -h -- "$dest" | cut -f1)"
  info="$size"
  [[ -n "$pages" ]] && info="$pages page$( [[ "$pages" == 1 ]] || printf s ), $size"

  issues="$(check_pdf "$dest" "$section" "$pages")"
  if [[ -n "$issues" ]]; then
    echo "$row built    $info  ! $issues"
    (( ++warnings ))
  else
    echo "$row built    $info"
  fi
done

if (( ! found )); then
  if (( ${#filters[@]} )); then
    printf 'No HTML files matched: %s\n' "${filters[*]}"
  else
    printf 'No HTML files found under */*/HTML/\n'
  fi
  exit 0
fi

printf '\n%d built, %d up to date, %d warning%s, %d error%s\n' \
  "$built" \
  "$current" \
  "$warnings" "$( (( warnings == 1 )) || printf s )" \
  "$errors" "$( (( errors == 1 )) || printf s )"

(( errors == 0 ))
