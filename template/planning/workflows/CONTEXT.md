# CONTEXT.md — planning/workflows/

The planning layer's ordered procedures: the recipes you start a planning task from. Where
`planning/docs/` explains how a plan is made and `planning/src/` holds the plans, this folder
holds the steps, in order, with the skill and guide named at each one and a model-tagged
checklist to tick as you go. **Never plan straight into `planning/src/` from memory.** Start here.

## Directory Tree

```text
planning/workflows/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules and the 'You want to…' table
├── 01-plan-a-unit/                ← one unit from idea to an agreed brief
<: if DOC_TYPE == 'theology' :>├── 02-map-the-argument/           ← a chapter's thesis, claims, support, objections, concessions
<: endif :><: if DOC_TYPE == 'fiction' :>├── 03-chart-the-causality/        ← a unit's beats, each with its cause
├── 04-chart-a-character-arc/      ← one character's change, mapped to sections
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_WORLDBUILDING :>├── 05-design-a-quest/             ← one quest, from trigger to ending
<: endif :><: if DOC_TYPE == 'business' :>├── 06-run-a-review-cycle/         ← review the documents that are due
├── 07-record-an-approval/         ← record a signing, an approval or a notice
├── 08-update-the-register/        ← add, change or retire a register row
<: endif :>├── 09-review-the-whole-work/      ← a lens panel over the whole work, as advice
└── local/                         ← your own procedures; same slug overrides a template one
```

## What's here

- **Four files per procedure**, always: `CONTEXT.md` (when to reach for it), `CLAUDE.md` (how
  to run it), `STEPS.md` (the ordered steps) and `CHECKLIST.md` (pre-conditions, execution,
  done-when, each item tagged with its model tier).
- **Numbers are frozen and append-only**, unique across every doc type, so a gap in the
  sequence is a procedure that belongs to another doc type, not a missing one.
- `local/` — procedures written for this project, in their own numbering.

## Cross-references

- `planning/docs/reference/` — the guides these procedures cite.
- `planning/src/` — where every procedure's output lands.
- `.claude/skills/run-workflow/SKILL.md` — the router that picks a procedure, `local/` first.
