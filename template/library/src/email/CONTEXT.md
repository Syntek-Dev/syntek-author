# CONTEXT.md — library/src/email/

The email family: everything the business writes to one correspondent at a time by email, and the
threads it keeps as a record. Correspondence is held here, in one place, rather than in each
client's document folders, because it is one continuous record of what was asked, what was
promised and when: a client's whole email history reads as one thread whichever part of the
business it concerns. A formal notice served under a contract is an instrument, not an email, and
is never filed here.

## Directory Tree

```text
library/src/email/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable email starting points, template-<purpose>.md
├── client-emails/          ← one <client-slug>/ folder per client, split by the family that governs
├── supplier-emails/        ← correspondence with suppliers, filed by matter
└── drafts/                 ← section drafts, one <unit-slug>/ folder per email (README.md only)
```

## What's here

- **The filing pattern** —
  `client-emails/<client-slug>/<family>/<subject-line>-<DD-MM-YYYY>.md`. The `<family>` leaf is a
  declaration, not decoration: it names the family whose standard governs the email's substance,
  and so the skill loaded beside `email-documents`. A covering email for a proposal is
  `business/`; a reply about a disputed clause is filed under the family that owns the instrument.
  Where an email spans families, it goes under the family that owns the engagement, and its
  internal note says so.
- **Two kinds of artefact.** An **authored email** is one the business writes to send: Markdown,
  with the four-part anatomy (title, metadata, internal note, then subject and body), editable
  until sent. An **archived thread** is a mail-client export of what was actually sent and
  received, kept as evidence: never edited, renamed, restyled or re-rendered.
- **Status.** An authored email's `**Status:**` line moves from Draft to sent only on the author's
  word: it is the only record of whether the reader has seen the content.
- **Derived copies.** A rich-text or HTML copy made for pasting into a mail client is one-way:
  regenerate it from the `.md`, never edit it.
- **Anatomy, subject lines, naming and the checks** are in
  `library/docs/reference/email-standards.md` and its sub-document.

## Cross-references

- `library/docs/reference/email-standards.md` — this family's standard: the mechanics.
- `library/docs/reference/<family>-standards.md` — the standard of the leaf's family: the
  substance.
- `library/workflows/12-write-an-email/` — the procedure that writes an email here.
- `library/src/business/client-docs/` — the client's facts, cited, never copied.
