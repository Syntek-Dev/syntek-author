# CONTEXT.md — .github/workflows/

The two GitHub Actions workflows that synchronise `library/src/` with a Google Drive folder in a
shared drive. Push sends the repository's **issued** documents to Drive; pull brings documents
added on Drive into the repository and commits them, and never overwrites a file the repository
already holds. Both authenticate with Workload Identity Federation, so no service-account key is
ever stored, and both share one concurrency group, so a push and a pull never run at the same
time.

## Directory Tree

```text
.github/workflows/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← operating rules
├── google-drive-push.yml     ← repository → Drive: on push to main touching library/src/, or by hand
└── google-drive-pull.yml     ← Drive → repository: daily at 06:00 UTC, or by hand
```

## What's here

- `google-drive-push.yml` — uploads only issued artefacts under `library/src/` to the same folder
  path on Drive, creating folders as needed:
  - the PDF beside a `.tex` whose leading comment block reads `% status: final`;
  - `.docx` and `.xlsx` files;
  - a `.md` whose frontmatter reads `status: final`.

  **Never pushed:** anything under a `drafts/` folder; every `CONTEXT.md`, `CLAUDE.md` and
  `README.md`; an ingest reading copy (`<name>.reading.md`); a Drive copy saved by the pull
  (`<name>.drive-DD-MM-YYYY.<ext>`); every `.tex` source; an authored email, which has no
  frontmatter status and is sent by email, not Drive. A file that is not issued is logged as
  held back. A synced file moved or deleted in the repository has its old Drive copy moved to the
  Drive bin (recoverable for 30 days), and Drive folders left empty are binned too. A manual run
  with scope `all-files`, or the first push to `main`, considers every file and removes nothing.
- `google-drive-pull.yml` — reads every supported file in the Drive folder (native Google Docs and
  Sheets are exported as `.docx` and `.xlsx`). A file new to the repository is added at the same
  path; an identical one is left alone; **one that differs from the repository's file is never
  written over it**: it is saved beside it as `<name>.drive-DD-MM-YYYY.<ext>` and reported in the
  run's summary and the commit message, for the author to compare. A PDF beside a `.tex`, a
  `drafts/` folder and the governance files are always skipped. Any new file is committed with a
  dated message.

## Setup

1. In Google Cloud, create a Workload Identity Federation provider trusted by this repository,
   and a service account.
2. Put the documents folder **inside a shared drive** and add the service account to that shared
   drive as a **Content manager**. A folder in someone's My Drive will not work: a service account
   cannot own files, so it can create them only in a shared drive. The push stops with that
   message when the folder is not in one.
3. Add repository secrets: `WORKLOAD_IDENTITY_PROVIDER` (the provider's resource name),
   `SERVICE_ACCOUNT_EMAIL`, `GOOGLE_DRIVE_FOLDER_ID` (the folder in the shared drive), and, for
   pull's commits, `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL`.
4. Run each workflow once by hand from the Actions tab and check its log.

## Cross-references

- `library/src/` — the documents synchronised.
- `library/docs/reference/the-status-ladders.md` — where a document's `final` status lives, which
  the push reads.
- `library/workflows/08-ingest-an-existing-document/` — the reading copies the push leaves out.
- `standards/risk/BUSINESS.md` — rule 6: only a document approved for issue leaves the repository.
