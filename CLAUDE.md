# CV Repository -- Dexter Fernandes

Working repo for tailoring CVs to computer vision, robotics, perception and edge ML roles.

## File map

One directory per application track: `CV/`, `Robotics/`, `LLM/`, `SLAM/`, `Software/`,
`PLC/`. Each holds its own master resume, scoped to that track. Work from the track
directory; paths below are relative to it.

| Path | Role |
|---|---|
| `./Dexter_Fernandes_Master_CV.md` | This track's source of truth for all roles, dates, metrics, projects, skills, contact details |
| `../Dexter_Fernandes_Resume_template.html` | Shared across tracks. The only permitted output format. Structure and CSS are fixed |
| `Resumes/HTML/` | The only place a tailored CV is written |
| `Resumes/JD/` | The job listing each tailored CV was written for, same basename as its HTML |
| `.claude/skills/resume-tailor/SKILL.md` | The 12-step tailoring workflow |

## Standing rules (apply to every task in this repo)

- UK English.
- Every candidate claim traces to `Dexter_Fernandes_Master_CV.md` or to an explicit factual addition the user supplies in-session. Never invent or exaggerate tools, metrics, titles, dates, employers, responsibilities, scale, outcomes or production experience.
- Never edit the master CV or the template unless explicitly asked. They are the source of truth.
- Never redesign `Dexter_Fernandes_Resume_template.html`. Populate its existing slots only.
- Company facts come only from the job listing, the user, or verified research.
- No em dashes anywhere. Use a double hyphen or restructure the sentence.
- Keep explanations brief. Explain from first principles when a concept needs explaining.
- One clarifying question at a time. Never re-ask a fact already confirmed in-session.

## Workflow entry

To tailor a CV, run `/tailor` with the job listing, or ask directly. Either invokes the
`resume-tailor` skill. Do not improvise a shorter path: the step gates exist to stop
fabrication and premature drafting.
