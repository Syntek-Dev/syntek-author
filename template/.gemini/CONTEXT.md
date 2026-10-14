# CONTEXT.md — .gemini/

Gemini CLI's project settings for <%PROJECT_NAME%>. Written once when the project was
generated and the author's from then on: `copier update` never changes, adds or recreates
anything here. The rules, skills and memory Gemini CLI follows live in `.claude/`, which every
client shares; it finds the skills through `.agents/skills`.

## Directory Tree

```text
.gemini/
├── CONTEXT.md       ← this file (yours)
├── CLAUDE.md        ← how to change these settings (yours)
└── settings.json    ← the model if one was chosen, and MCP servers (yours)
```

## What's here

- `settings.json` — Gemini CLI's workspace settings: `model.name` when a model was chosen at
  generation, and an empty `mcpServers` object for the servers you add. It holds no key or
  credential. Workspace settings override your user settings for this project only.
- Skills are not copied here: `.agents/skills` is the one skill tree every client reads.

## Cross-references

- `.claude/syntek-author-agents.md` — the read order and setup every client shares.
- `.claude/rules/syntek-author/05-model-allocation.md` — the tiers, and the model each client uses.
- `GEMINI.md` — Gemini CLI's entrypoint at the project root.
