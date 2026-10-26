@./CONTEXT.md

# CLAUDE.md — how-to/workflows/syntek-author/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `how-to/CONTEXT.md` →
`how-to/CLAUDE.md` → `how-to/workflows/CONTEXT.md` → `how-to/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → the chosen procedure's own files.

## Purpose (one line)

Hold syntek-author's procedures for keeping the project in step with the template, so each of
these jobs is done the same safe way every time, whoever runs it.

## How to work here

- **Routing:** pick by what you want; `run-workflow` checks
  `.claude/rules/syntek-author/00-project.md` `## Workflow aliases` before this folder.

| You want to… | Procedure |
|---|---|
| Take the template's latest changes | `01-update-the-template/` |
| Get back from an update that stopped | `02-recover-a-failed-update/` |
| Add Codex, Gemini CLI, Antigravity or OpenCode to this project | `03-enable-an-agent-client/` |
| Keep binary files outside the repository on this machine | `04-set-up-the-data-root/` |

- **Model:** the `_opus_` / `_sonnet_` tags in each `CHECKLIST.md` are authoritative: Opus for
  every judgement and every step that changes the template's files or the project's settings;
  the mechanical tier only for running a command the author has agreed and ticking items
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (running one):** read the procedure's `CONTEXT.md` → `CLAUDE.md` →
  `STEPS.md`, then work `STEPS.md` in order with `CHECKLIST.md` open.
- **Definition of done (running):** every checklist item ticked or waived with the author's
  reason; the project committed as the procedure's last step says; nothing under `how-to/`
  changed except through the template's update, its recovery and the commands its report
  prints.

## Guardrails

- **Never edit these folders**, even when asked: no session edits, writes, moves or deletes a
  file under `how-to/` (`.claude/rules/syntek-author/06-global-rules.md` Section 3), and every
  update puts the procedures back.
- **The project's own way is an alias.** A procedure this project runs differently is a row in
  `00-project.md` `## Workflow aliases`, naming the procedure by its full folder path, and the
  alias wins.
- **Never renumber or reuse a number.** Numbering is frozen and append-only.
- **The author decides.** A step that discards changes, changes an answer, copies files in or
  takes a file out of Git waits for the author's word; a session never runs it on its own
  judgement.
- **Commands run exactly as written**, from the project's top folder. A command that fails
  stops the procedure, and the author hears the command's own words.
- **Only this template's jobs.** A companion template's update, recovery or set-up follows its
  own procedure, in its own folder under `how-to/workflows/`, never one of these.

## Output & naming

- **Folders:** `NN-verb-first-name/`, numbered from 01 here, each holding `CONTEXT.md`,
  `CLAUDE.md`, `STEPS.md` and `CHECKLIST.md`.
- **Procedures produce nothing here.** They change the project as their steps say: the
  template's files, the answers file, the client files, the settings and the manifests.
