---
description: Start the ResumeTailor Pro 12-step workflow for a job listing
---

Invoke the `resume-tailor` skill and run it from Step 1.

Job listing or context supplied:

$ARGUMENTS

If nothing was supplied above, or the listing is partial, ask for the missing Step 1
inputs only: application channel, seniority assessment, the full listing, and any company
context the user already has. Do not ask for the master CV or template; at Step 2 read
both from the directory above the working directory.

Complete Steps 1 to 4 in one reply, label each step, and stop at the Step 4 confirmation
gate.

The workflow writes exactly two files: the job listing in `Resumes/JD/` at Step 1 and the
tailored CV HTML in `Resumes/HTML/` at Step 10. No strategy, log or cover letter files,
and no edits to existing files.
