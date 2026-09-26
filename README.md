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

## Confirming page count

There is no PDF export. After Step 11, open the generated file in a browser and print
to PDF at A4:

```bash
open applications/<dir>/CV.html      # macOS
xdg-open applications/<dir>/CV.html  # Linux
```

The template already carries `@page { size:A4; margin:0.5in }` and a print media query,
so browser print output matches the previous WeasyPrint result closely. Check for two
pages, no stranded headings, and no single orphaned bullet on page 2.

## Keeping memory current

Claude Code has no automatic memory. `PROFILE.md` is it. Step 11 instructs Claude to
append to the application log and record new durable facts there. In-session, `#` prefixes
a message to append it to memory, and `/memory` opens the files for editing. Review
`PROFILE.md` occasionally: stale locked metrics or a resolved framing question left in
place will quietly steer future applications wrong.
