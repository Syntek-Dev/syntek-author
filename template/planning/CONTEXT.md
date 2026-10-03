# CONTEXT.md — planning/

The planning layer: everything written *about* the work rather than *in* it. The outline that
orders the units, one brief per unit, the doc type's structural plans and registers, decision
maps and review reports all live here, so the content layer holds prose and nothing else.
Nothing in this layer is built into the finished work, and no prose is drafted here.

## Directory Tree

```text
planning/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules
├── docs/             ← guides: reference/ (template-owned) and project/ (yours)
├── src/              ← the plans: outline, unit briefs, maps, reviews, doc-type plans and registers
└── workflows/        ← numbered procedures, plus local/ for your own
```

## What's here

- `docs/` — **how planning is done here.** `docs/reference/` ships with the template and is
  updated by `copier update`; `docs/project/` is yours, and a same-named guide there overrides
  the reference one.
- `src/` — **the plans themselves.** `src/outline.md` orders the units; `src/units/` holds one
  brief per unit; `src/maps/` and `src/reviews/` hold decision maps and review reports. The
  plans and registers that only this doc type needs are listed in `src/CONTEXT.md`.
- `workflows/` — **the procedures.** Template procedures sit at `workflows/NN-name/`; your own
  sit at `workflows/local/NN-name/` and win over a template procedure with the same slug.

A *unit* is a chapter or a document; a *section* is one passage of roughly 300–500 words inside
it. The unit's plan lives here; its prose lives in the content layer and is assembled from
promoted sections, so plan and prose never share a file.

## Cross-references

- `.claude/rules/syntek-author/01-layout-and-routing.md` — the layer table, the pair rule and
  which folder is the content layer in this project.
- `planning/src/CONTEXT.md` — the full inventory of plans for this doc type.
- `planning/workflows/CLAUDE.md` — 'You want to… | Procedure'.
- `standards/verification/verification.md` — the gates a unit passes on its way to `final`.
