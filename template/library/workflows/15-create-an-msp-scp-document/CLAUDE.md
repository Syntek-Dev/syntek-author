@./CONTEXT.md

# CLAUDE.md — library/workflows/15-create-an-msp-scp-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Start a new managed-service document, plan a policy from the suite's structure and drive it
through the loop and the review to an approved `final`, or fill a report from its template.

## How to work here

- **Routing:** the `msp-scp-documents` skill, loaded first, holds the family's types, the suite and
  the checks; `library/docs/reference/msp-scp-standards.md` and `MSP-SCP-POLICY-SUITE.md` are its
  standard. `grill-with-docs` settles the brief; `obligation-check` reads every must-statement and
  `fact-check` every framework reference at the review's fact check.
- **Model:** **Opus** throughout for policies and operational documents; the mechanical tier for a
  report's dates, its rendering and ticks.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go. Steps 5 to 7
  are the policy route; step 8 the report route.
- **Definition of done:** the document carries the structure its type requires, its classification
  in its Document Control block and header, its review-date notice and its version history; every
  rule is auditable; every framework reference is verified; a policy is Active only with its
  approval recorded; its issue PDF sits beside the `.tex`.

## Guardrails

- **A policy describes what the business does.** A rule nobody follows is raised with the author,
  never written down as if it held.
- **'Aligned with', never 'certified to',** unless a certificate is filed and cited.
- **Never invent a control number, a statute or a section;** each carries `VERIFY` until checked.
- **No credential, network address, secret or access code** in any document: name where it is kept.
- **Active only on recorded approval,** in the register and the Document Control block alike.
- **An incident report states facts, not blame,** and never decides alone whether a regulator or a
  data subject must be told: that is the author's call.

## Output & naming

- **Produces:** the brief and the policy or operational `.tex`, or the filled report `.tex`, named
  to `msp-scp-standards.md`; the issue PDF.
- **Also writes:** register, review-schedule and approval rows through the planning procedures.
- **Does not touch:** any standard, any other client's folder, or a policy already approved.
