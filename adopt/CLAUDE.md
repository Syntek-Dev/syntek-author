@./CONTEXT.md

# CLAUDE.md — adopt/

Read order: `.claude/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Prepare an existing writing repository for adoption: for `copier copy --overwrite`, make only the moves that have exactly one correct destination and report everything else; for the additive `copier copy --skip '*' --skip-tasks`, report what it adds and keeps and what the author must extend.

## How to work here

- **Routing:** the design is DESIGN.md Section 8 and D41 (additive); the user steps are `README.md`, "Adopting an existing repository"; the test is `.github/scripts/adopt-test.sh`.
- **Model:** **Opus** for any change to what the script moves or edits; the mechanical tier for wording in the report.
- **Concrete steps:**
  1. Confirm the change against DESIGN.md Section 8. A new **move** belongs there first, approved by the maintainer; a new **report** item does not.
  2. Change `adopt.sh` only; the three `<kind>.sh` wrappers stay one line of logic each.
  3. Build a fixture in a scratch directory (never in a real repository): a git repository on a branch, shaped like the case you are handling, with a collision and a file that must not move.
  4. Run advisory, then `--apply`, then `--apply` again. Check `git status` after the advisory run (empty) and after the second apply (no new changes).
  5. `bash -n adopt.sh`, and shellcheck at warning level, as CI does: `uvx --from shellcheck-py shellcheck -S warning -x migrations/*.sh adopt/*.sh .github/scripts/*.sh template/.claude/hooks/*.sh`.
- **Definition of done:** an author can run the script twice on a real repository and lose nothing, and the report tells them every decision that is still theirs.

## Guardrails

- **Advisory by default.** Without `--apply` the script must change nothing at all — not a timestamp, not a file mode.
- **`--additive` is report only.** It refuses `--apply`, renders the template into a temporary folder it removes on exit, and never writes in the repository. Its report is derived from that render, so it is exact for the answers and the source and ref given, and it prints both; keep it that way rather than guessing a variant's paths.
- **Read, never type, what the template defines.** Seeds come from `copier.yml`'s `_skip_if_exists`, family and option paths from its `_exclude` gate lines, and ignored paths from `git check-ignore -z --verbose`. A list copied into the script drifts, and the report then tells an author the wrong thing about their own files.
- **Only one-destination moves are automatic.** If a path could reasonably go to two places, or the right place depends on what the author meant, it is a report line, never a move.
- **Never overwrite, never delete.** An existing destination is a collision: report it and leave both files. Leftover folders are the author's to delete.
- **Never edit prose.** Nothing under `*/src/` is rewritten except a unit's frontmatter `status:` line; handoffs and learning records are history and are never edited.
- **Idempotent by construction.** A second run must find nothing to move or edit; a step that would act twice is wrong.
- **`--apply` refuses `main` and `master`, and anything outside a git work tree,** so every move can be reviewed with `git diff` and undone with git.
- **Invented values only in `examples/`.** No real author, title, client, trading name or path, ever — these files are public.

## Output & naming

- **Hand-written:** `adopt.sh` (SB script header: why it exists, what it does, what it never does, usage, exit codes); `<kind>.sh` wrappers; `examples/<kind>.answers.yml` with a header saying the values are invented.
- **Report format:** a `▸` heading per step, then one line per item: `moved`, `would move`, `collision`, `failed`, `edited`, `would edit`, `report`, `kept`, `replace`, `skipped`, `clean`; the additive report adds `add`, `ignored`, `inert` and `extend`.
- **Exit codes:** `0` report printed; `1` an `--apply` move failed and was left in place; `2` usage error or refusal.
