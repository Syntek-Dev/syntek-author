---
workflow: 01-create-a-character
phase: produce
skills: [create-name, chart-character-arc]
model: opus
---

# STEPS.md — create a character

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a character from the author's idea to a file the book can rely
on. Each step names the skill and guide it uses. **Run in order** (the ordering is
load-bearing) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `chart-character-arc` and `create-name` skills carry the judgement of steps 3, 4 and 9.

## 1. Fix the character's job in the story

> **Skill:** none (the author's brief) · **Guide:** `world/docs/reference/story-bible.md`

Ask the author what the story needs from this person: their role (protagonist, antagonist,
supporting, minor), the chapters they appear in, and the gap they fill that no existing
character can. If the answer is a single scene and no change, stop and route to
`world/workflows/03-name-something/`. _Substantive._

## 2. Read the story bible before inventing anything

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Read `world/src/names-register.md`, every file in `world/src/characters/`, the places the
character belongs to, `planning/src/continuity.md` and `planning/src/timeline.md`, and the
premise in the project brief (`00-project.md` `## Paths`, 'Project brief'). List the
constraints the new character must respect and the existing characters they would echo.
_Substantive._

## 3. Draft the want, the need, the wound and the lie

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Offer two or three options for each: the want (what they consciously pursue), the need (what
they actually lack), the wound (the past event) and the lie (the false belief the wound taught
them). The want and the need must pull against each other. The author chooses. _Substantive._

## 4. Name the character

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Three to five options, each with its reasoning (culture, sound, meaning), checked against the
register for look-alike and sound-alike clashes. Give IPA and a reader respelling for each. The
author chooses; record nothing until they do. _Substantive._

## 5. Set the voice markers

> **Skill:** none (drafted with the author) · **Guide:** `world/docs/reference/story-bible.md`

Three to six markers: diction, sentence length, habits of address, what they never say. Each
is concrete enough to test, and each carries one short invented example line, marked as an
example. `character-voice` will check dialogue against these. _Substantive._

## 6. Record relationships and continuity facts

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

The people the character is bound to, each linked to their file or register row, and only the
fixed details the book will use (age, appearance points, home, family). Flag anything undecided
as `<!-- AUTHOR TO CONFIRM: … -->`. _Substantive._

## 7. Confirm you will not clobber a file, then write it

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Check that `world/src/characters/<slug>.md` does not exist; if it does, stop and ask. Write the
file from the skeleton in `world/src/characters/CLAUDE.md`, one sentence per line, with
`first_appears` left empty. _Mechanical._

## 8. Register the name

> **Skill:** `create-name` · **Guide:** `world/docs/reference/naming.md`

Add the row to `world/src/names-register.md`: kind `character`, IPA, respelling, language,
meaning, notes; First appears stays empty until promoted prose uses the name. _Mechanical._

## 9. Open the arc file

> **Skill:** `chart-character-arc` · **Guide:** `planning/docs/reference/character-arcs.md`

Write `planning/src/arcs/<slug>.md` with the arc type (positive, negative or flat), the want,
the need and the lie, and link it from the character file's `arc` field. Mapping the beats to
chapters is `planning/workflows/04-chart-a-character-arc/`; say so in the hand-back.
_Substantive._

## 10. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/story-bible.md`

Report the files written, the open `AUTHOR TO CONFIRM` flags, any echo of an existing character
the author should weigh, and any contradiction found, with both locations. _Substantive._
