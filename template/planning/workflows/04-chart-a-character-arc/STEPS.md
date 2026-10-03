---
workflow: 04-chart-a-character-arc
phase: plan
skills: [chart-character-arc, causality]
model: opus
---

# STEPS.md — chart a character's arc

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for planning how one character changes, mapped to the sections that carry
each shift. Each step names the skill and guide it uses. **Run in order** — the ordering is
load-bearing — and tick `CHECKLIST.md` as you go.

> Read `standards/method/FICTION.md` first. The `chart-character-arc` skill is this procedure in
> skill form.

## 1. Read the character and the story so far

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Read the character's entry in `world/src/characters/` (want, need, wound and the lie, voice
markers, relationships), the outline, and the causality chain. If an arc already exists, read it
and confirm a re-chart with the author. _Substantive._

## 2. Choose the arc type with the author

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Positive, negative or flat. Offer the author the options the entry supports, with what each
would cost the story, and let them choose. _Substantive._

## 3. Name the truth and the gap

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

State the truth the character reaches, refuses, or holds and is tested by. Describe the gap
between want and need, as the entry records them, that the arc closes or widens. If the entry's
want, need or lie must change to make the arc work, stop and change the entry with the author
first. _Substantive._

## 4. Find the turn

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Identify the beat where the lie can no longer be held, and say why it breaks there and not
earlier. A turn that could move to any chapter has no cause yet. _Substantive._

## 5. Map the shifts to sections

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

List every beat where the character's belief or behaviour shifts, in order, each against its
chapter and section, with one sentence on what shifts. Leave no long stretch of the book in
which the character neither moves nor is tested. _Substantive._

## 6. Tie every shift to a cause

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

For each shift, name the causality beat that forces it. Where none exists, chart it with
`03-chart-the-causality` before going on. _Substantive._

## 7. Write the arc and link the entry

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Write `planning/src/arcs/<slug>.md` in the guide's shape, one sentence per line, with anything
undecided under `## Open` as `AUTHOR TO CONFIRM`. Set the entry's `arc:` to the arc's path.
_Mechanical (writing); the open items are substantive._

## 8. Hand back

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Report the arc's type, turn and open items. Decisions the author makes go to
`.claude/MEMORY.md` through `grill-with-docs`. Name the briefs whose `## Sections` should now
mention the shifts they carry. _Substantive._
