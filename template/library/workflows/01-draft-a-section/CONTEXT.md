# CONTEXT.md — library/workflows/01-draft-a-section/

The procedure for having the AI draft **one section** of a document from its unit brief: settle
the five questions, gather every fact first, then write 300–500 words into the document's drafts
folder as an `ai-draft`, with a ledger entry holding the AI original word for word. It is the
front door to writing a document; the author's revision (02 or 03) and promotion (04) follow it.

## Directory Tree

```text
library/workflows/01-draft-a-section/
├── CHECKLIST.md            ← verification checklist before marking complete
├── CLAUDE.md               ← operating rules for this workflow
├── CONTEXT.md              ← this file (when to use, what it produces, the failure it prevents)
└── STEPS.md                ← ordered steps to execute
```

## When to use this

- The author asks for the next section of a document, or a named one ('draft the scope of the
  proposal', 'write the termination clauses'), and the document has a unit brief.
- A one-section document (an email, a short letter, a post) needs its body written.

Reach for a **different** procedure when: no unit brief exists yet
(`planning/workflows/01-plan-a-unit/`); the author has written the section and wants it improved
(`library/workflows/03-improve-your-draft/`); an AI draft exists and the author has notes on it
(`library/workflows/02-adapt-a-draft/`); the starting point is a document the business already
has (`library/workflows/08-ingest-an-existing-document/`); or the document is a form, such as an
invoice, which is filled from its template, not drafted.

## What it produces, and where

- **A section draft** at `library/src/<family>/drafts/<unit-slug>/<NN>-<section-slug>.md`, at
  `status: ai-draft`, `origin: ai`.
- **A ledger entry** at `standards/style/ledger/<unit-slug>--<section-slug>.md`, its
  `## AI original` holding the drafted text exactly as handed to the author.
- **Evidence entries** in `research/src/evidence/` for every figure checked before drafting.
- **The five answers** in the unit brief, the first time any section of the document is drafted.
- **A hand-back note:** the draft's path, every flag raised, the questions for the author, and the
  suggested next procedure.

## The failure this procedure exists to prevent

**A commitment nobody decided.** An AI asked for a fluent scope or a payment clause will supply
the missing number, date or boundary, and the sentence will read as if someone chose it. Once it
reaches a client it binds the business. Every step before drafting exists to find those gaps
first, and the drafting step flags them instead of filling them.

## Cross-references

- `library/docs/reference/section-anatomy.md` — what one section is and how it is shaped.
- `library/docs/reference/drafting-with-ai.md` — the loop, the five questions, the record.
- `library/workflows/02-adapt-a-draft/`, `library/workflows/03-improve-your-draft/` — what follows.
