# CONTEXT.md — .github/workflows/

The template repository's CI. One workflow, `audit-template.yml`, runs every audit and test in
`.github/scripts/` on every push to every branch, on pull requests and on demand. It exists because
a template defect is invisible until somebody generates, and whoever generates is not whoever
broke it: a gate that waits for a pull request lets a branch drift unseen for as long as it lives.

This folder holds the template's own workflow only. The Google Drive workflows that the business
variant ships live in `template/.github/workflows/` and never run here.

## Directory Tree

```text
.github/workflows/
├── CONTEXT.md            ← this file
├── CLAUDE.md             ← operating rules for the workflow
└── audit-template.yml    ← three parallel jobs: template source, renders, update and adoption
```

## What's here

- `audit-template.yml` — three jobs, each running every script's `--self-test` before its real
  run and reporting failures as `::error::` lines that accumulate:
  - **[1/3] Template source** — tokens, the mode-file block, pairs and shapes, the line cap,
    personal data, development isolation, seeds, skills; then shellcheck at warning level over
    `migrations/`, `adopt/`, `.github/scripts/` and the template's hooks (shellcheck-py, pinned),
    which runs even when an audit step failed.
  - **[2/3] Renders** — installs uv and Pandoc, renders every variant and profile once, and runs
    the per-render audits over all of them. XeLaTeX is not installed (too slow to be worth it
    here), so `make pdf` is proved locally and named as skipped in CI.
  - **[3/3] Update, adoption, coexistence** — real `copier update`, a real adoption, and a dummy
    second template beside the first, each in its own scratch project.

## Cross-references

- `.github/scripts/CONTEXT.md` — what each script checks.
- `.github/scripts/run-all.sh` — the same run, locally, in one command.
- `DESIGN.md` Section 7 — "CI runs every audit on every push, with no path filter".
