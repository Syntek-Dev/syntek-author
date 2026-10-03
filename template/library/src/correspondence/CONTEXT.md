# CONTEXT.md — library/src/correspondence/

The correspondence family: what the business writes to one reader at a time. Formal letters
(notices, letters of engagement, payment plans) are LaTeX `.tex` files; authored emails are
Markdown `.md` files with the house email anatomy; archived threads are exports kept as a record.
Filed by counterparty in `client-docs/<client-slug>/`, whether the counterparty is a client, a
supplier or anyone else. The instruments a letter refers to live in `library/src/contracts/`.

## Directory Tree

```text
library/src/correspondence/
├── CONTEXT.md              ← this file
├── CLAUDE.md               ← operating rules
├── templates/              ← reusable letter and email starting points
├── client-docs/            ← one <client-slug>/ folder per counterparty
└── drafts/                 ← section drafts, one <unit-slug>/ folder per letter or email (README.md only)
```

## What's here

- **Authored emails** — `<subject-line-kebab>-<DD-MM-YYYY>.md`, a reply prefixed `re-`. Anatomy:
  `# Email: <purpose>, <recipient>, <DD/MM/YYYY>`; the `**To:**`, `**From:**`, `**Attachment:**`
  and `**Status:**` lines; the internal note as a blockquote opening 'Internal note, not to be
  sent.'; a horizontal rule; `**Subject:**`; then the body. Nothing above the rule is ever sent.
- **Letters** — `<letter-type>-<client-slug>-<DD-MM-YYYY>.tex`, built from the house skeleton.
- **Archived threads** — mail exported as a record. Immutable: never edited, renamed or re-rendered.
- **Status.** An email's `**Status:**` line moves from Draft to sent, and only on the author's
  word: it is the only record of whether the reader has seen the content.

## Cross-references

- `library/docs/reference/document-anatomy.md` — the email and letter anatomy.
- `library/src/contracts/client-docs/` — the counterparty's facts, cited, never copied.
- `standards/brand/brand-voice.md` — the voice of running copy, which emails use.
