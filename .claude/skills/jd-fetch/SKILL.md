---
name: jd-fetch
description: Fetch job listings from LinkedIn (the saved-jobs tracker, or a single job URL) with Claude in Chrome and save each as a JD file in JDs/ for the resume-tailor skill. Use when asked to pull, fetch, scrape or save job descriptions from LinkedIn.
argument-hint: "[tracker or job URL, default https://www.linkedin.com/jobs-tracker/?stage=saved]"
allowed-tools: Read, Glob, Grep, Write(/JDs/**), mcp__claude-in-chrome__*
---

# JD Fetch

Single agent, one browser tab, one job at a time. Never spawn subagents. Write only to
`JDs/`. Do not tailor, edit the master CV or touch any CV directory.

## Browser setup

Load the Chrome tools in one ToolSearch call (`tabs_context_mcp`, `tabs_create_mcp`,
`tabs_close_mcp`, `navigate`, `find`, `get_page_text`, `computer`). Call
`tabs_context_mcp` first and work in a new tab; never reuse the user's tabs. If the
extension is not connected or a site is refused, say so and stop. After 2 to 3 failed
attempts on a step, stop and ask. Close the tab you created before finishing.

## Steps

1. **Collect job links.** URL defaults to
   `https://www.linkedin.com/jobs-tracker/?stage=saved`.
   - A `/jobs/view/<id>/` URL is a single job: skip to step 2 with that one id.
   - A tracker URL: use `read_page` with `filter: "interactive"` for the job title links
     (`href` contains `/jobs/view/<id>/`) on each page, then click the numbered pager to
     reach the next page until the last. Collect ids in page order. Hrefs are relative and
     every job appears twice, so de-duplicate by id. `find` returns only about 11 matches
     and misses jobs; use it only to locate one known title.
2. **Skip duplicates.** `grep -l "jobs/view/<id>" JDs/` for each id. A hit means skip and
   report; never overwrite.
3. **Fetch each remaining job**, sequentially. Navigate to
   `https://www.linkedin.com/jobs/view/<id>/`, wait 3 seconds, then run `get_page_text`.
   Make each of the three a separate, sequential call: batched together, the wait and the
   read run before the page loads and fail with "unparseable URL". Wait 3 to 5 seconds
   before the next job.
4. **Parse the page text.**
   - Company: the line after `Source element: <main>` / `---`.
   - Role: the next non-empty line.
   - Location: the third line, text before the first `·`, first comma-separated part
     only (`Cambridge, England, United Kingdom` becomes `Cambridge`). `Remote` if the
     listing is remote.
   - Brand: write the company as its brand name, not the legal one. Drop `Ltd`, `Limited`, `plc`, `Inc`,
     `(UK)` and trailing divisions (`Huawei Technologies Research & Development (UK) Ltd`
     becomes `Huawei`). Keep a distinguishing brand word (`Amazon Science`).
   - Body: everything after `About the job`, minus the `Description` label, up to but
     excluding the first of `… more` or `Set alert for similar jobs`. `… more` is only a
     button label and the text before it is already complete: never click it. Ignore any
     block before `About the job` (such as `People you can reach out to`). Copy verbatim: do not
     reformat, summarise, fix spelling or strip em dashes. Blank-line separation only.
   - No body found, or fewer than about 100 words: do not write a file; report it.
   - Header fields: decide all three per the Header rules below. None may be `TBD`.
5. **Write** `JDs/<Position>_<Company>_<Location>.md`. Words joined by underscores in the
   listing's capitalisation, no spaces, `/`, `|`, `,` or other characters unsafe in
   filenames. If the file exists, skip and report. Format:

   ```markdown
   # <Company> -- <Role>

   - Saved: <YYYY-MM-DD>
   - Channel: <channel>
   - Seniority: <stretch | match | step down>
   - CV: <Track>/Resumes/HTML/Dexter_Fernandes_CV_<Company>_<Role>.html
   - Source: https://www.linkedin.com/jobs/view/<id>/

   ---

   <body>
   ```

6. **Report** a table of `saved`, `skipped (duplicate | exists)` and `failed` jobs with
   filenames. Reply text only; write no log file.

## Header rules

Read `Dexter_Fernandes_Master_CV.md` once, before the first job, and judge every header
field against it. Never edit it. These are the same calls `resume-tailor` Step 1 makes,
so the user can still change any of them at its Step 4 gate.

- **Channel:** `cold ATS portal`. If the poster is a recruitment agency with an unnamed
  end client, `Recruiter (<agency> agency listing, end client unnamed)`.
- **Seniority:** `stretch` if the listing asks for more level or experience than the
  master CV shows (years, ownership, scope, a named domain it lacks), `step down` if the
  role is below it, otherwise `match`. Judge only against the master CV and its Known
  Gaps; one word.
- **Track:** from the listing's first core responsibility. `CV` computer vision and
  perception ML; `Robotics` robotics software and autonomy; `SLAM` localisation and
  mapping; `LLM` LLMs and generative AI; `Software` general software engineering; `PLC`
  industrial automation. Two fit equally: take the one matching the first responsibility.
- **CV path:** `<Track>/Resumes/HTML/Dexter_Fernandes_CV_<Company>_<Role>.html`, with
  Company and Role underscore-joined and filename-safe, the same strings as the JD
  filename.
