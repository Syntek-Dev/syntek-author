@./CONTEXT.md

# CLAUDE.md — library/workflows/local/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Hold the author's own library procedures, which run before any template procedure of the same
name.

## How to work here

- **Routing:** write a procedure here when the author asks for one, or propose one when the same
  job has been done the same way twice. To change a template procedure, copy its folder here under
  exactly the same name, number included, and edit the copy.
- **Model:** **Opus** for writing a procedure; its checklist tags then govern each run.
- **Concrete steps:**
  1. Settle the procedure with the author first (the `grill-with-docs` skill).
  2. Write all four files in the house format: routing frontmatter (`workflow`, `phase`, `skills`,
     `model`), the metadata header, numbered steps each opening with a `**Skill:** … · **Guide:** …`
     line and ending `_Substantive._` or `_Mechanical._`, and checklist items ending
     ` · _opus_` or ` · _sonnet_`.
  3. Add a tree line and a table row to this folder's `CONTEXT.md`.
- **Definition of done:** the four files exist and agree with each other, the procedure names only
  skills that exist, and the index lists it.

## Guardrails

- **Write only what the author has confirmed.** A procedure is a standing instruction; a guess
  written as one gets followed.
- **One job per procedure.** A one-off task does not get a folder.
- **Never weaken a gate by override.** A local procedure may add steps or change their order; it
  may not drop a verification gate or the author's word before promotion, `final` or issue.
- **Never overwrite** an existing local procedure without the author's confirmation.

## Output & naming

- **Hand-written:** `<NN>-<verb-first-name>/` folders, each with `CONTEXT.md`, `CLAUDE.md`,
  `STEPS.md` and `CHECKLIST.md`.
