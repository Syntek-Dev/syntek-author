@./CONTEXT.md

# CLAUDE.md — .github/workflows/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `.github/CONTEXT.md` →
`.github/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep the Drive push and pull workflows correct, consistent with each other, and safe for live
documents.

## How to work here

- **Routing:** CI configuration; no writing skill applies. Edit only when the sync pipeline itself
  must change, on the author's instruction.
- **Model:** **Opus**.
- **Concrete steps:**
  1. Read both workflows in full; a change to paths, authentication or file types usually
     belongs in both.
  2. Make the minimal change, and validate the YAML before finishing.
  3. Tell the author what will now sync, or stop syncing, and confirm.
- **Definition of done:** both files parse (and pass `actionlint` where it is available); their
  path filters, file types, exclusions and authentication agree; no credential is embedded; push
  still sends only issued artefacts, and pull still never overwrites a tracked file.

## Guardrails

- **Never commit a secret.** Use repository secrets only.
- **Keep push and pull consistent.** A file type or exclusion in one and not the other (or the
  reverse) makes the two sides drift apart.
- **Push sends only issued artefacts** (`CONTEXT.md` lists them): never widen it to a file whose
  status is not `final`, a `drafts/` folder, a reading copy or a Drive copy. Issue is the
  author's act (`standards/risk/BUSINESS.md` rule 6).
- **Pull never overwrites a tracked file.** A differing Drive copy is saved beside it as
  `<name>.drive-DD-MM-YYYY.<ext>` and reported; the author compares and decides. It always skips
  a PDF beside a `.tex`, which the repository renders and issues.
- **The Drive folder lives in a shared drive**, with the service account as a Content manager. A
  service account cannot own files, so a folder in My Drive breaks every upload; never remove the
  push's check for it.
- **Keep the shared concurrency group.** A push and a pull running together can each undo the
  other.

## Output & naming

- Hand-written YAML, kebab-case, `.yml`; one self-contained workflow per job.
