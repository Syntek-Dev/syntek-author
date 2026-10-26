# CONTEXT.md — how-to/docs/syntek-author/

syntek-author's guides in the user guide. Each explains one practice of keeping this project in
step with the template: what it is, how this kind of project applies it, which procedure carries
it out and which rule governs it. The guides are template-owned and read-only: read them, and
never edit them, because every update of the template puts them back as it wrote them.

## Directory Tree

```text
how-to/docs/syntek-author/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← how to use these guides
├── updating-the-template.md       ← taking the template's improvements, and an update that stopped
├── enabling-an-agent-client.md    ← adding a coding agent's files after the project was made
└── setting-up-the-data-root.md    ← preparing a machine, and moving binary files out of Git
```

## What's here

- `updating-the-template.md`: what an update changes, the user guide put back included, and
  what to do when an update stops part way. Procedures 01 and 02 carry it out.
- `enabling-an-agent-client.md`: why an update never adds a client's files, and the
  fresh-render route that adds them by hand. Procedure 03 carries it out.
- `setting-up-the-data-root.md`: one data root on each machine, and moving the binary files Git
  holds out to it as checked copies. Procedure 04 carries it out.

**Ownership.** Every file here is syntek-author's: template-owned, written by Copier, and put
back by every update where it differs, your edits and deletions included; what you had stays in
Git. There is no `docs/project/` beside these guides. Where this project works differently from
a guide, the difference is an override in `.claude/rules/syntek-author/00-project.md`
`## Overrides`, never an edit here.

## Cross-references

- `how-to/workflows/syntek-author/`: the procedures these guides name, with every command.
- `how-to/src/TEMPLATE-GUIDE/syntek-author/`: this template's chapters, which explain the same
  ground for a first read, and the glossary.
- `how-to/src/TEMPLATE-GUIDE/updating-and-recovery.md`,
  `how-to/src/TEMPLATE-GUIDE/agent-clients-and-mcp.md` and
  `how-to/src/TEMPLATE-GUIDE/the-data-root.md`: the shared chapters, which explain the
  machinery every template of the family has in common.
- `.claude/rules/syntek-author/`: the rules each guide cites, which win wherever a guide only
  explains.
