@./CONTEXT.md

# CLAUDE.md — library/workflows/10-create-a-business-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Start a new business-family document, plan it from its required parts, and drive it through the
loop and the review to an issued `final`.

## How to work here

- **Routing:** the `business-documents` skill, loaded first, holds the family's types and checks;
  `library/docs/reference/business-standards.md` is its standard. `grill-with-docs` settles the
  brief; each loop procedure brings its own skills. Guides: `business-standards.md`,
  `document-anatomy.md` and `drafting-with-ai.md` in `library/docs/reference/`.
- **Model:** follow the checklist tags: **Opus** for the type, the facts, the plan and every word;
  the mechanical tier for folders, names and ticks.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go; each loop
  procedure it names is run with its own `CHECKLIST.md` open.
- **Definition of done:** the document sits at its named path in the business family with every
  part its type requires, every section promoted through the loop, the review passed, `final` set
  on the author's word, the register row written and the issue PDF beside it.

## Guardrails

- **Plan before prose.** No section is drafted until the brief is agreed (V1, idea → outlined).
- **One section at a time,** through the loop; never the whole document in one pass.
- **Prices, dates, scope boundaries and service levels come from the author.** Never supply one;
  flag it.
- **A circulated document is never edited.** A change to one is a new version.
- **Client facts are read from the facts home and cited,** never copied into the document's folder
  or taken from the client's website.
- **Sending, signing and publishing are the author's acts.** This procedure ends at `final` and
  the hand-back.

## Output & naming

- **Produces:** the brief; the document `.tex`, named to `business-standards.md`; its issue PDF.
- **Also writes:** a client folder and its `## Facts` when the client is new; the client folder's
  `CONTEXT.md` list; the register row (through the review).
- **Does not touch:** any standard, template-owned file or other client's folder.
