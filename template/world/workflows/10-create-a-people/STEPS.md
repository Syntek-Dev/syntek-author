---
workflow: 10-create-a-people
phase: produce
skills: [grill-with-docs, create-name]
model: opus
---

# STEPS.md — create a people

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for describing a people, body first. Each step names the skill and guide
it uses. **Run in order** (the body before the lifespan, the lifespan before the past, the
depiction check before anything is built on them) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `grill-with-docs` skill settles each section with the author and records it as it resolves;
> `create-name` names the people.

## 1. Fix the people's job in the story

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/peoples.md`

Ask the author which scenes and characters this people shapes, and what the story needs from
them: a home, a neighbour, a rival, a mystery, a threat. Ask whether the story casts them as
hostile. Depth follows the job. _Substantive._

## 2. Read the world they belong to

> **Skill:** none · **Guide:** `world/docs/reference/peoples.md`

Read `world/src/names-register.md`, the other files in `world/src/peoples/`, the cultures in
`world/src/cultures/`, `world/src/history/eras.md` and the events it lists, the places they
might live in, and `planning/src/continuity.md`. List what is already fixed about them.
_Substantive._

## 3. Name the people, or agree a working name

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Offer three to five names with reasoning, checked for clashes and false friends; the author
chooses. If the name must wait for a language not yet built, agree a working name and slug and
flag `<!-- AUTHOR TO CONFIRM: … -->` in the file. _Substantive._

## 4. Create the file

> **Skill:** none · **Guide:** `world/docs/reference/peoples.md`

Check that `world/src/peoples/<slug>.md` does not exist; if it does, stop and ask. Create it
from the skeleton in `world/src/peoples/CLAUDE.md`, one sentence per line, with
`first_appears` left empty and every section empty. _Mechanical._

## 5. Settle what they are, and their body and speech

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/peoples.md`

Human or not, and what sets them apart. Then the physiology that bears on speech and hearing:
mouth, teeth, lips, breath, voice and ears, and any sound they cannot make or hear. Where
nothing differs from a human reader, write 'human, no constraint'. Record each answer as it
resolves. _Substantive._

## 6. Settle lifespan, generations, numbers and spread

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/peoples.md`

How long they live, how long a generation is, how many there are, and how thinly or densely
they live. Note what the lifespan means for how fast their speech and customs change.
_Substantive._

## 7. Settle homelands and movements

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/peoples.md`

Where they live now (place slugs in `homelands`, oldest first) and where they came from. Each
migration, conquest or contact the file relies on is named by its event slug if it has a file
in `world/src/history/`, or listed for the hand-back if it has not; never narrated here.
_Substantive._

## 8. Settle relations to other peoples

> **Skill:** `grill-with-docs` · **Guide:** `world/docs/reference/peoples.md`

Alliance, trade, rivalry, conquest, intermarriage, with each people the story depicts. A
relation that changed either side is an event to chart, listed for the hand-back. _Substantive._

## 9. Run the depiction check

> **Skill:** none · **Guide:** `world/docs/reference/peoples.md`

Record what, if anything, the people borrows from real peoples, and check it against
`standards/risk/FICTION.md`. Where the story casts them as hostile or 'evil', check that no real
ethnic group is recognisable in their looks, customs, names or speech, and offer ancient,
extinct or blended sources instead. Report every concern to the author with an alternative;
the outcome goes in the note under the frontmatter. _Substantive._

## 10. Register the name

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Add the people's name to `world/src/names-register.md` with kind `people`, or leave it
unregistered and flagged while it is a working name. _Mechanical._

## 11. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/peoples.md`

Report the file written, the name, the depiction outcome, the events to chart with
`world/workflows/11-chart-the-world-history/`, the cultures to describe with
`world/workflows/05-create-a-culture/`, anything that now contradicts an existing file, and the
open flags. _Substantive._
