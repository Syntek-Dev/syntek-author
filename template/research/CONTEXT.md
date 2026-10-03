# CONTEXT.md — research/

The project's evidence base: everything the work stands on, gathered and checked before it is
written about. Sources are read here, claims are verified here and questions are answered here,
so that no unit is drafted around a fact nobody checked. Prose for the reader does not live here
(the content layer holds it; see `.claude/rules/syntek-author/01-layout-and-routing.md`), and
neither do plans, which live in `planning/`.

The governing discipline is simple and unpopular: **a unit cannot be drafted before its evidence
exists.** Prose written around an unverified claim tends to survive the discovery that the claim
was wrong, because by then the argument depends on it.

## Directory Tree

```text
research/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the layer
├── docs/                 ← guides: reference/ (template-owned) and project/ (yours)
├── src/                  ← the material: one file per source, claim or question
└── workflows/            ← ordered procedures: NN-name/ (template-owned) and local/ (yours)
```

## What's here

- `docs/` — the judgement calls that sit between the rules in `standards/` and the steps in
  `workflows/`: is this source usable, what does this study not show, may we publish this?
  **`docs/reference/` is template-owned**; a same-named guide in `docs/project/` overrides it.
- `src/` — sources, verified claims and question-led notes, plus any specialist folders this
  project has. **`src/CONTEXT.md` holds the routing table** that decides where a piece of material
  goes; read it before filing anything.
- `workflows/` — the procedures that fill `src/`, each with a model-tagged checklist.
  `workflows/CONTEXT.md` lists the ones this project has; an author procedure in
  `workflows/local/` with the same slug wins over the template's.

## Cross-references

- `research/src/CONTEXT.md` — the routing table: where a piece of material belongs.
- `research/workflows/CONTEXT.md` — the procedures, chosen by what you have in hand.
- `standards/verification/verification.md` — the gates a unit passes; the fact-check gate is fed
  from this layer.
- `standards/method/method.md` — how the work argues, which decides what counts as evidence.
- `.claude/rules/syntek-author/03-authorship.md` — never fabricate; the `VERIFY` flag.
