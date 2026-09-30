# CV Repository -- Dexter Fernandes

Working repo for tailoring CVs to computer vision, robotics, perception and edge ML roles.

## File map

One directory per application track: `CV/`, `Robotics/`, `LLM/`, `SLAM/`, `Software/`,
`PLC/`. A track holds its CV outputs; the master resume, template and `JDs/` are shared at
the repo root. Work from the track directory; paths below are relative to it.

| Path | Role |
|---|---|
| `../Dexter_Fernandes_Master_CV.md` | Single source of truth for all roles, dates, metrics, projects, skills, contact details. Shared across tracks |
| `../Dexter_Fernandes_Resume_template.html` | Shared across tracks. The only permitted output format. Structure and CSS are fixed |
| `../Dexter_Fernandes_Cover_Letter_template.html` | Shared across tracks. The only permitted cover letter format. Structure and CSS are fixed |
| `Resumes/HTML/` | The only place a tailored CV is written |
| `Cover Letters/HTML/` | The only place a cover letter is written (optional Step 12, after the user approves the text) |
| `../JDs/` | Every job listing, all tracks, as `<Position>_<Company>_<Location>.md`. Written at Step 1 |
| `../.claude/skills/resume-tailor/SKILL.md` | The 12-step tailoring workflow. `../.agents/skills/resume-tailor` is a symlink to it for Codex |
| `../.claude/agents/cv-html-builder.md` | Claude Code only. Assembles the HTML at Step 10 from approved content; only the skill may dispatch it |

## Standing rules (apply to every task in this repo)

- UK English.
- Every candidate claim traces to `Dexter_Fernandes_Master_CV.md` or to an explicit factual addition the user supplies in-session. Never invent or exaggerate tools, metrics, titles, dates, employers, responsibilities, scale, outcomes or production experience.
- Never edit the master CV or the template unless explicitly asked. They are the source of truth. The one workflow exception: before the strategy is approved, a user-supplied experience bullet may be added to the master CV (see the skill's Flow control).
- Never add PLC or industrial-automation content to the master CV, even when asked to record a fact from a PLC application. `PLC/` still reads the root master and tailors from transferable experience only.
- Never redesign `Dexter_Fernandes_Resume_template.html` or `Dexter_Fernandes_Cover_Letter_template.html`. Populate their existing slots only.
- Company facts come only from the job listing, the user, or verified research.
- No em dashes anywhere. Use a double hyphen or restructure the sentence.
- Keep explanations brief. Explain from first principles when a concept needs explaining.
- One clarifying question at a time. Never re-ask a fact already confirmed in-session.

## Workflow entry

To tailor a CV, supply the job listing, or ask directly. In Claude Code, `/resume-tailor <listing>`
also works; in Codex, `$resume-tailor <listing>`. Every route invokes the `resume-tailor`
skill. Do not improvise a shorter path: the step gates exist to stop
fabrication and premature drafting.
