@./CONTEXT.md

# CLAUDE.md — world/workflows/03-name-something/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Give one thing a name that fits its world, stays distinct from every other name, can be said by
the reader, and is registered before the prose uses it.

## How to work here

- **Routing:** skill `create-name`; guide `world/docs/reference/naming.md`.
- **Model:** **Opus** for generating and checking options; the mechanical tier for adding the
  register row once the author has chosen (`.claude/rules/syntek-author/05-model-allocation.md`).
  The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: what is being
  named → read the register, naming customs and source language → options, said aloud → clash
  and false-friend checks → the author chooses → register → terminology, if needed → hand back.
- **Definition of done:** the author has chosen the name, it is registered with IPA and a
  respelling, and no look-alike, sound-alike or false-friend clash was left unreported.

## Guardrails

- **Three to five options, each with a reason.** One option is a decision taken on the author's
  behalf; ten is a list nobody reads.
- **Check every option, not just the favourite.** The author may choose any of them.
- **Never rename silently.** A renaming retires the old row and lists every section that used
  the old name; the prose changes only on the author's word.
- **Follow the naming customs already recorded.** If a culture's customs say names end in a
  vowel, an option that does not is flagged as breaking them, with the reason it might be worth
  it.
- **Never overwrite or delete a register row.** Retire it with the date.

## Output & naming

- **Produces:** one row in `world/src/names-register.md`, in alphabetical order.
- **Also writes:** an avoid entry in `standards/style/terminology.md`, only where a likely
  misspelling exists and the author agrees.
- **Generated:** nothing.
- **Does not touch:** promoted prose.
