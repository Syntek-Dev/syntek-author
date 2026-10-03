# CONTEXT.md — library/workflows/local/

The author's own procedures for the library: recurring jobs this business does that the
template's procedures do not cover, and any template procedure this project needs to run
differently. The template ships only this pair; every procedure here is written for this project
and is never touched by `copier update`.

## Directory Tree

```text
library/workflows/local/
├── CONTEXT.md              ← this file (add a tree line and a table row for each procedure)
├── CLAUDE.md               ← operating rules
└── NN-verb-first-name/     ← one folder per procedure: CONTEXT.md, CLAUDE.md, STEPS.md, CHECKLIST.md
```

## What's here

| You want to… | Procedure |
|---|---|
| *(no local procedures yet)* | — |

- **Own numbering.** A new procedure here takes the next free two-digit number in this folder; the
  template's numbering does not constrain it.
- **Overrides.** A copy of a template procedure under exactly the same folder name, number
  included, replaces that procedure for this project: a copy of
  `library/workflows/03-improve-your-draft/` placed here is the one that runs. The `run-workflow`
  skill looks here first.

## Cross-references

- `library/workflows/` — the template's procedures, and the four-file format to copy.
- `library/workflows/CLAUDE.md` — the rules every procedure follows.
