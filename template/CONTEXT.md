# CONTEXT.md — <%PROJECT_SLUG%>/

<: if DOC_TYPE == 'theology' :>The working repository for a Christian non-fiction book by <%AUTHOR_NAME%>.
<: elif DOC_TYPE == 'fiction' :>The working repository for a novel by <%AUTHOR_NAME%>.
<: else :>The working repository for the business, legal and client documents of <%TRADING_NAME%>.
<: endif :>The deliverable is finished prose, not code: every file in a `src/` folder is part of the work or
the evidence and planning behind it. The brief, the audience and the reader test live in
`.claude/CLAUDE.md` Section 1, not here; the rules live in `.claude/rules/syntek-author/`. This
file is orientation only.

## Directory Tree

```text
<%PROJECT_SLUG%>/
├── .claude/                ← Claude Code: the manual, the template's rules, memory, settings, hooks, skills
│   ├── CLAUDE.md           ← the project brief and where the rules live (read first)
│   ├── MEMORY.md           ← project memory (read second)
│   ├── rules/syntek-author/ ← the template's rules, loaded at launch; never edit
│   └── skills/             ← one folder per skill
<: if DOC_TYPE == 'business' and INCLUDE_DRIVE_SYNC :>├── .github/workflows/      ← Google Drive push and pull
<: endif :>├── planning/               ← LAYER (production): outline, <%UNIT_NOUN%> briefs, decision maps, reviews
├── research/               ← LAYER (production): sources, evidence entries, research notes
<: if DOC_TYPE != 'business' :>├── manuscript/             ← LAYER (production): the book, one folder per chapter
<: endif :><: if DOC_TYPE == 'business' :>├── library/                ← LAYER (production): the documents, by family
<: endif :><: if DOC_TYPE != 'business' :>├── typeset/                ← LAYER (production): the printed book, set in LaTeX from the promoted chapters
<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>├── proposal/               ← LAYER (production): <: if DOC_TYPE == 'theology' :>book proposal, endorsements, sample<: else :>query package, submissions, sample<: endif :>
<: endif :><: if DOC_TYPE == 'fiction' :>├── world/                  ← LAYER (production): the story bible<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>: peoples, cultures, history<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>, constructed languages<: endif :>
<: endif :>├── standards/              ← SUPPORTING: style, method, risk, verification<: if INCLUDE_REFERENCES :>, referencing<: endif :><: if DOC_TYPE == 'business' :>, brand<: endif :>
├── tooling/                ← SUPPORTING: the build and its scripts
├── handoffs/               ← session bridges from the handoff skill; pruned once resumed
├── learning/               ← the teach workspace; nothing here is the work
├── assets/                 ← images and other binaries the work uses
├── CONTEXT.md              ← this file
├── Makefile                ← the build entry point (make help)
├── README.md               ← the human-facing overview
├── .gitignore              ← what Git never tracks
├── .mcp.json               ← project MCP servers (none by default)
└── .copier-answers.syntek-author.yml ← Copier's record of the answers; never edit by hand
```

## What's here

- **Production layers** — `planning/`, `research/`, <: if DOC_TYPE != 'business' :>`manuscript/`, `typeset/`<: else :>`library/`<: endif :><: if DOC_TYPE != 'business' and INCLUDE_PROPOSAL :>, `proposal/`<: endif :><: if DOC_TYPE == 'fiction' :>, `world/`<: endif :>. Each splits into
  `docs/` (guides: `reference/` from the template, `project/` your own), `src/` (the artefact)
  and `workflows/` (numbered procedures, with `local/` for your own). **The content layer is
  `<%CONTENT_LAYER%>/`; the unit is a <%UNIT_NOUN%>.**
- **Supporting layers** — `standards/` (the rules the prose answers to) and `tooling/` (the
  build). Flat, consulted rather than produced inside.
- **Working folders** — `handoffs/`, `learning/` and `assets/`, outside every build.
- **Generated output** — `build/` appears the first time `make` builds anything. It is git-ignored
  and never edited by hand.
- **Every folder carries a `CONTEXT.md` and a `CLAUDE.md`.** Read both before working inside a
  folder.

## Cross-references

- `.claude/CLAUDE.md` — the project brief and the project's own rules; read it first.
- `.claude/rules/syntek-author/01-layout-and-routing.md` — the layers, the folder pair, who owns
  which files, and the read order.
- `.claude/rules/syntek-author/03-authorship.md` — how drafting, revision and promotion work.
- `README.md` — the overview for people, including how to build and how to update from the
  template.
