# CONTEXT.md — .github/workflows/

The template repository's CI. One workflow, `audit-template.yml`, runs every audit and test in
`.github/scripts/` on every push to every branch, on pull requests and on demand. It exists because
a template defect is invisible until somebody generates, and whoever generates is not whoever
broke it: a gate that waits for a pull request lets a branch drift unseen for as long as it lives.

This folder holds the template's own workflow only. The Google Drive workflows that a business
project ships, while it answers `DATA_PROVIDER` google-drive and keeps its files in the repository
(`DATA_STORE` repo), live in `template/.github/workflows/` and never run here.

CI never sets `SYNTEK_DATA_ROOT` (DESIGN.md D50): every audit unsets it when it sources
`_common.sh`, the three Python self-tests run under `env -u SYNTEK_DATA_ROOT`, and a case that
needs a data root makes a temporary one. `UV_PYTHON` pins every `uvx` Copier to the jobs'
Python 3.12, which the resolver and the permissions script (3.11 or later) and Copier, the newest
and the declared floor alike (3.10 or later), all accept; locally, `_common.sh` sets it to
`python3` where it is unset. `_common.sh` also hides the global and system git configuration,
the runner's `/etc/gitconfig` included, so every audit's git reads the same configuration in CI
as on a laptop.

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
    personal data, development isolation, seeds, skills, the family-shared set; the update
    report script's own self-test (`migrations/family-update.py`), the data-root resolver's
    own self-test (`template/.claude/syntek-author-dataroot.py`) and the outside-link
    migration's (`migrations/agents-outside-link.py`); then shellcheck at warning
    level over `migrations/`, `adopt/`, `.github/scripts/` and the template's hooks
    (shellcheck-py, pinned), which runs even when an audit step failed.
  - **[2/3] Renders** — installs uv and Pandoc, renders every variant and profile once, and runs
    the per-render audits over all of them, then renders four profiles again on the Copier
    floor `copier.yml` declares (`_min_copier_version`) and compares them byte for byte with the
    newest Copier's renders. XeLaTeX is not installed (too slow to be worth it here), so
    `make pdf` is proved locally and named as skipped in CI.
  - **[3/3] Update, adoption, coexistence** — real `copier update`, a real adoption, and a dummy
    second template beside the first, each in its own scratch project.

## Cross-references

- `.github/scripts/CONTEXT.md` — what each script checks.
- `.github/scripts/run-all.sh` — the same run, locally, in one command.
- `DESIGN.md` Section 7 — "CI runs every audit on every push, with no path filter".
