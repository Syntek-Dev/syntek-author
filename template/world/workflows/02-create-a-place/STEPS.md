---
workflow: 02-create-a-place
phase: produce
skills: [create-name]
model: opus
---

# STEPS.md — create a place

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a place from the author's idea to a file every scene set there
can rely on. Each step names the skill and guide it uses. **Run in order** (distances are
checked before anything is written) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `create-name` skill carries the judgement of step 4.

## 1. Fix the place's job in the story

> **Skill:** none (the author's brief) · **Guide:** `world/docs/reference/story-bible.md`

Ask the author which scenes happen here and what the place does for them: obstacle, refuge,
threshold, mirror of a character, prize. A place with no job in any scene needs a name at most;
route it to `world/workflows/03-name-something/`. _Substantive._

## 2. Read the story bible

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Read `world/src/names-register.md`, every file in `world/src/places/`, the characters who live
in or travel to the place, `planning/src/timeline.md` and `planning/src/continuity.md`. Note
every journey the story already makes that this place must fit. _Substantive._

## 3. Fix the kind, the scale and the distances

> **Skill:** none (decided with the author) · **Guide:** `world/docs/reference/story-bible.md`

Settle what kind of place it is (settlement, building, room, river, road, region), what it sits
within, and how long it takes to reach each place the story connects it to, by the means of
travel the story uses. Test every travel time against `planning/src/timeline.md`; report any
clash with both locations rather than adjusting either. _Substantive._

## 4. Name the place

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Three to five options, each with its reasoning. Place names are often older than the people who
use them: worn short, descriptive in a language that has moved on, named for a founder or a
feature. Clash-check against the register; give IPA and a respelling. The author chooses.
_Substantive._

## 5. Give it senses and a history

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

What a point-of-view character notices on arrival: light, sound, smell, weather, the season it
is usually seen in. Then only as much history as a scene uses or a character would know.
_Substantive._

## 6. Record who holds it and its rules

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Who lives here, who controls it, what is forbidden or dangerous, and who may enter. Link each
person or people named to their file or register row. Flag anything undecided. _Substantive._

## 7. Check real-world detail, if the place is drawn from a real one

> **Skill:** none here (route to `research/workflows/02-verify-a-claim/`) · **Guide:** `research/docs/reference/real-world-detail.md`

Every detail taken from a real place or period is verified, or flagged `<!-- VERIFY: … -->`
until it is. An invented place that borrows only atmosphere needs no check. _Substantive._

## 8. Confirm you will not clobber a file, then write it

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Check that `world/src/places/<slug>.md` does not exist; if it does, stop and ask. Write the file
from the skeleton in `world/src/places/CLAUDE.md`, one sentence per line, with `first_appears`
left empty. _Mechanical._

## 9. Register the name

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Add the row to `world/src/names-register.md`: kind `place`, IPA, respelling, language, meaning,
notes. _Mechanical._

## 10. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Report the file written, the travel times fixed, any clash with the timeline, the open flags,
and any detail still awaiting verification. _Substantive._
