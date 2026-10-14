@./CONTEXT.md

# CLAUDE.md — .gemini/

Read order: `.claude/syntek-author-agents.md` → `.claude/CLAUDE.md` → `.claude/MEMORY.md` →
this folder's `CONTEXT.md` (imported above) → this file, before changing `settings.json`.

## Purpose (one line)

Keep Gemini CLI's project settings working, without overriding the author's choices.

## How to work here

- **Routing:** the shared read order and client setup → `.claude/syntek-author-agents.md`; the
  model tiers → `.claude/rules/syntek-author/05-model-allocation.md`; Gemini CLI's settings →
  `settings.json`.
- **Model:** the mechanical tier for an agreed setting; the substantive tier for a permission or
  a decision about what Gemini CLI may do.
- **Concrete steps:** read `settings.json` → agree the change with the author → edit only the
  agreed keys → check the file still parses as JSON → restart Gemini CLI and confirm it still
  reads `GEMINI.md`, the rules and the skills.
- **Definition of done:** the file parses, existing server entries are kept, and the change is
  recorded in `.claude/MEMORY.md` when it is a decision.

## Guardrails

- **Never add a key, a token or a permission bypass.** Credentials stay in Gemini CLI's own store
  or the environment.
- **Never copy skills into this folder.** A second copy drifts from `.claude/skills/`.
- **Client permission is not the author's approval**, and a configured server is not approval
  to spend credits: the rules still decide.
- This pair and `settings.json` are the author's. `copier update` never touches them.

## Output & naming

- `settings.json` — Gemini CLI's workspace settings. Nothing here is generated after the first
  copy.
