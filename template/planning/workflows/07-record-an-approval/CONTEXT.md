# CONTEXT.md — planning/workflows/07-record-an-approval/

The procedure for recording an approval event: an instrument signed by all parties, a policy
approved as `Active`, or a notice issued. It confirms every detail with the author, writes one
record in the Approvals path (`00-project.md` `## Paths`; by default `planning/src/approvals/`),
and moves the document's register row to the status the event produced. It records what
happened; it never decides that something was approved.

## Directory Tree

```text
planning/workflows/07-record-an-approval/
├── CONTEXT.md          ← this file (when to use, what it produces)
├── CLAUDE.md           ← operating rules for this workflow
├── STEPS.md            ← ordered steps to execute
└── CHECKLIST.md        ← verification checklist before marking complete
```

## When to use this

- An agreement, contract or non-disclosure agreement has been signed by every party.
- A policy has been formally approved and published as `Active`.
- A notice has been issued to the other party, such as a termination letter.

Reach for a **different** procedure when: the document is a template, a draft, a proposal, an
invoice or a report (no record is made; update the register with `08-update-the-register` if
its status changed); or the document is not yet registered (`08-update-the-register` first).

## What it produces, and where

- `approval-<doc-type>-DD-MM-YYYY.md` in the Approvals path (`00-project.md` `## Paths`; by
  default `planning/src/approvals/`) — one record per event, dated by the approval.
- The register row's Status set to `Executed` or `Active`, and Last Reviewed where the approval
  was a formal review.
- A review-schedule row added or changed, where the event sets a review date.

## The failure this procedure exists to prevent

A register that says `Executed` with nothing behind it. Months later, when someone asks who
signed, which version and when, the answer has to be reconstructed from email, or cannot be.
A record written at the time, with every field confirmed, is the evidence.

## Cross-references

- `planning/docs/reference/the-document-register.md` — when a record is made, and what follows.
- `planning/src/approvals/CONTEXT.md` — the record's fields, where the Approvals folder has no
  `CONTEXT.md` of its own giving them.
- `planning/src/document-register.md` — the row the record updates.
