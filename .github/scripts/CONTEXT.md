# CONTEXT.md — .github/scripts/

The audits and tests of `DESIGN.md` Section 7, one script per row, in the syntek-base house shape:
a header saying why the check exists (the failure it prevents), numbered checks, what it CANNOT
check, a `--self-test` that proves each check fires on its own mutation with exactly one finding,
and exit codes 0 (clean), 1 (findings, or a self-test that no longer separates) and 2 (could not
run). Check numbers are stable identifiers: append, never renumber.

Nothing here is rendered, and nothing here writes under `template/`.

## Directory Tree

```text
.github/scripts/
├── CONTEXT.md                ← this file
├── CLAUDE.md                 ← how to run, read, add to and change the audits
├── _common.sh                ← sourced library: copier.yml readers, DESIGN.md catalogue, harness, fixtures
├── run-all.sh                ← renders once, runs every self-test and audit, accumulates failures
├── check-template-tokens.sh  ← token syntax, registration, and the spine-set token discipline
├── gen-mode-excludes.sh      ← writes, or --check's, copier.yml's generated mode-file block
├── docs-pairing.sh           ← folder pairs; CONTEXT, CLAUDE, workflow, guide and header shapes
├── line-cap.sh               ← 300 lines for every instructional .md
├── scrub.sh                  ← personal data, source-repository names, absolute paths
├── dev-isolation.sh          ← template skills denied in the root settings; CLAUDE.md excludes
├── shipped-seeds.sh          ← seeds wired and empty (registers, index pairs, brand guides, 00-project.md, project.mk); examples copy-only
├── skill-conformance.sh      ← DESIGN.md Section 5's contract for every skill and mode file
├── generate-all.sh           ← renders every DOC_TYPE × profile from a snapshot of the working tree
├── shipped-variants.sh       ← a render carries exactly its variant: skills, modes, gated paths, business families
├── byte-identity.sh          ← shared files identical in every render that ships them
├── doc-references.sh         ← every cited path and skill exists in that render
├── tooling-smoke.sh          ← the generated Makefile's targets and the tooling self-tests run in every render; no ignored file read; ISSUE guarded (issued PDFs, open items, switch values); the classification header; make flags honours BRAND_DIRS; make compare on a planted multi-round chain (every actor's macro, no ignored entry, SECTION needs UNIT, nothing to compare is no error, the PDF where XeLaTeX exists)
├── update-test.sh            ← a real copier update keeps author work, delivers template work, refuses a DOC_TYPE change; the v0.1.0 → v0.2.0 migrations (business families; every book's brief, a re-answered value kept)
├── adopt-test.sh             ← adopting an existing book, moving or additive, leaves its author's files untouched; the additive report on a business library names what an untick, an ignore rule or a kept workflow would cost, each same-named file with its redirect, and each kept file as committed, untracked or ignored
└── coexist-test.sh           ← a second template shares a project without collision
```

## What's here

Grouped by what each script reads:

- **The template source** (`copier.yml`, `template/`, the root settings):
  `check-template-tokens.sh`, `gen-mode-excludes.sh`, `docs-pairing.sh`, `line-cap.sh`,
  `scrub.sh`, `dev-isolation.sh`, `shipped-seeds.sh`, `skill-conformance.sh`.
- **The renders** that `generate-all.sh` produces (thirteen: theology, fiction and business ×
  defaults, all-on, minimal, adoption, plus fiction-conlang): `shipped-variants.sh`,
  `byte-identity.sh`, `doc-references.sh`, `tooling-smoke.sh`, and `docs-pairing.sh`,
  `shipped-seeds.sh`, `skill-conformance.sh` again.
- **Their own scratch projects**: `update-test.sh`, `adopt-test.sh`, `coexist-test.sh`. Their
  self-tests run the whole flow against the fixture template in `_common.sh`, so they prove the
  harness even while the real template is incomplete. `update-test.sh` also upgrades a business
  project and each book project from the `v0.1.0` tag to the working tree tagged with `VERSION`
  (checks 13–23), so the repository must carry its tags (CI checks out with `fetch-depth: 0`);
  its self-test gives the fixture two tagged releases of its own and runs the real
  `migrations/v0.2.0-business-families.sh` and `migrations/v0.2.0-project-settings.sh`.
- **`_common.sh`** is the single reader of `copier.yml` (list items, registered keys, gated paths,
  gate negation) and the single transcription of `DESIGN.md` (the skill catalogue, every gated
  path, the seeds, the examples, the spine set, and the business families with their
  `fam-<family>` gates). **It changes in the same commit as `DESIGN.md`.**

## The spine set, as the audits compute it

`DESIGN.md` Section 2 allows variant tokens and conditional blocks only in the spine set. The
audits compute it from `DESIGN.md` and `copier.yml` together: the root spine; every
`_skip_if_exists` seed; every seed-once example; and every index file — a `CONTEXT.md` or
`CLAUDE.md` whose folder holds a gated descendant. An index file's gates must be shipping gates:
`DESIGN.md` Section 3.5's, or the negation of a templated `_exclude` line.

## Cross-references

- `DESIGN.md` Section 7 — the audit list; Sections 2–5 — the contract the audits check.
- `copier.yml` — read by most scripts; written only by `gen-mode-excludes.sh`, between its markers.
- `.github/workflows/audit-template.yml` — runs these scripts in CI.
- `adopt/theology.sh` — run by `adopt-test.sh` before the adoption copy, when present.
