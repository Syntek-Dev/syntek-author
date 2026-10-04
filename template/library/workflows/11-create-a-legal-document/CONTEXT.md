# CONTEXT.md — library/workflows/11-create-a-legal-document/

The front door for a new instrument in the legal family: an agreement, a non-disclosure agreement,
a data processing agreement, a service level agreement, the business's terms or privacy notice, an
amendment, or a letter served under an instrument. It verifies the counterparty, settles the type
and its place, plans the clause groups from the parts `library/docs/reference/legal-standards.md`
requires, then drives the shared loop and the review to `final`, and on to execution when the
author records it.

## Directory Tree

```text
library/workflows/11-create-a-legal-document/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for a new instrument: 'draft an NDA with…', 'we need a services agreement for…',
  'write the data processing agreement', 'serve notice under the agreement'.
- A counterparty-neutral template is to be made for an instrument the business signs often.

Reach for a **different** procedure when: a counterparty has proposed changes to an instrument
already sent (a negotiation copy and a new version,
`library/docs/reference/versioning-and-the-register.md`); the starting point is an instrument
someone else drafted (`library/workflows/08-ingest-an-existing-document/`); a live instrument is
due its scheduled review (`planning/workflows/06-run-a-review-cycle/`); or the request is an
email about an instrument, which is correspondence, not an instrument.

## What it produces, and where

- **A unit brief** at `planning/src/units/<unit-slug>.md`, one section per clause group, the
  definitions first.
- **The counterparty's facts,** verified against the public register, under `## Facts` in its
  folder in `library/src/business/client-docs/`.
- **The instrument,** at `library/src/legal/client-docs/<client-slug>/`, the family root or
  `library/src/legal/templates/`, built through the loop, reviewed to `final`, registered, with
  its issue PDF; a row in `planning/src/precedence.md` when it belongs to a family of instruments.
- **On execution:** the signed copy filed beside it and the approval recorded.

## The failure this procedure exists to prevent

**An obligation nobody intended.** An instrument drafted fluently in one pass binds the business
to every 'shall' in it, defines terms twice, and cites clauses that have moved. Verifying the
counterparty first, planning the clause groups, and promoting each one on the author's word is
what keeps every obligation intended and every cross-reference true.

## Cross-references

- `library/docs/reference/legal-standards.md` — the types, parts, clause conventions and names.
- `library/docs/reference/latex-deliverables.md` — the `clause` list, labels and `\ref`.
- `planning/workflows/07-record-an-approval/` — recording execution.
