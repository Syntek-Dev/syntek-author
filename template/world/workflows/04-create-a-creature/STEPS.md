---
workflow: 04-create-a-creature
phase: produce
skills: [create-creature]
model: opus
---

# STEPS.md — create a creature

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for taking a creature from the author's idea to a bestiary entry the
story can keep. Each step names the skill and guide it uses. **Run in order** (ecology before
powers, limits before lore) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `create-creature` skill is this procedure in skill form.

## 1. Fix the creature's job in the story

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Ask the author what the creature is for: threat, companion, resource, omen, wonder, obstacle in
a quest. Note the scenes it appears in and the plot moments that depend on it. _Substantive._

## 2. Read the world it must live in

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Read `world/src/names-register.md`, every file in `world/src/creatures/`, the places it lives
in, the cultures that know it, `planning/src/continuity.md`, and any quest in
`planning/src/quests/` that involves it. List the established rules it must respect.
_Substantive._

## 3. Settle its ecology

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Habitat, diet, what hunts it, how it breeds and how long it lives, how many there are. Offer
options where the author has not decided; check each against the places it would live in.
_Substantive._

## 4. Settle its anatomy and behaviour

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

A body that fits its ecology: size, senses, how it moves. Then behaviour when hungry,
threatened, mating, wounded and alone. Strangeness is welcome; each strange feature has a
reason in how it lives. _Substantive._

## 5. Fix its rules, limits and weaknesses

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Write each ability with its cost, and each limit as a hard rule. For every weakness the plot
will use, find its set-up in `planning/src/causality.md`; where none exists, note it for the
hand-back. _Substantive._

## 6. Record its lore and names

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

What each people believes about it, attributed to that people and marked where it is wrong; and
the name each people uses, offered as options with IPA and a respelling and clash-checked
against the register. The author chooses each name. _Substantive._

## 7. Check it against the world

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Compare the finished draft with every rule listed in step 2. Report any contradiction with both
locations; do not adjust either side. _Substantive._

## 8. Confirm you will not clobber a file, then write it

> **Skill:** none · **Guide:** `world/docs/reference/creatures.md`

Check that `world/src/creatures/<slug>.md` does not exist; if it does, stop and ask. Write the
entry from the skeleton in `world/src/creatures/CLAUDE.md`, one sentence per line, with
`first_appears` left empty. _Mechanical._

## 9. Register the names

> **Skill:** `create-creature` · **Guide:** `world/docs/reference/creatures.md`

Add one row per name to `world/src/names-register.md`: kind `creature`, IPA, respelling,
language, meaning, notes. _Mechanical._

## 10. Hand back

> **Skill:** none · **Guide:** `world/docs/reference/creatures.md`

Report the entry written, the names registered, every weakness lacking a set-up, any quest that
should link to the creature, the contradictions found and the open flags. _Substantive._
