# CONTEXT.md — world/src/characters/

One file per character who needs more than a name: who they are, what they want and need, the
wound and the lie that drive them, how they sound, and whom they are bound to. A character's
change across the book is charted in `planning/src/arcs/`, and the character file links to it;
a minor character who needs only a name has a row in `world/src/names-register.md` and no file.

## Directory Tree

```text
world/src/characters/
├── CONTEXT.md          ← this file
├── CLAUDE.md           ← operating rules and the file skeleton
└── <slug>.md           ← one character, named for the registered name in kebab-case
```

## What's here

Each `<slug>.md` carries frontmatter `name`, `ipa`, `role`, `first_appears` and `arc` (the path
of the character's arc file), then six sections in this order:

- `## Want` — what the character consciously pursues, stated so a scene can test it.
- `## Need` — what they actually lack, which the want hides from them.
- `## Wound and the lie` — the past event, and the false belief it taught them.
- `## Voice markers` — three to six markers (diction, rhythm, habits, what they never say),
  each with a short invented example line. **`character-voice` checks dialogue against these.**
- `## Relationships` — the people they are bound to, each linked to that person's file.
- `## Continuity facts` — fixed details the prose relies on (age, scars, home, family), each
  with the section that established it once promoted prose has used it.

## Cross-references

- `world/workflows/01-create-a-character/` — the procedure that writes these files.
- `planning/docs/reference/character-arcs.md` — want, need, the lie and the arc types.
- `planning/src/continuity.md` — the ledger that the continuity facts point to.
- `world/docs/reference/naming.md` — how the character's name is chosen and registered.
