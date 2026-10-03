---
workflow: 02-map-the-argument
phase: plan
skills: [argument-audit, category-check]
model: opus
---

# STEPS.md — map a chapter's argument before drafting

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for laying out and auditing one chapter's argument before a word of it is
drafted. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read `standards/method/THEOLOGY.md` first: it owns the six categories, concede-before-rebut
> and the steelman tests this procedure applies. The `argument-audit` skill is steps 7 and 8 in
> skill form.

## 1. Read the brief and the standing commitments

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

Read the chapter's brief in `planning/src/units/`, then `.claude/MEMORY.md` for decisions that
bind this chapter, including any objection the book has designated as left standing. If a map
already exists, read it and confirm a re-audit with the author. _Substantive._

## 2. State the thesis in one sentence

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

Agree with the author the one sentence the chapter lands. If it needs two, the chapter is
arguing two things; raise it, and let the author decide whether to split. _Substantive._

## 3. List the claims and split the compound ones

> **Skill:** `category-check` · **Guide:** `planning/docs/reference/argument-maps.md`

Write every claim the thesis needs as one sentence with an ID (`C1` …), in the order the
chapter will make them. A sentence that makes two claims becomes two claims. _Substantive._

## 4. Give each claim its category

> **Skill:** `category-check` · **Guide:** `planning/docs/reference/argument-maps.md`

Label each claim with exactly one of the six categories. Flag any silent collapse: inference
written as text, conclusion written as history, application written as exegesis. A move from
reading one passage to a conclusion across Scripture is marked as such, never slipped in.
_Substantive._

## 5. Wire the support, and flag what is unchecked

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

Under each claim, name what supports it: other claims, a passage, an evidence entry in
`research/src/evidence/`, a source note in `research/src/sources/`. Every reference, quotation
and attribution not yet checked against its source carries `<!-- VERIFY: … -->`; never supply
one from memory to fill a gap. _Substantive._

## 6. Name the contested readings

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

List each passage the chapter leans on that serious Christians read in more than one way, with
an ID (`R1` …). Link each to its entry in `research/src/contested-readings/`; where none exists,
stop and run `research/workflows/03-map-a-contested-reading/` before the dependent claims are
treated as supported. _Substantive._

## 7. State the objections and place the concessions

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

List each objection (`O1` …) as its holders would state it, with who holds it and where the
chapter answers it, or that it is left standing. For each cost the chapter concedes (`K1` …),
name the section that states it and confirm it sits before the section that answers it.
_Substantive._

## 8. Audit for open moves

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

Walk the map from the thesis down. List under `## Open moves` every claim with no support, every
premise the argument needs but never states, and every conclusion stated beyond its evidence.
Report them to the author; do not repair the argument yourself. _Substantive._

## 9. Write the map and update the brief

> **Skill:** none · **Guide:** `planning/docs/reference/argument-maps.md`

Write `planning/src/arguments/<unit>.md` in the guide's shape, one sentence per line. Carry the
claims the author has agreed, with their IDs and categories, into the brief's
`## Claims and categories`, and any keys now held into `sources:`. _Mechanical._

## 10. Hand back

> **Skill:** `argument-audit` · **Guide:** `planning/docs/reference/argument-maps.md`

Report the open moves, blocking first, and the flags left. Decisions the author makes go to
`.claude/MEMORY.md` through `grill-with-docs`. Name the next step: the content layer's
`01-draft-a-section` once the blocking moves are closed. _Substantive._
