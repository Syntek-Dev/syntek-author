# CONTEXT.md — how-to/workflows/syntek-author/

syntek-author's procedures in the user guide: the steps, with every command, for keeping this
project in step with the template. Each takes one job from start to finish, for the author to
follow or for a session to run with the author, and carries its own commands, so it works even
where a shared chapter is missing. The procedures are template-owned and read-only: read them,
and never edit them, because every update of the template puts them back as it wrote them.

## Directory Tree

```text
how-to/workflows/syntek-author/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← how to run one, and the 'You want to…' table
├── 01-update-the-template/        ← CONTEXT · CLAUDE · STEPS · CHECKLIST: an update, to a commit
├── 02-recover-a-failed-update/    ← CONTEXT · CLAUDE · STEPS · CHECKLIST: undo a stopped update
├── 03-enable-an-agent-client/     ← CONTEXT · CLAUDE · STEPS · CHECKLIST: add a client's files
└── 04-set-up-the-data-root/       ← CONTEXT · CLAUDE · STEPS · CHECKLIST: a machine's data root
```

## What's here

- **Each procedure has the same files:** `CONTEXT.md` (when to reach for it), `CLAUDE.md` (how
  to run it), `STEPS.md` (the steps in order, each with its commands) and `CHECKLIST.md` (what
  to confirm before, during and after, each item tagged with its model tier).
- **Every command runs exactly as written**, from the project's top folder, in bash, zsh or
  another POSIX shell. A value the author chooses is named in the sentence before the command.
- **Numbers are frozen and append-only**, counted from 01 in this folder. There is no
  `workflows/local/` here.
- **`run-workflow` routes these** after the production layers' workflows, and never another
  template's folder under `how-to/workflows/`.

**Ownership.** Every file here is syntek-author's: template-owned, written by Copier, and put
back by every update where it differs, your edits and deletions included; what you had stays in
Git. This project's own way of doing one of these jobs is a row in
`.claude/rules/syntek-author/00-project.md` `## Workflow aliases`, never an edit here.

## Cross-references

- `how-to/docs/syntek-author/`: the guides these procedures carry out, and why each step is
  there.
- `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`,
  `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` and
  `how-to/src/TEMPLATE-GUIDE/the-data-root.md`: the shared chapters, which explain the
  machinery.
- `.claude/skills/run-workflow/SKILL.md`: the router, which checks `## Workflow aliases` first.
- `.claude/syntek-author-agents.md`: the same jobs, for a coding agent other than Claude Code.
