# FICTION.md — the story engine

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The method particular to a work of fiction, read with `method.md` (which still governs every
real-world fact the story uses). `causality` enforces rules 1 and 7; `chart-character-arc` and
`character-voice` enforce rule 2; `pacing` and `structure-review` enforce rules 3 and 4;
`continuity` enforces rules 5 and 6; `draft-section` writes to all of them and reads the story
bible first. The people and places in the examples are invented.

Dates DD/MM/YYYY; story-internal dates as recorded in `planning/src/timeline.md`.

---

## 1. Causality: 'because' and 'therefore', never 'and then'

**Requirement.** Every beat follows from an earlier beat by 'because' or 'therefore'. The chain
lives in `planning/src/causality.md`, and every beat there cites its cause.

> **Wrong:** Mara reaches the ford, and then a storm comes, and then she meets the ferryman.
>
> **Right:** Mara reaches the ford at night *because* the toll-keeper turned her back at dusk;
> *therefore* she must cross unseen, *but* the river is high, *so* she bargains with the
> ferryman she was warned against.

**Why this rule exists.** A sequence of events is a chronicle; a chain of causes is a plot.
Readers feel the difference before they can name it.

---

## 2. Want against need

**Requirement.** Every point-of-view character has a conscious **want** and an unconscious
**need** that pull against each other, a **wound** and the **lie** it taught them, recorded in
`world/src/characters/<slug>.md` and charted in `planning/src/arcs/<slug>.md`. The arc is the
movement from the lie towards the truth, or the refusal of it.

**Why this rule exists.** A character who only wants something is a vehicle for the plot; the
gap between want and need is what makes the reader care whether they get it.

---

## 3. Scene goal, conflict, outcome

**Requirement.** Every scene has a point-of-view character with a **goal** in the scene, an
**opposition** to it, and an **outcome** that changes the situation, usually 'no' or 'yes, but'.
A scene whose outcome changes nothing is cut or merged.

**Why this rule exists.** A scene that changes nothing asks the reader for time and gives
nothing back; enough of them and the reader stops turning pages.

---

## 4. Setup and payoff

**Requirement.** Everything planted pays off or is cut; every payoff was planted. Open set-ups
are tracked under `## Open setups` in `planning/src/causality.md` until their payoff is charted,
so none is forgotten across units drafted months apart.

**Why this rule exists.** An unplanted payoff reads as a cheat, and an unpaid set-up as a
broken promise; both are easy to miss when units are drafted out of order.

---

## 5. Point-of-view discipline

**Requirement.** Each scene has one point-of-view character, unless a change is declared. The
narration knows only what that character can know, perceives only what they can perceive, and
names things as they would. Tense is consistent within the work unless a change is deliberate
and recorded in `standards/style/style-sheet.md`.

**Why this rule exists.** A slip in point of view is a slip in trust: the reader stops being
inside a person and starts noticing an author.

---

## 6. The story bible is the source of truth

**Requirement.** `world/src/` (characters, places, the names register and any invented
language), `planning/src/timeline.md` and `planning/src/continuity.md` are the source of truth.
Prose that contradicts them is **reported, never silently repaired**: the author decides whether
the prose or the bible changes. A new fact established in prose is proposed for the bible with
the section that established it.

> **Right:** 'Section crossing-at-night gives the ferryman one eye; the character file gives
> him two. Which stands?'

**Why this rule exists.** A silent repair may undo the author's deliberate change of mind, and
a contradiction found in proof costs far more than one found in draft.

---

## 7. Coincidence may make trouble, never resolve it

**Requirement.** Chance may put a character into difficulty; it may never get them out. Every
resolution is earned by a choice, a cost or a set-up already paid for.

**Why this rule exists.** Readers forgive bad luck and resent good luck: a rescue by coincidence
tells them the author, not the character, solved the problem.
