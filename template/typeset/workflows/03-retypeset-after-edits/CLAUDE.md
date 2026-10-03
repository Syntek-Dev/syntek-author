@./CONTEXT.md

# CLAUDE.md — typeset/workflows/03-retypeset-after-edits/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/workflows/CONTEXT.md` → `typeset/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (what it produces, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Carry a chapter's styling onto its revised words with a three-way merge, and prove the result.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `typeset`; it is this procedure in skill form. Guides: the pipeline and the
  fidelity check, in `typeset/docs/reference/`.
- **Model:** the **mechanical tier** for `make tex`, the merge command, the check and the print;
  **Opus** for resolving every clash and reading the proof
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **The three files of the merge:** the styled chapter (old words, styled), the old base (old
  words, plain), the new base (new words, plain). The merge applies 'old base → new base' to the
  styled chapter.
- **Concrete steps:** confirm → `make tex` → find the old base → `git merge-file` → resolve each
  clash from the new base → check → print the changed pages → tidy and report.
- **Definition of done:** the styled chapter holds no conflict marker, passes `make tex-check`
  against the revised Markdown, keeps its styling, and the old base has been deleted.

## Guardrails

- **The new base's words win every clash.** Copy the new line, then re-apply the styling to it.
  Never keep an old word because a macro was on it, and never type a word to 'tidy' a merge.
- **Use the right ancestor.** The old base is the one the styled file was made from: the copy
  `make tex` kept in `build/typeset/`, or the base committed with the styled file. Any other
  ancestor silently undoes edits (the check would catch it, but late).
- **Never start the styling over** without the author's agreement; that is a decision, not a fix.
- **Never edit the new base** to make the merge easier.

## Output & naming

- **Produces:** the updated base and styled chapter in `typeset/src/units/`, and a proof in
  `build/typeset/`.
- **Removes:** `build/typeset/NN-kebab-title.old-base.tex`, once the check passes.
- **Touches nothing else.** The Markdown is already revised before this procedure starts.
