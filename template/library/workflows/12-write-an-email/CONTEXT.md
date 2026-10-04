# CONTEXT.md — library/workflows/12-write-an-email/

The procedure for writing one email to a client or a supplier. An email is a one-section document:
this procedure settles the correspondent and the family that governs the substance, reads every
other unsent email to the same correspondent, plans the one thing the email asks, then drives the
body through the shared loop into an authored email with the four-part anatomy, reviewed and
waiting at Draft for the author to send.

## Directory Tree

```text
library/workflows/12-write-an-email/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for an email: 'write to… about…', 'reply to their question', 'send the
  proposal over', 'follow up with…', 'ask three suppliers to quote for…'.
- A recurring email is to become a template in `library/src/email/templates/`.

Reach for a **different** procedure when: the author has written the email and wants it improved
(`library/workflows/03-improve-your-draft/` on its draft, then this procedure from step 7); the
letter is a formal notice served under a contract (an instrument: the legal family's create
procedure where this project has that family; otherwise raise it with the author); or a thread is
to be kept as a record (an archived thread is filed as received, and nothing in this procedure
applies to it).

## What it produces, and where

- **A one-section brief** at `planning/src/units/<unit-slug>.md`: the correspondent, the matter,
  the one ask, and what the email must not promise.
- **A body draft** at `library/src/email/drafts/<unit-slug>/01-body.md`, with its ledger entry.
- **The authored email** at
  `library/src/email/client-emails/<client-slug>/<family>/<subject-line>-<DD-MM-YYYY>.md` (or in
  `supplier-emails/<matter-slug>/`), its `**Status:**` at Draft, listed in its folder's
  `CONTEXT.md` and registered.

## The failure this procedure exists to prevent

**Two emails that contradict each other, or one that promises what no instrument carries.** Emails
are written quickly and days apart; read alone, each looks right. Reading every unsent email to the
same correspondent first, filing by the family that governs the substance, and tracing each
commitment to its instrument is what keeps the record consistent.

## Cross-references

- `library/docs/reference/email-standards.md` and its sub-document — the mechanics.
- `library/docs/reference/<family>-standards.md` — the substance, by the leaf's family.
- `library/workflows/01-draft-a-section/`, `library/workflows/04-promote-a-section/` — the loop
  the body runs through.
