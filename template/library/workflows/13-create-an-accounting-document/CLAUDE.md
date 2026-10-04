@./CONTEXT.md

# CLAUDE.md — library/workflows/13-create-an-accounting-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Make a new accounting document, a form filled from its template or a report driven through the
loop, with every figure traced to its source and every total recalculated.

## How to work here

- **Routing:** the `accounting-documents` skill, loaded first, holds the family's types, fields
  and checks; `library/docs/reference/accounting-standards.md` is its standard. `fact-check`
  traces every figure; `build` renders and reads the proof; a report's sections run through the
  loop procedures with their own skills.
- **Model:** **Opus** for every figure and every sentence about one; the mechanical tier for
  copying a template, numbering checks and rendering.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go. Steps 5 and 6
  are the form route; steps 7 and 8 the report route.
- **Definition of done:** every field or part the type requires is present; every figure traces to
  the author, an agreed document or the books; every total recalculates; the tax line is stated;
  the author has confirmed the document; its issue PDF sits beside the `.tex`.

## Guardrails

- **Never invent, round or estimate a figure silently.** An estimate is labelled with its basis; a
  figure the author has not given is `\dnote{AUTHOR TO CONFIRM: …}` or `\fillme`.
- **Invoice numbers are proposed, never assumed:** the next in the year's sequence across the whole
  family, confirmed by the author before it is written.
- **An issued invoice is never edited.** A mistake is corrected by a credit note.
- **Bank details live only in the invoice template's fields,** entered by the author.
- **A price that differs from the agreement** is raised with the author before anything is rendered.
- **Records holding bank or personal details are never read into a draft,** and stay out of the
  repository or in a folder git ignores.

## Output & naming

- **Produces:** the form or report `.tex` (a pricing model may be `.md`), named to
  `accounting-standards.md`; its issue PDF.
- **Also writes:** for a report, its brief, drafts, ledger entries and register row.
- **Does not touch:** an issued invoice, the invoice template's business details, or any standard.
