# CONTEXT.md — library/workflows/15-create-an-msp-scp-document/

The front door for a new document in the managed-service family: a policy in the business's suite
or a client's, an operational document (a runbook, a network topology), or a report filled per
period or event (a service report, an incident report, a change request). A policy or an
operational document is planned from the structure `library/docs/reference/msp-scp-standards.md`
and its sub-document require, driven through the shared loop and the review to `final`, and made
Active only once its approval is recorded. A report is filled from its template and confirmed by
the author.

## Directory Tree

```text
library/workflows/15-create-an-msp-scp-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for a new policy: 'we need an incident response plan', 'write the acceptable use
  policy for…'.
- A managed-service client needs a runbook, a topology, or this period's service report; an
  incident or a change needs its report.

Reach for a **different** procedure when: a live policy is due its scheduled review
(`planning/workflows/06-run-a-review-cycle/`); a policy is to be changed after approval (a new
version, `library/docs/reference/versioning-and-the-register.md`); or the document is a contract
for the managed service itself (the legal family's create procedure, where this project has it).

## What it produces, and where

- **A policy or operational document** at the family root (the business's own) or
  `library/src/msp-scp/client-docs/<client-slug>/`: a brief, sections through the loop, a review
  to `final`, its register and review-schedule rows, its approval, and its issue PDF.
- **A report** at `library/src/msp-scp/client-docs/<client-slug>/reports/`, filled from its
  template, dated, confirmed by the author, with its issue PDF.

## The failure this procedure exists to prevent

**A policy the business does not follow, or a certification it does not hold.** A policy written
to sound complete commits the business to controls nobody operates, and 'compliant with' a
framework is a claim a client will rely on. Confirming what the business actually does, verifying
every framework reference, and making a policy Active only on recorded approval is what keeps the
suite honest.

## Cross-references

- `library/docs/reference/msp-scp-standards.md` — the types, names and reviews.
- `library/docs/reference/MSP-SCP-POLICY-SUITE.md` — the suite's order, the policy structure and
  the operational documents' parts.
- `planning/workflows/07-record-an-approval/` — a policy becomes Active only once approved.
