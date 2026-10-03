---
type: guide
skills: [draft-section, causality, continuity, character-voice, pacing]
model: opus
---

# Scene craft — making each beat of the story work on the page

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** In a novel, a section is one beat of a scene, or a whole scene when the scene is
short. Each beat has to earn its place: something is wanted, something stands in the way, and
something changes. This guide is the craft for drafting and judging one beat at a time without
losing the scene, the chapter or the story bible.

## Goal, conflict, outcome

- **Goal.** The point-of-view character wants something concrete in this beat, even if small.
- **Conflict.** Something resists: a person, the world, the character's own lie.
- **Outcome.** The beat ends changed: usually worse, sometimes better at a cost, never the same.
- **Sequel.** After a hard outcome, a quieter beat lets the character react, face the dilemma
  and decide; that decision sets the next goal. Scenes and sequels alternate.

A beat whose outcome leaves everything as it was is a candidate for cutting or merging.

## Point of view and orientation

- **One point of view per scene.** Name it in the brief; never slip into another head mid-scene.
- **Orient early.** Within the first lines of a scene, the reader knows who, where and when.
- **Filter through the character.** The narration notices what this character would notice, in
  words this character would use (their voice markers live in `world/src/characters/`).

## Cause and effect

- **Because and therefore, never 'and then'.** Every beat follows from an earlier cause, recorded
  in `planning/src/causality.md`. Coincidence may start trouble, never resolve it.
- **Set up, then pay off.** A detail planted early is paid off later or cut; a payoff with no
  set-up is a cheat. Note both in the brief's continuity facts.

## The story bible is the truth

Names, places, dates and established facts come from `world/src/`, `world/src/names-register.md`,
`planning/src/continuity.md` and `planning/src/timeline.md`. When the prose and the bible
disagree, report the contradiction to the author; never repair it silently in either direction.

## How we apply it here

- Read the brief's scene goal, the character files and the continuity ledger before drafting a
  beat, not after.
- Mark a scene break inside a chapter as `standards/style/style-sheet.md` says.
- A new fact the prose establishes is proposed for `planning/src/continuity.md` with its section
  reference; the author confirms it before it becomes canon.

## Who implements it

- **Skills:** `draft-section` drafts to this shape; `causality` checks every beat cites its cause;
  `continuity` checks the prose against the bible; `character-voice` checks dialogue and narration
  against each character's voice markers; `pacing` reports on scene length and alternation.
- **Workflows:** `manuscript/workflows/01-draft-a-section/`,
  `manuscript/workflows/05-review-a-chapter/`.

## Governing standard

`standards/method/FICTION.md` owns the story engine: causality, want against need, scene goal,
conflict and outcome, setup and payoff, point-of-view discipline and the bible as the source of
truth. The standard owns the rules; this guide owns drafting one beat to them.
