@./CONTEXT.md

# CLAUDE.md — how-to/workflows/syntek-author/02-recover-a-failed-update/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/CLAUDE.md` → `how-to/workflows/CONTEXT.md` → `how-to/workflows/CLAUDE.md` →
`how-to/workflows/syntek-author/CONTEXT.md` → `how-to/workflows/syntek-author/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Undo an update that stopped part way, losing nothing of the author's, and run it again so it
delivers what an update that never stopped delivers.

## How to work here

- **Routing:** no skill; this is a recovery procedure. Guide
  `how-to/docs/syntek-author/updating-the-template.md`; the `.agents` cases are explained in
  `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md`.
- **Model:** **Opus** for recognising the stop, reading the dry run with the author and
  deciding about `how-to`; the mechanical tier only for running a command the author has agreed
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go; once the
  update has run again, continue at step 5 of `01-update-the-template/`.
- **Definition of done:** the update has run again and ended with its report, read from the
  version the project had, and nothing of the author's was lost on the way.

## Guardrails

- **Commit nothing the stopped update left**, not even to save it.
- **The held link comes first.** `git clean -fd` deletes an `.agents.syntek-held` that Git does
  not track; put it back before any discard.
- **Read the dry run with the author.** `git reset --hard && git clean -fd` discards every
  uncommitted change in the repository and deletes every untracked file the dry run lists; it
  runs only with the author's agreement, and only in a project that is its own repository.
- **Never `rm -r` an `.agents` link, never with a trailing slash**, and never run
  `mv .agents.syntek-held .agents` while `.agents` stands.
- **Renaming `how-to` is the author's call**, and never touches anything inside it.
- **A session reruns the update only in the `--defaults` form** step 6 gives, on the author's
  word: the other form needs a terminal, and without one it can leave an `.agents` link held.
- **Never edit under `how-to/`**: the update run again puts the guide back
  (`.claude/rules/syntek-author/06-global-rules.md` Section 3).

## Output & naming

- **Writes:** nothing but what the commands in `STEPS.md` do: the discard, the link put back,
  the rename of `how-to` and its commit, and the update run again.
- **Sets aside:** `.agents.from-update`, where `.agents` had to be moved; the author checks it at
  step 3, anything in it they want is moved out of the project, and the discard removes the rest.
