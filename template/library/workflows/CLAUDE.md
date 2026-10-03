@./CONTEXT.md

# CLAUDE.md — library/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the chosen
procedure's `STEPS.md` (with its `CHECKLIST.md` open).

## Purpose (one line)

Route a request about a library document to the one procedure that does it, and run that
procedure in order.

## How to work here

- **Routing:** the `run-workflow` skill matches the author's request to a procedure using the
  table in this folder's `CONTEXT.md`. It looks in `local/<slug>/` first: a local procedure with
  the same slug as a template one replaces it. Each `STEPS.md` names its skills in its routing
  frontmatter; load them before step 1.
- **Model:** the checklist tags are authoritative. `_opus_` marks substantive work; `_sonnet_`
  names the mechanical tier, which runs on the model set in
  `.claude/rules/syntek-author/05-model-allocation.md` and never lower.
- **Concrete steps:**
  1. Resolve the procedure (local first) and read its `CONTEXT.md` and `CLAUDE.md`.
  2. Follow `STEPS.md` in order, ticking `CHECKLIST.md` as each item is done.
  3. Hand back as the last step says; never skip the hand-back.
- **Definition of done:** the procedure's `## Done When` items are all ticked, or each one left
  unticked is named in the hand-back with its reason.

## Guardrails

- **The order is load-bearing.** Steps that gather facts come before steps that write; reversing
  them is how an unverified figure ends up in a client's document.
- **A waived step is recorded, not silent.** Name it in the hand-back with the author's reason;
  silent skipping reads as completion.
- **Bias towards producing the document.** A procedure that ends in more planning and no prose has
  not been run; scaffolding is not progress.
- **Never edit a template procedure to suit this project.** These folders are template-owned and
  updated by `copier update`. Copy the folder to `local/` under exactly the same name and change
  the copy.
- **Change all four files together** when writing a local procedure; a step without its checklist
  item is a step nobody checks.
- **Numbering is frozen and append-only.** Template numbers never change; local procedures use
  their own numbering inside `local/`.

## Output & naming

- **Hand-written here:** nothing; these files arrive with the template.
- **Naming:** `<NN>-<verb-first-name>/`, two-digit, kebab-case, each with the same four files.
