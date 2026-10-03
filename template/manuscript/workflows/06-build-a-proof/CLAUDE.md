@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/06-build-a-proof/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (scope, formats and outputs, imported above) → this file → `STEPS.md`
(with `CHECKLIST.md` open).

## Purpose (one line)

Render a chapter or the whole manuscript through `make`, and read the result properly.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `build`, whose mode file lists this project's formats; it is this procedure in
  skill form. `fact-check` for claim currency before an editorial export.
- **Model:** the **mechanical tier** for the build itself. **Opus** for three judgements: whether a
  stale claim should be reported before an export (step 2), whether the build included what it
  should (step 5), and reading the proof (step 6)
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Choosing scope.** `SCOPE` is a folder whose prose files build together, in order. One chapter is
  `SCOPE=manuscript/src/NN-kebab-title`; the whole manuscript is `make book`. **If the request is
  ambiguous about scope, ask** before running a long build.
- **Choosing format.** `.docx` for anything editorial; `.pdf` for a typeset proof with footnotes
  handled correctly; `.epub` to read as a reader would. Build `.docx` and `.pdf` when the request is
  just 'build'.
- **Concrete steps:** decide scope and format → check claim currency (exports only) → regenerate the
  references (references option only) → build → confirm the file list → read the proof → report.
- **Definition of done:** the requested scope and formats built without errors; the proof has been
  read, not merely produced; any stale claim was reported; the author has the output paths.

## Guardrails

- **Drive everything through `make`.** Never call Pandoc or the reference tooling directly: the
  targets encode the reference regeneration, the output naming and the exclusions, and bypassing
  them is how a draft ends up in an editor's copy.
- **Never defeat the drafts exclusion.** A section missing from a proof is still in drafts, which
  means it has not been promoted, which means it should not be in the build.
- **Never hand-edit anything under `build/`** to fix a rendering problem. Correct the source and
  rebuild; everything there is overwritten on the next run.
- **A successful build is not a good proof.** Read it.
- **`make init` is not part of this procedure.** If the references database is missing, stop and
  tell the author to run it.

## Output & naming

- **Produces:** files under `build/`, named after the scope; all git-ignored and rebuilt on demand.
- **Touches nothing else.** This procedure edits no prose, no reference data and no standard. If a
  proof reveals a problem, fix it at source through the procedure that owns it, then rebuild.
- **`make clean`** removes `build/`; it never touches the manuscript or the reference data.
