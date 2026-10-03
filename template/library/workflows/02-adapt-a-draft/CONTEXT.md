# CONTEXT.md — library/workflows/02-adapt-a-draft/

The procedure for revising a section draft from the author's notes, or after the author has
edited it by hand: change only what was flagged, offer two or three alternatives where a line is
contested, and leave everything else word for word. The same procedure turns a template into a
client document, adapting each section to one client without loosening a single term.

## Directory Tree

```text
library/workflows/02-adapt-a-draft/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author has read a draft and given notes: 'too formal', 'the payment terms are 14 days, not
  30', 'drop the second example', 'this promises too much'.
- The author has edited a draft directly and wants the rest brought into line with the edit.
- A document is to be made from a template for a named client.

Reach for a **different** procedure when: the author wrote the section and wants the AI's
suggestions (`library/workflows/03-improve-your-draft/`); the section does not exist yet
(`library/workflows/01-draft-a-section/`); the author has approved the section as it stands
(`library/workflows/04-promote-a-section/`); or the source is a document from outside the library
that has not been brought in yet (`library/workflows/08-ingest-an-existing-document/`).

## What it produces, and where

- **The revised draft**, in place, at `status: adapted`, its `last_updated` set.
- **Alternatives** for each contested line, in the hand-back, for the author to choose from.
- **Ledger rows** in the section's `## Improvement decisions` table: each note, what was done, and
  the author's choice.
- **For a template adaptation:** one draft per section of the new client document, with an
  internal note naming the template it came from.

## The failure this procedure exists to prevent

**The silent rewrite.** Asked to fix one sentence, a model rewrites the paragraph, and the
author's earlier approval of the other sentences is quietly lost, along with any wording a client
has already seen. Adapting changes only what the notes reach, so the author can trust that
everything they did not mention is exactly as they left it.

## Cross-references

- `library/docs/reference/drafting-with-ai.md` — the loop and who decides.
- `library/docs/reference/versioning-and-the-register.md` — when an adaptation is a new version.
- `library/src/contracts/templates/` — the instrument templates most often adapted.
