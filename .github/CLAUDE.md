@./CONTEXT.md

# CLAUDE.md — .github/

Read order: `.claude/CLAUDE.md` → `CONTEXT.md` → this folder's `CONTEXT.md` (imported above) →
this file → the `CONTEXT.md` and `CLAUDE.md` of `scripts/` or `workflows/`, whichever you are
about to change.

## Purpose (one line)

Keep the template honest: every promise `DESIGN.md` makes about a generated project is checked
here, on every push, before any author meets the failure.

## How to work here

- **Routing:** what an audit checks and how → `scripts/`; when and where CI runs it →
  `workflows/`; what the audits check AGAINST → `DESIGN.md` (and `scripts/_common.sh`, its
  transcription).
- **Model:** **Opus** for a new check, a changed rule or a diagnosis; the mechanical tier for
  re-running audits and reading their output.
- **Concrete steps:**
  1. Run everything locally: `bash .github/scripts/run-all.sh` (add `--no-self-test` while
     iterating; never in CI).
  2. Read a failure by its check number and path — each script's header says what the number
     means and why the rule exists.
  3. Fix the template (or `copier.yml`), then re-run the one script that failed, then
     `run-all.sh`.
  4. Changing an audit: run its `--self-test` before and after the change.
- **Definition of done:** `run-all.sh` exits 0 locally and every job of `audit-template.yml` is
  green on the branch.

## Guardrails

- **Fix the template, never the expectation.** A check that fails is reporting a promise the
  template broke. Weakening the check to pass the build ships the broken promise to every author.
- **Never mark a skip as a pass.** A script that could not look (no `copier.yml`, no renders, no
  Pandoc under `--require-pandoc`) exits 2, and a check whose input is absent says so by name.
- **Nothing here writes under `template/`.** The one script that writes at all,
  `gen-mode-excludes.sh`, writes the generated block of `copier.yml` and nothing else.
- **No personal data, anywhere.** Fixtures use invented people and places; client names for
  `scrub.sh` live in a deny-list outside the repository (`SCRUB_DENYLIST`), never in it.
- **A workflow file never contains the dollar-brace-brace sequence** — GitHub parses it even
  inside a `run:` block. Loop in the shell instead of using a matrix.

## Output & naming

- **Hand-written:** kebab-case `.sh` scripts named as `DESIGN.md` Section 7 names them; one
  workflow, `audit-template.yml`.
- **Generated (never commit):** renders, logs and scratch projects go under `${TMPDIR:-/tmp}`,
  never into this repository.
