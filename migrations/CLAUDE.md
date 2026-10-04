@./CONTEXT.md

# CLAUDE.md — migrations/

Read order: `.claude/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file → the header of the script you are about to change.

## Purpose (one line)

Carry what an author wrote across a release that moves the folder it lives in, or the place a setting is read from, so that no update strands or reverts author work (DESIGN.md D44).

## How to work here

- **Routing:** the rule is DESIGN.md D44 and D26; the entry and the house shape are in `copier.yml` under `_migrations`; the proof is `.github/scripts/update-test.sh`.
- **Model:** **Opus** for a new migration or any change to what one moves or writes; the mechanical tier for report wording.
- **Concrete steps:**
  1. Write the migration in the same change as the release that moves the folder or the setting. Name it `vX.Y.Z-<what>.sh`, keyed to the release the change shipped in, never the release somebody noticed.
  2. Header in the syntek-base shape: what moved and why the update strands it, the map, what it never does, how it runs, `Exit codes: 0 = always`.
  3. Guard on markers, never on guesses: act on an old folder only once its template `CONTEXT.md` is gone (Copier retired it), move into a new folder only once its `CONTEXT.md` is there (the update delivered it), and write into a new seed only once the update has delivered it.
  4. Add its `_migrations` entry: `version:`, `command: bash "<% _copier_conf.src_path %>/migrations/<script>.sh"`, and `when:` with `_stage == 'after'` plus any variant test.
  5. Prove it in `update-test.sh`: render at the previous tag, act as the author (plant files in every old folder, with one collision and one that must not move; or change a value in its old home, and re-answer another during the update itself), update to the snapshot tagged with `VERSION`, and assert each file moved byte for byte and none was lost, or that the new home took the value and kept the fresh answer. Then commit, run the script a second time and assert nothing changes.
  6. End the report with the command that runs the script again (the update's copy of the template is deleted when it ends): `rerun_cmd` in either v0.2.0 script builds it from `_src_path`.
  7. `bash -n` the script, and shellcheck it at warning level, as CI does: `uvx --from shellcheck-py shellcheck -S warning -x migrations/*.sh adopt/*.sh .github/scripts/*.sh template/.claude/hooks/*.sh`.
- **Definition of done:** an update across the release moves every author file, or carries every value, that has one correct home, leaves and names every other, and a second run changes nothing.

## Guardrails

- **Always exit 0.** A non-zero exit aborts every later migration and leaves the project half-upgraded. Print what needs a human instead.
- **Never overwrite, never delete a file.** An existing destination is reported and both files stay. Only a folder its own moves left empty may be removed.
- **Edit only a seed the same release delivered, and only a line that still holds the recorded answer.** Every seed the author already had is reported line by line, never rewritten: what they wrote around the line is theirs.
- **Act only where exactly one result is correct.** Anything that depends on what the author meant is a report line.
- **Never move a git-ignored file to a path git would not ignore, and never read one** (D42): ignore rules written for the old path protect credentials and local-only material. Read only what `git ls-files -co --exclude-standard` lists, and suggest only commands that do the same (`git grep`, never `grep -r`).
- **Idempotent by construction.** A second run finds nothing to move and nothing to write.
- **No personal data.** Fixtures in the test use invented clients, files and values.

## Output & naming

- **Hand-written:** `vX.Y.Z-<what>.sh`, executable, one per change that needs one.
- **Report format:** a `▸` heading; one `moved  <old> -> <new>` or `changed  <setting>: '<old>' -> '<new>'` line per action; then counts, every file left or value not written with its reason, every line still citing an old path or giving old guidance as `file:line` with its replacement, and the re-run command.
