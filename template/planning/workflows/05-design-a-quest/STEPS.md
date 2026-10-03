---
workflow: 05-design-a-quest
phase: plan
skills: [design-quest, causality, chart-character-arc]
model: opus
---

# STEPS.md — design a quest, from trigger to ending

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for planning one quest before its first beat is drafted. Each step names
the skill and guide it uses. **Run in order** — the ordering is load-bearing — and tick
`CHECKLIST.md` as you go.

> Read `standards/method/FICTION.md` first. The `design-quest` skill is this procedure in skill
> form.

## 1. Read what the quest will touch

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

Read the outline, the causality chain, the arcs of the characters involved, and the entries in
`world/src/` for every creature, culture and place the quest will meet. If a quest file already
exists, read it and confirm a redesign with the author. _Substantive._

## 2. Fix the goal and the stakes

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

Agree with the author what, concretely, is sought, and what is lost, and by whom, if the quest
fails. A goal that cannot be pictured, or stakes nobody would mourn, are raised before anything
else is planned. _Substantive._

## 3. Find the trigger

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

Name the beat that sets the quest going and why it happens now. Where no such beat exists,
chart it with `03-chart-the-causality`. _Substantive._

## 4. Lay out the obstacles and reversals

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

List the obstacles in the order they are met, and the reversals where the quest turns against
the seeker, each against the chapter that carries it and the beat that causes it. _Substantive._

## 5. Check the world's rules

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

For each obstacle or aid drawn from the world, confirm it behaves as its entry in `world/src/`
says. Report any conflict to the author; the entry or the quest changes, by their decision.
_Substantive._

## 6. Set the cost and the reward

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

State what success, or failure, takes from the seeker, and what it gives, and whether that is
what they wanted. Flag an empty cost. _Substantive._

## 7. Tie it to the arcs

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Name each character whose arc the quest moves and the arc beat it carries; add any missing beat
to the arc with the author. A quest that changes nobody is flagged. _Substantive._

## 8. Plan the ending

> **Skill:** `design-quest` · **Guide:** `planning/docs/reference/quest-design.md`

Offer the author ways the quest can resolve. Record their choice under `## Ending`, with
`status: resolved` once it is drafted, or `left-open` with the reason they give. _Substantive._

## 9. Write the quest and hand back

> **Skill:** none · **Guide:** `planning/docs/reference/quest-design.md`

Write `planning/src/quests/<slug>.md` in the guide's shape, one sentence per line, with
undecided points flagged `AUTHOR TO CONFIRM`. Report the open items and the beats or arcs still
to chart. _Mechanical (writing); the hand-back is substantive._
