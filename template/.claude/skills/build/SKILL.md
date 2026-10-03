---
name: build
description: >-
  Build a proof of the work with make and read it before reporting: choose the scope and the
  format, regenerate the references where the project keeps them (make refs), run the make target
  for this kind of project, confirm the file list or file the build echoed, open the output and
  check it, then report every defect with the procedure that owns its fix. Proofs are ungated: a
  proof can be built at any status and changes nothing. Use when the author says 'build me a
  proof', 'make a PDF of chapter 2', 'render the proposal', 'give me a Word copy for my editor',
  'build the whole book', 'does it still compile?' or 'let me read it as a reader would'. Not for
  fixing what the proof reveals, which goes back through the loop (`adapt-section`). Not for
  moving a section into the unit before it can appear in a proof (`promote-section`). Not for
  checking whether claims are still current before an export (`fact-check`).
---

# Skill: Build (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

Turns the sources into something to read, and reads it. Everything goes through `make`, because
the targets carry the reference regeneration, the output naming and the exclusions that keep a
draft out of an editor's copy. A successful build is not a good proof: this skill opens the
output, checks it, and reports what it found, naming the procedure that owns each fix. It never
edits anything under `build/` and never changes a source to make a build pass.

## Governing procedures (route here — do not restate at length)

- The content layer's `workflows/06-build-a-proof/` — this skill is that procedure in skill form;
  the mode file names its path and any other procedure that uses this skill.
- If a layer's `workflows/local/` holds a folder with the same `NN-name` as a procedure named
  here or in the mode file, follow that procedure instead: the author's local procedure replaces
  the template's (`run-workflow`, step 2).
- `.claude/rules/syntek-author/04-build-pipeline.md` — the pipeline, the targets and their rules;
  where it and `make help` disagree, `make help` is right.
- `standards/verification/verification.md` Section 5 — proofs are ungated; release is not.
- The content layer's `docs/reference/` guide on the shape of the unit (the mode file names it).

## Steps

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they disagree, the procedure wins and the disagreement is reported to the author.

1. **Fix the scope and the format.** Agree what to build (a unit, the whole work, one document) and
   in which format, from the targets the mode file lists and `make help` confirms. If the request
   is ambiguous, ask before running a long build. A section still in its drafts folder cannot
   appear in a proof: promote it first, or read the draft itself.
   *Complete when:* the scope and the format are named, and both exist as a target.

2. **Check before an export leaves the author.** A working proof skips this step. If the output is
   going beyond the author (an editor, a publisher, a client, a shared drive), check the unit's
   status: release needs `final`, or the author's explicit, recorded decision to send a proof
   marked as such (`standards/verification/verification.md` Section 5). Apply the mode file's
   pre-export checks, and report anything stale to the author: whether it blocks the export is
   their call.
   *Complete when:* the export's status is confirmed, or this is a working proof.

3. **Regenerate the references, where the project keeps them.** If `make help` lists `refs`, run
   `make refs` first, so a reference failure reads clearly. If it reports the database missing,
   stop and tell the author to run `make init`; never bootstrap it mid-build. Without the
   references option there is no `refs` target, and this step is skipped.
   *Complete when:* the references are current, or the step does not apply, or the run has
   stopped and said why.

4. **Build through `make`.** Run the target the mode file gives for the scope and format, from the
   repository root. Never call Pandoc, XeLaTeX or the reference tooling directly. If a tool is
   missing, say which one and which target it blocks; never report a target as passed when it
   could not run.
   *Complete when:* the target has exited, and its output path is known, or the failure is named.

5. **Confirm the build took what you expected.** Check the file list or the file the build echoed
   (the mode file says which). Something missing from a book proof is almost always still in
   drafts, which means it is not promoted, which means it should not be in the build: **never work
   around the exclusion**. Check the output is newer than its sources.
   *Complete when:* every file expected is accounted for, and nothing unexpected was built.

6. **Read the proof.** Open the output and check it against the mode file's list: citations and
   cross-references resolved, nothing a reader should not see (markers, internal notes, raw
   markup), headings and order as intended, special characters rendered. A problem found is a
   finding with its location, not a fix.
   *Complete when:* the whole output has been read, and every defect has a location.

7. **Report back.** Give the output path or paths, the scope and format, the unit's status, what
   was checked, anything raised in step 2, and every defect with its location. For each, name the
   procedure that owns the fix (a section procedure for prose, the reference skill for a reference
   record, `fact-check` for a claim, the promotion for a conversion) and stop there.
   *Complete when:* the author has the report, and nothing under `build/` or any source was edited
   to make the proof look right.

## Anti-patterns

- Reporting a build as good because it exited without error. Read it.
- Calling Pandoc or XeLaTeX directly, and so building a draft into an editor's copy.
- Moving a draft out of `drafts/`, or editing a filter, so that it appears in a proof.
- Hand-editing anything under `build/`, or a rendered PDF, to fix what the proof shows.
- Running `make init`, or rebuilding the references database, in the middle of a build.
- Sending a proof beyond the author without the unit's `final` status or their recorded decision.
- Fixing a wording defect in place instead of sending it back through the loop.
- Handing over a lossy conversion as the deliverable.

## Cross-references

- `promote-section` — the only way a section reaches a proof.
- `adapt-section` and `improve-section` — where a wording defect found in a proof is fixed.
- `fact-check` — claim currency before an export; a claim a proof shows to be doubtful.
- `.claude/rules/syntek-author/04-build-pipeline.md` — the targets, and what each needs installed.
- `Makefile` — the single entry point; `make help` lists every target this project has.
