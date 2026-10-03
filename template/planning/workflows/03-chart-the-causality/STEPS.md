---
workflow: 03-chart-the-causality
phase: plan
skills: [causality]
model: opus
---

# STEPS.md — chart the causality of a unit

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for charting why each beat of one chapter happens, before it is drafted.
Each step names the skill and guide it uses. **Run in order** — the ordering is load-bearing —
and tick `CHECKLIST.md` as you go.

> Read `standards/method/FICTION.md` first: it owns the story engine this chain records. The
> `causality` skill is this procedure's check in skill form.

## 1. Read the brief and the chain so far

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

Read the chapter's brief, then `planning/src/causality.md`, `planning/src/timeline.md` and
`planning/src/continuity.md` as they stand, and the open setups. Note the last beat ID in use.
_Substantive._

## 2. List the unit's beats

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

With the author, list each beat the chapter carries, one sentence each, against the section
that will carry it. A section with no beat has no job; a section with four beats is probably
two sections. _Substantive._

## 3. Give every beat its cause

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

For each beat, write `Because`: an earlier beat ID, a named character's decision, or a rule of
the world with its entry in `world/src/`. Ask the author for any cause you cannot find; never
invent one to fill the cell. _Substantive._

## 4. Give every beat its consequence

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

For each beat, write `Therefore`: what it makes necessary or possible next. A beat with no
consequence is either a setup (step 6) or a candidate for cutting; the author decides.
_Substantive._

## 5. Flag coincidence and 'and then'

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

Flag every beat caused only by the beat before it in time, and every beat where chance resolves
a problem. Report each to the author. A coincidence the author keeps is recorded in
`.claude/MEMORY.md` with its reason. _Substantive._

## 6. Pair setups with payoffs

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

For each beat that plants something, name its payoff beat or add it to `## Open setups`. For
each payoff, confirm its setup exists earlier in the chain. _Substantive._

## 7. Place the beats in story time

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

Add each beat's event to `planning/src/timeline.md` in story-time order, with `Told in` set to
its section or `planned`. Where the telling runs out of time order, check that the reader can
follow it. _Mechanical (rows); the order check is substantive._

## 8. Propose the facts the beats establish

> **Skill:** `causality` · **Guide:** `planning/docs/reference/causality-chains.md`

List each fact a beat will establish under `## Proposed` in `planning/src/continuity.md`, and in
the brief's `## Continuity facts`. Facts move to `## Established facts` only when their section
is promoted or the author decides them. _Substantive._

## 9. Write the rows and hand back

> **Skill:** none · **Guide:** `planning/docs/reference/causality-chains.md`

Write the agreed rows, new IDs in sequence, one sentence per cell; update each file's
`Last Updated` line. Report the flags left open and name the next step: the content layer's
`01-draft-a-section`, or `04-chart-a-character-arc` where a beat turns a character.
_Mechanical (writing); the hand-back is substantive._
