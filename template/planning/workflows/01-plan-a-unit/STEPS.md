---
workflow: 01-plan-a-unit
phase: plan
skills: [grill-with-docs]
model: opus
---

# STEPS.md — plan a unit, from idea to brief

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking one unit from a line in the outline to a brief the author has
agreed. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `grill-with-docs` skill runs the questioning in steps 4 to 7 and writes the brief and records
> V1 in step 8; read it and its mode file before step 1.

## 1. Place the unit in the outline

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Read `planning/src/outline.md` and confirm with the author which unit is being planned, where it
sits, and its name: for a chapter, `NN-kebab-title`; for a document, its slug. If the outline has
no row for it, add one on the author's word. _Substantive._

## 2. Confirm you will not clobber a brief

> **Skill:** none · **Guide:** `planning/docs/reference/unit-briefs.md`

Look for `planning/src/units/<unit>.md`. If it exists, this run re-plans it: read it in full,
list every section slug with a ledger entry in `standards/style/ledger/`, and confirm with the
author before changing anything. Those slugs are kept. _Mechanical._

## 3. Read what the repository already knows

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Read `.claude/MEMORY.md` (Decisions, Open questions, Sensitivities), the briefs either side of
this unit, the research notes and evidence it will lean on in `research/src/`, and any open map
in `planning/src/maps/` that touches it. A question the repository can answer is never put to
the author. _Substantive._

## 4. Settle the scope and the job

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Question the author until two slots can be written. **Scope:** what is in, what is deliberately
out, and where the out-of-scope material goes instead. **What this unit does:** what the stated
reader can do, believe or feel at its end that they could not at its start. Set
`audience_note` only where this unit's reader differs from the stated reader. _Substantive._

## 5. Settle the positions the unit commits to

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Fill the settled-positions slot the mode file names. Write in only what the author agrees. An
undecided point becomes `<!-- AUTHOR TO CONFIRM: … -->`; a checkable claim not yet checked
carries `<!-- VERIFY: … -->`. An empirical question goes to `fact-check`, never to the author's
memory or yours. _Substantive._

## 6. Cut the sections

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Divide the unit into sections of roughly 300–500 words, each doing one job, in plan order. Give
each a kebab-case slug and a one-line purpose, and note under `## Sections` what each carries
and what it hands on. A section that needs two lines to describe is two sections. _Substantive._

## 7. Name what the unit draws on

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

List the research notes, evidence entries and plans it relies on under `## Draws on`, and put
the citation keys or source-note slugs already held into `sources:`. A source the unit needs but
the project does not hold is a research task, written under `## Draft notes`, never a citation
invented now. _Substantive._

## 8. Write the brief and read it back

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Write `planning/src/units/<unit>.md` in the guide's shape: `status: idea`, `verified: {}`, every
section at `status: ""`, then the six body slots, one sentence per line. Read it back to the
author and apply their corrections. When the author agrees it, V1 (idea → outlined) has passed:
set `status: outlined` and record `V1` with today's date in `verified`. _Mechanical (writing); the
read-back is substantive._

## 9. Record what was decided

> **Skill:** `grill-with-docs` · **Guide:** `planning/docs/reference/unit-briefs.md`

Decisions that pass the memory gate go to `.claude/MEMORY.md` `Decisions`, dated; new or
sharpened terms go to `standards/style/terminology.md`; questions left open go to
`Open questions`. Everything else stays in the brief. _Substantive._

## 10. Reconcile with the content layer

> **Skill:** none · **Guide:** `planning/docs/reference/unit-briefs.md`

For a new unit there is nothing to do: the drafting and promotion skills create the unit's home
in the content layer from this brief. For a re-plan, compare the brief's `sections:` with the
section markers already in the unit's file, and report every marker the new plan adds, renames,
reorders or drops. The author settles them in the content layer; this procedure changes nothing
there. _Mechanical._

## 11. Hand on

> **Skill:** none · **Guide:** `planning/docs/reference/unit-briefs.md`

Tell the author what is planned and what is still flagged. If `planning/workflows/CLAUDE.md`
lists a companion planning procedure for this doc type, name it as the next step; then offer to
draft the first section with the content layer's `01-draft-a-section`, which `run-workflow`
will route to. Planning that never reaches a drafted section has not done its job.
_Substantive._
