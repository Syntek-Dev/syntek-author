@./CONTEXT.md

# CLAUDE.md — .codex/ (development)

Read order: root `AGENTS.md` → `.claude/CLAUDE.md` → `DESIGN.md` D47 and Section 7 → this
folder's `CONTEXT.md` (imported above) → this file, before changing `config.toml`.

## Purpose (one line)

Keep the product's skills and manuals out of Codex sessions that develop the template.

## How to work here

- **Routing:** a new product skill → its `Skill(<name>)` deny in `.claude/settings.json` and its
  entry in `config.toml`, both the maintainer's to approve (`.claude/CLAUDE.md` Section 3).
- **Model:** the mechanical tier for adding an agreed entry; the substantive tier for anything
  that changes what Codex may load.
- **Concrete steps:** add `[[skills.config]]` with `path = '../template/.claude/skills/<name>/SKILL.md'`
  and `enabled = false`, keeping the entries sorted → run
  `bash .github/scripts/dev-isolation.sh`.
- **Definition of done:** `dev-isolation.sh` passes, and the file parses as TOML.

## Guardrails

- Never add `project_doc_fallback_filenames`: it would load the product's manuals as
  development instructions.
- No model, trust level, permission bypass or credential belongs in this shared file.
- Files under `template/` stay source text in every client.

## Output & naming

- `config.toml` holds the development skill exclusions; nothing here ships.
