@./CONTEXT.md

# CLAUDE.md — how-to/docs/syntek-author/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/CLAUDE.md` → `how-to/docs/CONTEXT.md` → `how-to/docs/CLAUDE.md` → this folder's
`CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Explain why each practice of keeping the project in step with syntek-author works as it does,
and send the work to the procedure that carries it out.

## How to work here

- **Routing:** each guide names its procedure, in `how-to/workflows/syntek-author/`:
  - `updating-the-template.md` → `how-to/workflows/syntek-author/01-update-the-template/`, and
    `how-to/workflows/syntek-author/02-recover-a-failed-update/` when an update stopped;
  - `enabling-an-agent-client.md` → `how-to/workflows/syntek-author/03-enable-an-agent-client/`;
  - `setting-up-the-data-root.md` → `how-to/workflows/syntek-author/04-set-up-the-data-root/`.

  Check `.claude/rules/syntek-author/00-project.md` `## Overrides` and `## Workflow aliases`
  first: a departure recorded there wins.
- **Model:** **Opus**: reading a guide into a decision about this project is judgement, and
  the procedures it leads to change the template's files
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:** find the guide in `CONTEXT.md` → read it → check `00-project.md` for an
  override or alias → run the procedure the guide names, through `run-workflow` or by hand.
- **Definition of done:** the practice is understood, the procedure is chosen, and nothing
  under `how-to/` changed except through the template's update, its recovery and the commands
  its report prints.

## Guardrails

- **Read-only.** Never edit, write, move or delete a guide here, even when asked, except
  through the template's update, its recovery and the commands its update report prints for a
  file here. `.claude/settings.json` denies it, the guide guard
  (`.claude/hooks/how-to-read-only.sh`) refuses it, and the next update puts the file back
  (`.claude/rules/syntek-author/06-global-rules.md` Section 3).
- **No `docs/project/` here.** This project's own way of doing one of these practices is an
  override in `00-project.md` `## Overrides` (a redirect included), never a copy of the guide.
- **A guide explains; the rules decide.** Where a guide and its governing standard differ,
  follow the standard and tell the author.
- **Commands come from the procedure.** A guide names commands to explain them; run each one
  from the procedure's `STEPS.md`, in its order, and never from memory.

## Output & naming

- **Writes nothing.** Every file here is template-owned.
- **Names:** `kebab-title.md`; each guide opens with its title and a gloss as one H1, then the
  metadata header and `**What it is.**`, and ends with `## Governing standard`.
