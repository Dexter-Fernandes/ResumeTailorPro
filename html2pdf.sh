#!/usr/bin/env bash
# Render a CV HTML file to a print-quality A4 PDF with headless Chrome.
#
#   ./html2pdf.sh Dexter_Fernandes_Sky_Principal_MLE.html
#   ./html2pdf.sh -o ~/Desktop/cv.pdf some_cv.html
#   ./html2pdf.sh --refresh-fonts        # re-download Archivo from Google Fonts
#   ./html2pdf.sh --sync                 # fill in missing PDFs under */*/HTML/*.html
#
# Why not print from the browser: Ctrl+P needs "Background graphics" ticked by
# hand, silently drops the coloured rules if you forget, and re-fetches webfonts
# every time. This is deterministic and offline.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FONT_DIR="$SCRIPT_DIR/assets/fonts"
WEIGHTS=(400 500 600 700 800)

OUT=""
ONLINE=0
OPEN=0
SYNC=0
INPUT=""

die() { printf 'error: %s\n' "$1" >&2; exit 1; }
note() { printf '  %s\n' "$1"; }

# --- Chrome ------------------------------------------------------------------
find_chrome() {
  local c
  for c in google-chrome google-chrome-stable chromium chromium-browser \
           brave-browser microsoft-edge-stable; do
    command -v "$c" >/dev/null 2>&1 && { printf '%s' "$c"; return 0; }
  done
  command -v flatpak >/dev/null 2>&1 &&
    flatpak info org.chromium.Chromium >/dev/null 2>&1 &&
    { printf '%s' "flatpak run org.chromium.Chromium"; return 0; }
  return 1
}

# --- Fonts -------------------------------------------------------------------
# Google Fonts serves Archivo as a *variable* font to modern browsers. Chrome's
# PDF backend cannot subset-embed those, so it emits Type 3 fonts: glyphs drawn
# as vector procedures, ~4x the file size and no real typeface in the PDF.
# A legacy user-agent gets you static per-weight instances, which embed properly
# as CID TrueType subsets.
refresh_fonts() {
  command -v python3 >/dev/null 2>&1 || die "--refresh-fonts needs python3"
  mkdir -p "$FONT_DIR"
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

# file:// URL, with the few characters that actually bite in paths escaped.
to_file_url() {
  printf 'file://%s' "$(printf '%s' "$1" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/#/%23/g' -e 's/?/%3F/g')"
}

# --- Render one HTML file to a PDF -------------------------------------------
# Builds a local-fonts render copy beside the source, runs headless Chrome,
# then verifies the result. $1 = source .html, $2 = destination .pdf.
render_pdf() {
  local RENDER_IN="$1" RENDER_OUT="$2"
  local BUILD PROFILE

  # Written beside the source so relative paths in the HTML still resolve.
  # The injected block goes last in <head>, so its @font-face rules override
  # any Google Fonts ones already declared for the same family/weight/style.
  BUILD="$(dirname "$RENDER_IN")/.$(basename "${RENDER_IN%.*}").render.html"
  trap 'rm -f "$BUILD"' EXIT

  {
    local face_css="" w inject
    for w in "${WEIGHTS[@]}"; do
      face_css+="@font-face{font-family:'Archivo';font-style:normal;font-weight:$w;font-display:block;src:url($(to_file_url "$FONT_DIR/Archivo-$w.woff2")) format('woff2');}"
    done
    # print-color-adjust keeps the coloured rules and section bars from being
    # stripped by any print path that decides backgrounds are decoration.
    inject="<style>${face_css}@media print{*{-webkit-print-color-adjust:exact;print-color-adjust:exact;}}</style>"
    awk -v inject="$inject" '
      !done && /<\/head>/ { sub(/<\/head>/, inject "</head>"); done = 1 }
      { print }
      END { if (!done) exit 3 }
    ' "$RENDER_IN"
  } > "$BUILD" || die "no </head> in $RENDER_IN; cannot inject fonts"

  PROFILE="$(mktemp -d)"                 # never touch the user's live Chrome profile
  trap 'rm -f "$BUILD"; rm -rf "$PROFILE"' EXIT

  local net_flags=(--host-resolver-rules="MAP * ~NOTFOUND")   # fully offline, no font race
  (( ONLINE )) && net_flags=()

  # shellcheck disable=SC2086
  $CHROME \
    --headless \
    --disable-gpu \
    --user-data-dir="$PROFILE" \
    --no-first-run --no-default-browser-check \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=20000 \
    "${net_flags[@]}" \
    --no-pdf-header-footer \
    --print-to-pdf="$RENDER_OUT" \
    "$(to_file_url "$BUILD")" 2>/dev/null \
    || die "Chrome failed to render"

  [[ -s "$RENDER_OUT" ]] || die "no PDF produced"

  echo "Wrote $RENDER_OUT ($(du -h "$RENDER_OUT" | cut -f1))"

  if command -v pdfinfo >/dev/null 2>&1; then
    note "$(pdfinfo "$RENDER_OUT" | awk '/^Pages:/{p=$2} /^Page size:/{sub(/^Page size: */,""); s=$0} END{print p " page(s), " s}')"
  fi

  if command -v pdffonts >/dev/null 2>&1; then
    if pdffonts "$RENDER_OUT" | grep -q 'Type 3'; then
      note "WARNING: Type 3 fonts present - the webfont did not load, run --refresh-fonts"
    elif pdffonts "$RENDER_OUT" | grep -qi archivo; then
      note "fonts: Archivo embedded as TrueType subsets"
    else
      note "WARNING: Archivo not in the PDF, it fell back to a system font"
    fi
  fi

  if command -v pdftotext >/dev/null 2>&1; then
    local chars
    chars=$(pdftotext "$RENDER_OUT" - | tr -d '[:space:]' | wc -c)
    if (( chars < 1000 )); then
      note "WARNING: only $chars extractable characters - ATS parsers may see nothing"
    else
      note "text layer: $chars characters extractable"
    fi
  fi

  rm -f "$BUILD"; rm -rf "$PROFILE"
  trap - EXIT
}

# --- Args --------------------------------------------------------------------
while (( $# )); do
  case "$1" in
    -o|--output)     OUT="${2:-}"; [[ -n "$OUT" ]] || die "-o needs a path"; shift 2 ;;
    --online)        ONLINE=1; shift ;;          # allow network (remote images etc.)
    --open)          OPEN=1; shift ;;
    --sync)          SYNC=1; shift ;;             # fill in missing PDFs under */*/HTML/*.html
    --refresh-fonts) refresh_fonts; exit 0 ;;
    -h|--help)       awk 'NR>1 { if (!/^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"; exit 0 ;;
    -*)              die "unknown option: $1" ;;
    *)               [[ -z "$INPUT" ]] || die "only one input file"; INPUT="$1"; shift ;;
  esac
done

if (( SYNC )); then
  [[ -z "$INPUT" ]] || die "--sync does not take a file argument"
  [[ -z "$OUT" ]] || die "--sync does not support -o"
else
  # No argument and exactly one HTML file next to the script: use it.
  if [[ -z "$INPUT" ]]; then
    shopt -s nullglob
    candidates=("$SCRIPT_DIR"/*.html)
    shopt -u nullglob
    (( ${#candidates[@]} == 1 )) || die "usage: $(basename "$0") [-o out.pdf] file.html"
    INPUT="${candidates[0]}"
  fi

  [[ -f "$INPUT" ]] || die "no such file: $INPUT"
  INPUT="$(cd -- "$(dirname -- "$INPUT")" && pwd)/$(basename -- "$INPUT")"
  [[ -n "$OUT" ]] || OUT="${INPUT%.*}.pdf"
fi

CHROME="$(find_chrome)" || die "no Chrome/Chromium found"

if ! fonts_present; then
  echo "Archivo not fully installed in assets/fonts, fetching..."
  refresh_fonts
fi

if (( SYNC )); then
  # --- Sync: fill in any PDF missing from its own HTML directory's sibling
  # pdf/ directory. Each file is checked against dirname(dirname(html))/pdf,
  # never against another track's pdf/ that the glob also happens to match.
  shopt -s nullglob
  html_files=("$SCRIPT_DIR"/*/*/HTML/*.html)
  shopt -u nullglob
  (( ${#html_files[@]} )) || die "no HTML files found matching */*/HTML/*.html"

  made=0
  skipped=0
  for html in "${html_files[@]}"; do
    html_dir="$(dirname "$html")"
    pdf_dir="$(dirname "$html_dir")/pdf"
    pdf="$pdf_dir/$(basename "${html%.*}").pdf"
    if [[ -s "$pdf" ]]; then
      (( ++skipped ))
      continue
    fi
    mkdir -p "$pdf_dir"
    echo "-> ${html#"$SCRIPT_DIR"/}"
    render_pdf "$html" "$pdf"
    (( ++made ))
  done
  echo "sync done: $made generated, $skipped already present"
  exit 0
fi

render_pdf "$INPUT" "$OUT"

(( OPEN )) && command -v xdg-open >/dev/null 2>&1 && xdg-open "$OUT" >/dev/null 2>&1 &
exit 0
