# CONTEXT.md — world/workflows/

The world layer's ordered procedures: one per kind of world-building job, each a folder of four
files (`CONTEXT.md`, `CLAUDE.md`, `STEPS.md`, `CHECKLIST.md`). Numbers are frozen and never
reused, so gaps are normal; which procedures ship depends on the kits chosen when the project
was generated. The author's own procedures live in `world/workflows/local/`.

## Directory Tree

```text
world/workflows/
├── CONTEXT.md                      ← this file
├── CLAUDE.md                       ← operating rules and the 'You want to…' index
├── 01-create-a-character/          ← a character file, a registered name, an arc file
├── 02-create-a-place/              ← a place file with distances, and a registered name
├── 03-name-something/              ← one name, chosen, clash-checked and registered
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── 04-create-a-creature/           ← a bestiary entry with rules, limits and weaknesses
├── 05-create-a-culture/            ← a culture file with its naming customs
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── 06-build-a-language/            ← a language folder: world first, cited models, one subsystem at a time
├── 07-add-a-word/                  ← one lexicon entry, built from roots and placed in history
├── 08-design-a-script/             ← the writing system: inspiration, filled glyphs, a font
├── 09-record-a-pronunciation/      ← audio from surface IPA, on the author's request only
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── 10-create-a-people/             ← a people file: body and speech first, depiction checked
├── 11-chart-the-world-history/     ← the eras and one file per major event, with its marks on language
<: endif :>└── local/                          ← your own procedures; a same-slug folder here wins
```

Each procedure folder holds:

```text
NN-verb-first-name/
├── CHECKLIST.md        ← model-tagged checklist: Pre-Conditions, Execution Checklist, Done When
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← when to use it, what it produces, the one thing that matters most
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## What's here

- `world/workflows/01-create-a-character/`, `world/workflows/02-create-a-place/`,
  `world/workflows/03-name-something/` — for every novel.
<: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `world/workflows/04-create-a-creature/`, `world/workflows/05-create-a-culture/`,
  `world/workflows/10-create-a-people/`, `world/workflows/11-chart-the-world-history/` — the
  worldbuilding kit.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>- `world/workflows/06-build-a-language/`, `world/workflows/07-add-a-word/`,
  `world/workflows/08-design-a-script/`, `world/workflows/09-record-a-pronunciation/` — the
  constructed-language kit.
<: endif :>- `world/workflows/local/` — **author-owned**; the template ships only its pair.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — routing frontmatter, frozen numbering
  and the local override rule.
- `world/docs/reference/` — the guides each step cites.
- `standards/verification/verification.md` — the gates a checklist cites by number.
