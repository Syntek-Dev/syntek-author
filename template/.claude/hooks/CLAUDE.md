@./CONTEXT.md

# CLAUDE.md — .claude/hooks/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `.claude/CONTEXT.md` →
this folder's `CONTEXT.md` (the hook registry and exit codes, imported above) → this file.

## Purpose (one line)

Keep the session hooks small, fast and honest, so the guard against silent compaction keeps
working.

## How to work here

- **Routing:** a hook change is a shell edit plus its registration in `.claude/settings.json`; the
  rule a hook enforces lives in `.claude/rules/syntek-author/`, and the work it steers to lives
  in a skill.
- **Model:** **Opus**: a hook runs unattended in every session, so a mistake here repeats silently.
- **Concrete steps:** confirm the change with the author → edit the script → run `bash -n` on it
  → run it by hand with each argument and check the exit code → keep its header, its
  `settings.json` entry and the table in `CONTEXT.md` in step.
- **Definition of done:** the script is executable and parses; `pre-compact-handoff.sh auto`
  exits 2 and `pre-compact-handoff.sh manual` exits 0, both printing the reminder; the header,
  the settings entry and the `CONTEXT.md` table agree.

## Guardrails

- **Never weaken `pre-compact-handoff.sh`.** It blocks auto-compaction (exit 2) and only warns on
  a manual `/compact`. Silent compaction is the failure it exists to prevent.
- **A hook cannot do the model's job.** It cannot invoke a skill, write a handoff or end a turn.
  Anything that needs judgement belongs in a skill.
- **Never make a hook slow.** It runs inside the session; a hook that hangs stalls the author.
- **Never let a hook write to `src/`**, or to any file the author owns.
- **Fail open on absence, never on error.** A missing script is a no-op; a script that runs must
  report what it found, never a pass it did not check.
- **The template's script is template-owned.** `copier update` replaces
  `pre-compact-handoff.sh`; a project-specific change belongs in a new script of its own.
- Changing a hook requires the author's explicit instruction.

## Output & naming

- **Hand-written:** each `kebab-case.sh` script, executable, with its header. Nothing here is
  generated.
- One script per job, named for the event and its purpose (`pre-compact-handoff.sh`).
