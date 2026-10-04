@./CONTEXT.md

# CLAUDE.md — .github/scripts/

Read order: `.claude/CLAUDE.md` → `CONTEXT.md` → `.github/CONTEXT.md` → `.github/CLAUDE.md` →
this folder's `CONTEXT.md` (imported above) → this file → the header of the script you are about
to run or change.

## Purpose (one line)

Run, read and maintain the audits that prove the template keeps every promise `DESIGN.md` makes.

## How to work here

- **Routing:** the contract → `DESIGN.md`; its transcription → `_common.sh`; one audit → its own
  header; all of them → `run-all.sh`; CI → `.github/workflows/audit-template.yml`.
- **Model:** **Opus** to add or change a check, or to diagnose a failure; the mechanical tier to
  run the suite and report its output.
- **Concrete steps:**
  1. Everything: `bash .github/scripts/run-all.sh` (`--no-self-test`, `--skip-integration` and
     `--skip-pdf` shorten a local loop; `--keep --out DIR` keeps the renders to inspect).
  2. One audit on the source: `bash .github/scripts/<script>.sh`. One audit on renders:
     `bash .github/scripts/generate-all.sh DIR > trees.txt`, then
     `bash .github/scripts/<script>.sh $(cat trees.txt)`.
  3. Regenerate the mode-file block after adding or removing a `THEOLOGY.md`, `FICTION.md` or
     `BUSINESS.md`: `bash .github/scripts/gen-mode-excludes.sh` — never type a line between
     its markers by hand.
  4. Adding a check: give it the next number, say in the header why it exists and what it cannot
     check, add ONE mutation to the `--self-test` that produces exactly ONE finding from it, and
     run the self-test before and after.
  5. Lint after any change, as CI's job [1/3] does:
     `uvx --from shellcheck-py shellcheck -S warning -x migrations/*.sh adopt/*.sh .github/scripts/*.sh template/.claude/hooks/*.sh`.
     A script that sources `_common.sh` names it `# shellcheck source=SCRIPTDIR/_common.sh`, so
     a variable it sets for `_common.sh` reads as used from any directory; never silence SC2034.
     Write awk that mawk also runs (no multibyte bracket classes — use `(├|└)`, not `[├└]`).
- **Definition of done:** the changed script's `--self-test` passes, and `run-all.sh` exits 0, or
  exits 1 only with findings that are genuinely the template's to fix.

## Guardrails

- **Fix the check, never the expectation.** A self-test that stops separating good input from bad
  is a broken detector; editing the probe until it passes hides that.
- **Append, never renumber.** Check numbers are cited in reports, findings and other files.
- **One finding per mutation.** A probe that trips two checks proves neither; narrow the mutation
  or separate the checks (a vanished file is one check, a missing change in a present file another).
- **Self-test fixtures are written at runtime, never checked in** — a checked-in fixture drifts
  from the checks it was meant to prove.
- **Exit 2 means the run is incomplete.** Never turn a missing tool or input into a pass; a skip
  is named as a skip.
- **Mirror `DESIGN.md`, do not interpret it.** When `DESIGN.md` and `_common.sh` disagree,
  `DESIGN.md` wins and `_common.sh` changes in the same commit.
- **Never write under `template/`, and never commit a render.** Scratch goes to `${TMPDIR:-/tmp}`.

## Output & naming

- **Hand-written:** `<audit>.sh` exactly as `DESIGN.md` Section 7 names it; shared code only in
  `_common.sh`. Finding text starts `check N — <path>` so it can be grepped by number.
- **Generated (never hand-edit, never commit):** renders (`<doc_type>-<profile>/`), their
  `.log`, `.status` and `.expect` sidecars, and the `.smoke-*.log` files tooling-smoke keeps when
  a target fails.
