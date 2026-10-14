# AGENTS.md — syntek-author template development

Read `.claude/CLAUDE.md` (the development manual), root `CONTEXT.md` and `.claude/CONTEXT.md`,
then the sections of `DESIGN.md` your change touches, then the `CONTEXT.md` and `CLAUDE.md` of
the folder you are about to change, in that order, before editing. OpenCode reads no
`CLAUDE.md`, and Codex reads none here: open each of these files yourself.

This repository develops a Copier template. Everything under `template/` is product text for
future writing projects: its manuals, rules, bridge and skills never govern this work. Never
invoke a product skill, never draft or review a book here, and never call a paid service.

`DESIGN.md` wins. Change it only with the maintainer's explicit approval; ask about anything it
does not settle. The source repositories it names are read-only, and their names and paths never
enter `template/`. Follow the development manual for tokens, formats, audits and releases, and
commit only when the maintainer asks. `opus` and `sonnet` in the manual are work tiers; use the
models the maintainer configured in this client.

Start every session at the repository root, never inside `template/`. Clients find project
skills, and Codex its project config, only between the root and the folder a session starts
in; the root has no `.agents`, so no product skill is found here, while a session started under
`template/` loads every product skill through `template/.agents`. Codex ignores
`[[skills.config]]` in a project file: the development `.codex/config.toml` is a snippet to
copy into your user config, not a guard, and sets no instruction fallback into `template/`
(DESIGN.md D47). A product `AGENTS.md` or `GEMINI.md` you meet under `template/` is source text
that sends you back here.
