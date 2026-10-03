@./CONTEXT.md

# CLAUDE.md — manuscript/workflows/03-improve-your-draft/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `manuscript/CONTEXT.md` →
`manuscript/CLAUDE.md` → `manuscript/workflows/CONTEXT.md` → `manuscript/workflows/CLAUDE.md` →
this folder's `CONTEXT.md` (when to use it, imported above) → this file → `STEPS.md` (with
`CHECKLIST.md` open).

## Purpose (one line)

Make the author's own section better at the strength they chose, proposing every change with its
reason and applying only what they accept.

## How to work here

**Follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.** The model tags in the checklist
are authoritative.

- **Routing:** skill `improve-section`, whose mode file adds this project's structural checks; it
  is this procedure in skill form. `spelling` and `grammar` for the mechanics pass. Guides:
  `manuscript/docs/reference/drafting-with-ai.md`,
  `manuscript/docs/reference/section-anatomy.md`.
- **Model:** **Opus** for every pass and every proposal; the mechanical tier only for applying an
  accepted diff and logging (`.claude/rules/syntek-author/05-model-allocation.md`).
- **The order is structure, then line, then mechanics.** Proofreading a paragraph that is about to
  be cut wastes the pass, and worse, makes the reviewer reluctant to recommend the cut.
- **Concrete steps:** locate and prepare the draft → agree the strength → read it against its brief
  → structural pass (`rework` only) → line pass (`edit` and `rework`) → mechanics pass (always) →
  present the numbered diff → apply what is accepted → log every decision → hand back.
- **Definition of done:** the author has seen every proposal with its reason; only accepted changes
  were applied; nothing outside the lane was edited; every proposal is logged, accepted or rejected;
  the draft is at `status: improved` and still in drafts.

## Guardrails

- **Report, then apply.** Never edit the draft before the author has answered the diff.
- **Stay in the lane.** Never alter a figure, date, citation key, quotation, commitment or the
  argument. Raise them as questions, listed apart from the diff.
- **Respect the strength.** At `light`, a structural concern is a one-line note, not a proposal. A
  `rework` keeps the section's argument or events and its one job.
- **Preserve the voice; tidy around it.** Keep the author's cadence, deliberate fragments, dialect
  and habits recorded in `standards/style/voice-notes.md`.
- **Do not tidy away an honest hedge.** Check `standards/method/method.md` before proposing a cut.
- **Supportive proofreading.** Say what and where, offer the correction, group recurring items so
  one decision fixes many, and never remark on the author.
- **Never overwrite the draft** beyond the accepted changes, and **never promote**.

## Output & naming

- **Produces:** the improved `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`, at
  `status: improved`.
- **Also writes:** every proposal into the ledger entry's `## Improvement decisions` table; the
  section's status in the brief; for a section without one, its frontmatter and ledger entry.
- **Generated:** nothing.
- **Does not touch:** the chapter file, any standard, or the ledger's `## AI original`.
