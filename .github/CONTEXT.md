# CONTEXT.md — .github/

The template repository's own continuous integration: the audits and tests that prove
syntek-author still generates what `DESIGN.md` promises, and the workflow that runs them on every
push. Nothing here is rendered — `_subdirectory: template` keeps the repository root out of every
generated project — so nothing here ships, and nothing here may assume it will. The business
variant's Google Drive workflows are a different thing entirely: they live in `template/.github/`,
are gated on `INCLUDE_DRIVE_SYNC`, and ship.

## Directory Tree

```text
.github/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules for the audits and their workflow
├── scripts/          ← one script per DESIGN.md Section 7 audit, the runner, and the shared library
└── workflows/        ← audit-template.yml: every audit, every push, no path filter
```

## What's here

- `scripts/` — sixteen audits and tests in the syntek-base house shape (a header saying why the
  check exists, numbered checks, what it cannot check, a `--self-test`, exit codes 0/1/2),
  `run-all.sh` to run them all against one set of renders, and `_common.sh`, the one reader of
  `copier.yml` and the one transcription of `DESIGN.md`'s catalogue. **A change to `DESIGN.md`
  changes `_common.sh` in the same commit.**
- `workflows/` — `audit-template.yml`, three parallel jobs (template source, renders, update and
  adoption) that run every self-test before every real run.

## Why the audits exist

Every promise `DESIGN.md` makes about a generated project — this variant gets these skills and not
those, a shared file is the same file in every variant, a seed ships empty, an update keeps the
author's edits — rests on one line of `copier.yml` or one file under `template/`, and none of them
fails loudly when that line is wrong. Copier renders successfully either way. These scripts are the
only place the failure becomes visible before an author meets it.

## Cross-references

- `DESIGN.md` Section 7 — the audit list and what each one checks; this folder implements it.
- `copier.yml` — the gates, seeds and questions the audits read.
- `template/.github/` — the shipped Drive workflows (business), unrelated to these.
- `adopt/` — the adoption scripts `scripts/adopt-test.sh` runs before its copy.
