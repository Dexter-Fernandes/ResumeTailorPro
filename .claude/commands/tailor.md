---
description: Start the ResumeTailor Pro 12-step workflow for a job listing
---

Invoke the `resume-tailor` skill and run it from Step 1.

Job listing or context supplied:

$ARGUMENTS

If nothing was supplied above, or the listing is partial, ask for the missing Step 1
inputs only: application channel, seniority assessment, the full listing, and any company
context the user already has. Do not ask for the master CV or template; read them from the
current track directory at Step 2.

The run writes exactly one file: the tailored HTML CV in `Resumes/HTML/`. The cover letter
is written only when the user asks for Step 12. No listing, strategy, log or review files.

Complete Steps 1 to 4 in one reply, label each step, and stop at the Step 4 confirmation
gate.
