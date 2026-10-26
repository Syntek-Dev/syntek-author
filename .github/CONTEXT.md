# CONTEXT.md — .github/

The template repository's own continuous integration: the audits and tests that prove
syntek-author still generates what `DESIGN.md` promises, and the workflow that runs them on every
push; and the repository's GitHub community files, the issue forms, the pull-request template and
the code owners. Nothing here is rendered — `_subdirectory: template` keeps the repository root
out of every generated project — so nothing here ships, and nothing here may assume it will. The
business variant's Google Drive workflows are a different thing entirely: they live in
`template/.github/`, and ship only to a business project that answers `DATA_PROVIDER` google-drive
and keeps its files in the repository (`DATA_STORE` repo); a store guard step in each stops it if
the project's answers record any other store (DESIGN.md D37, D53).

## Directory Tree

```text
.github/
├── CONTEXT.md        ← this file
├── CLAUDE.md         ← operating rules for the audits and their workflow
├── scripts/          ← one script per DESIGN.md Section 7 audit, the runner, and the shared library
├── workflows/        ← audit-template.yml: every audit, every push, no path filter
├── ISSUE_TEMPLATE/   ← two issue forms (bug report, template improvement); config.yml: no blank issues
├── PULL_REQUEST_TEMPLATE.md   ← the pull-request summary, decision and checklist
└── CODEOWNERS        ← @Syntek-Studio on every path, with the closer reads named
```

## What's here

- `scripts/` — seventeen audits and tests in the syntek-base house shape (a header saying why the
  check exists, numbered checks, what it cannot check, a `--self-test`, exit codes 0/1/2),
  `run-all.sh` to run them all against one set of renders, and `_common.sh`, the one reader of
  `copier.yml` and the one transcription of `DESIGN.md`'s catalogue. **A change to `DESIGN.md`
  changes `_common.sh` in the same commit.**
- `workflows/` — `audit-template.yml`, three parallel jobs (template source, renders, update and
  adoption) that run every self-test before every real run.
- `ISSUE_TEMPLATE/` — GitHub issue forms: a bug report and a template improvement, each warning
  against pasting manuscript text or personal data; `config.yml` turns blank issues off and links
  private security reporting and the README. No `CONTEXT.md` and `CLAUDE.md` pair: GitHub reads
  every file there as a form or its configuration.
- `PULL_REQUEST_TEMPLATE.md` — the summary, the decision cited or approved, and the checklist
  (`run-all.sh`, the `CHANGELOG.md` entry, `DESIGN.md` only with approval, `family-shared.sh
  --write` for shared bytes, no rendered output, no personal data, British English; and, under
  'Licence', the contributor's licence box).
- `CODEOWNERS` — `@Syntek-Studio` on every path, with closer reads named for the contract, the
  migrations, the family-shared manifest and the governance files, as in syntek-base.

## Why the audits exist

Every promise `DESIGN.md` makes about a generated project — this variant gets these skills and not
those, a shared file is the same file in every variant, a seed ships empty, an update keeps the
author's edits — rests on one line of `copier.yml` or one file under `template/`, and none of them
fails loudly when that line is wrong. Copier renders successfully either way. These scripts are the
only place the failure becomes visible before an author meets it.

## Cross-references

- `DESIGN.md` Section 7 — the audit list and what each one checks; this folder implements it.
- `copier.yml` — the gates, seeds and questions the audits read.
- `template/.github/` — the shipped Drive workflows (business, with `DATA_PROVIDER` google-drive
  and `DATA_STORE` repo), unrelated to these.
- `adopt/` — the adoption scripts `scripts/adopt-test.sh` runs before its copy.
