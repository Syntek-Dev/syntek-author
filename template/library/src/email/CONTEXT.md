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
  `client-emails/<client-slug>/<family>/<YYYY-MM-DD-HH-MM>-<topic>/<subject-line>-<DD-MM-YYYY>.md`.
  The `<family>` leaf is a
  declaration, not decoration: it names the family whose standard governs the email's substance,
  and so the skill loaded beside `email-documents`. A covering email for a proposal is
  `business/`; a reply about a disputed clause is filed under the family that owns the instrument.
  Where an email spans families, it goes under the family that owns the engagement, and its
  internal note says so.
- **One folder per email.** Each email, its `.html` and anything only it uses sit in
  `<YYYY-MM-DD-HH-MM>-<topic>/` inside its leaf (a client's family leaf or a supplier matter
  folder): the date is the filename's, the time is when it was drafted (`00-00` where unknown),
  and `<topic>` is the filename's stem without its date. It carries no folder pair: the leaf's
  `CONTEXT.md` lists it, as a `drafts/` folder is governed by its parent. A changed subject renames
  the folder with its files. An archived thread whose copies are filed under the data root stays
  where its manifest rows put it.
- **Old paths in records.** Emails filed flat before v0.10.0 stay where they are. A record (the
  register, `.claude/MEMORY.md`, a handoff, a sent email's internal note) that names
  `<leaf>/<stem>.md` names that file where it stands; if the author has moved it, it is at
  `<leaf>/<YYYY-MM-DD-HH-MM>-<topic>/<stem>.md` (find the folder ending `-<topic>`). The record is
  never edited to match. The author may move an old email by hand.
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
