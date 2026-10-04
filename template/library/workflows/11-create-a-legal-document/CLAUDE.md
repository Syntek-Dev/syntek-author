@./CONTEXT.md

# CLAUDE.md — library/workflows/11-create-a-legal-document/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Start a new instrument, plan its clause groups from its required parts, and drive it through the
loop and the review to `final` and, on the author's word, execution.

## How to work here

- **Routing:** the `legal-documents` skill, loaded first, holds the family's types and checks;
  `library/docs/reference/legal-standards.md` is its standard. `fact-check` verifies the
  counterparty; `grill-with-docs` settles the brief; `clause-consistency` and `obligation-check`
  run at the review's fact check. Each loop procedure brings its own skills.
- **Model:** **Opus** throughout; nothing in an instrument is mechanical except copying files and
  ticking boxes.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go; each loop
  procedure it names is run with its own `CHECKLIST.md` open.
- **Definition of done:** the instrument is `final` on the author's word with every part its type
  requires, its disclaimer at the top, every defined term defined once, every obligation intended,
  every cross-reference resolved, governing law stated, its register row written and its issue PDF
  beside it; once signed by every party, its signed copy filed and its approval recorded.

## Guardrails

- **The counterparty is verified on the public register,** never its website, before its name is
  written into a clause.
- **Never invent a statute, a section number or a regulator's requirement.** Each carries `VERIFY`
  until `fact-check` has confirmed it against the source.
- **Every negotiable value comes from the author:** fees, caps, notice periods, durations, service
  levels. Never supply one; flag it.
- **The formal register stays.** Plain-English tone work never touches a clause's meaning.
- **Executed means signed by every party, with the signed copy filed.** Never set it on less.
- **A sent instrument is never edited.** A counterparty's changes come back as a negotiation copy
  and a new version.

## Output & naming

- **Produces:** the brief; the instrument `.tex`, named to `legal-standards.md`; its issue PDF.
- **Also writes:** the counterparty's `## Facts`; the precedence row; the register row and, on
  execution, the approval record (through the planning procedures).
- **Does not touch:** any standard, template-owned file or other client's folder.
