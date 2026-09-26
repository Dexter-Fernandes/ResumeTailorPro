# Setup

```bash
git init
git add . && git commit -m "CV tailoring workspace"
claude
```

Claude Code reads `CLAUDE.md` (and its `@PROFILE.md` import) automatically at session
start. The skill and slash command are discovered from `.claude/`.

## Running an application

```
/tailor <paste the job listing>
```

or just paste a listing and ask for a tailored CV. Both route to the same skill.

Steps 1 to 4 run in one pass and stop at the strategy gate. Approve or adjust, then
continue step by step, or say `fast mode` to batch Steps 5 to 11. Fast mode shows the
Summary and Skills first and waits for approval before writing the rest.

## Exporting to PDF

After Step 11, render with `html2pdf.sh` from the repo root:

```bash
./html2pdf.sh                        # build every missing or stale PDF under */*/HTML/
./html2pdf.sh CV SLAM/Resumes        # limit the sweep to tracks or directories
./html2pdf.sh --dry-run              # list what would be built
./html2pdf.sh --force CV             # rebuild regardless of timestamps
./html2pdf.sh --open path/to/CV.html # render one file, always, then open it
./html2pdf.sh -o ~/cv.pdf CV.html    # render one file to a chosen path
```

PDFs from `<Track>/<Section>/HTML/` land in the sibling `pdf/` directory under the same
basename. Rendering is headless Chrome (set `CHROME_BIN` to override detection), fully
offline, with Archivo loaded from `assets/fonts/`. Local static fonts matter: the variable
font Google Fonts serves cannot be embedded properly by Chrome's PDF backend, so it falls
back to Type 3 glyph drawings (about 4x the file size, weaker ATS text layer). If the
fonts are missing they are fetched automatically; `./html2pdf.sh --refresh-fonts` re-fetches
them.

Each PDF is checked after rendering, and problems are flagged with `!` on its line:
a resume that is not two pages, Type 3 fonts or Archivo missing, and too little extractable
text for an ATS. Warnings do not change the exit status; a failed render does.

The script only counts pages, so still open the PDF and check for stranded headings or a
single orphaned bullet on page 2.

## Keeping memory current

Claude Code has no automatic memory. `PROFILE.md` is it. Step 11 instructs Claude to
append to the application log and record new durable facts there. In-session, `#` prefixes
a message to append it to memory, and `/memory` opens the files for editing. Review
`PROFILE.md` occasionally: stale locked metrics or a resolved framing question left in
place will quietly steer future applications wrong.
