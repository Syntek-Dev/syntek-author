# CONTEXT.md — .github/

GitHub Actions configuration for this repository: the two workflows that keep the document
library in step with a Google Drive folder in a shared drive. It exists only while this project
answers Google Drive as its provider and keeps its documents in the repository (`DATA_PROVIDER`
google-drive, `DATA_STORE` repo); another provider, or the external store, deletes it on the next
`copier update`. Sync is automation, not a habit: documents are never copied to Drive by hand.
Nothing here writes documents: push sends issued ones, and pull adds new ones without overwriting
any the repository holds.

## Directory Tree

```text
.github/
├── CONTEXT.md                  ← this file
├── CLAUDE.md                   ← operating rules
└── workflows/                  ← the push and pull workflows, with their own pair
```

## What's here

- `workflows/` — `google-drive-push.yml` (repository → Drive, on every push to `main` that
  touches `library/src/`) and `google-drive-pull.yml` (Drive → repository, daily). **Only issued
  documents are pushed; drafts, governance files and reading copies never sync; a pull never
  overwrites a tracked file.** Both stop after checkout, before authenticating, unless the
  answers record `DATA_STORE` repo or no store, so a copy kept after the documents leave the
  repository never bins the Drive mirror. Setup, secrets and behaviour are in
  `workflows/CONTEXT.md`.

## Cross-references

- `library/src/` — the documents the workflows synchronise.
- `standards/risk/BUSINESS.md` — rule 6: nothing leaves the repository unreviewed.
