@./CONTEXT.md

# CLAUDE.md — .github/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → this folder's `CONTEXT.md` (imported
above) → this file.

## Purpose (one line)

Hold the CI configuration that synchronises issued documents with the Google Drive folder in the
project's shared drive.

## How to work here

- **Routing:** infrastructure, not a document: no writing skill applies. Change it only when the
  sync itself must change, and only on the author's instruction.
- **Model:** **Opus**; a change here affects live documents on a shared drive.
- **Concrete steps:** read the workflow in full; make the smallest change that does the job;
  explain to the author what will sync differently, and confirm before committing.
- **Definition of done:** the YAML is valid, both workflows still trigger as intended, and no
  secret is written into a file.

## Guardrails

- **Never commit a secret, token or credential.** Workflows read them from repository secrets,
  referenced as GitHub expressions; a value pasted into a file is a value published.
- **Changes here affect live documents.** Confirm the author's intent before altering a trigger,
  a path or the direction of sync.
- **Only issued documents leave the repository.** Never widen the push to a `drafts/` folder or
  to a file whose status is not `final`.
- **The repository is the record.** Never let the pull overwrite a tracked file; a differing Drive
  copy is saved beside it for the author to compare.

## Output & naming

- Hand-written YAML in `workflows/`, kebab-case and named by function.
