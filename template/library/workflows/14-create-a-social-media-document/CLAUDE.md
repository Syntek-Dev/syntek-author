@./CONTEXT.md

# CLAUDE.md — library/workflows/14-create-a-social-media-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Start a new social media document, gather its evidence and permissions first, and drive it through
the loop and the review to `final`.

## How to work here

- **Routing:** the `social-media-documents` skill, loaded first, holds the family's types and
  checks; `library/docs/reference/social-media-standards.md` is its standard. `fact-check` gathers
  the evidence; `grill-with-docs` settles the brief; `tone` applies the brand voice at line edit.
  Each loop procedure brings its own skills.
- **Model:** **Opus** for strategy, claims and copy; the mechanical tier for calendar dates,
  layout and ticks.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go; each loop
  procedure it names is run with its own `CHECKLIST.md` open.
- **Definition of done:** the document is `final` on the author's word with every part its type
  requires, every claim backed or cut, every named client permitted, every platform named as it
  names itself, and emoji only in example copy.

## Guardrails

- **Evidence and permission before copy.** A claim without its evidence is cut; a client named
  without recorded permission is removed.
- **Specificity over superlatives.** No 'leading' or 'seamless' without the number that earns it.
- **Platforms are named as they name themselves,** in headings, tables and filenames.
- **Platform limits are checked, never remembered:** a character limit carries `VERIFY` until
  checked against the platform.
- **Never publish, schedule or post.** Publishing is the author's act.

## Output & naming

- **Produces:** the brief; the plan, calendar or guide `.tex`, or the profiles or campaign `.md`,
  named to `social-media-standards.md`; any issue PDF.
- **Also writes:** evidence entries; approval records through
  `planning/workflows/07-record-an-approval/`.
- **Does not touch:** the business's brand standards or any other client's folder.
