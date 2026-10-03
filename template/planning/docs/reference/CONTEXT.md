# CONTEXT.md — planning/docs/reference/

The template's planning guides, one per question. Each explains how one kind of plan is made in
this project, names the skill and workflow that carry it out, and points at the standard that
owns the rule. These files are template-owned: `copier update` keeps them current, and a
same-named guide in `planning/docs/project/` overrides any of them.

## Directory Tree

```text
planning/docs/reference/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules
├── unit-briefs.md            ← the plan a unit is drafted from
├── reviews-are-advice.md     ← how a review becomes a decision, or does not
<: if DOC_TYPE == 'theology' :>├── argument-maps.md          ← the structure behind a chapter's claims
<: endif :><: if DOC_TYPE == 'fiction' :>├── causality-chains.md       ← because and therefore, never 'and then'
├── character-arcs.md         ← how a character changes, beat by beat
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── quest-design.md           ← a quest that cannot be left dangling
<: endif :><: if DOC_TYPE == 'business' :>├── the-document-register.md  ← registers, versions, reviews and approvals
<: endif :>└── decision-maps.md          ← charting work too big for one sitting
```

## What's here

- `unit-briefs.md` — **read before planning any unit.** The brief's frontmatter and body, how
  sections are cut, and how the brief moves through the status ladder.
- `reviews-are-advice.md` — where a review lives, its shape, and the line between advice and a
  dated decision.
- `decision-maps.md` — when a map earns its place, its sections and node types, and where a
  settled decision graduates to.
<: if DOC_TYPE == 'theology' :>- `argument-maps.md` — the six claim categories, the shape of an argument map, and why support
  runs downwards while concession runs ahead.
<: endif :><: if DOC_TYPE == 'fiction' :>- `causality-chains.md` — a beat and its cause, coincidence, and setup and payoff.
- `character-arcs.md` — arc types, the lie and the truth, and mapping beats to sections.
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>- `quest-design.md` — goal, stakes, obstacles, cost and reward, tied to arcs and causality.
<: endif :><: if DOC_TYPE == 'business' :>- `the-document-register.md` — the two lifecycles, `DOC-NNN` IDs, versions, review cycles,
  approval records and stated precedence.
<: endif :>
## Cross-references

- `planning/docs/project/` — your overrides and additions; checked before this folder.
- `planning/workflows/CLAUDE.md` — the procedures these guides are applied in.
- `standards/verification/verification.md` — the gates every guide here defers to.
