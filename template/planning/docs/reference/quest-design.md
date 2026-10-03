---
type: guide
skills: [design-quest, causality, chart-character-arc]
model: opus
---

# Quest design — a quest that cannot be left dangling

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A quest is a sustained pursuit with a goal, a price and an ending: the journey
to the mountain, the search for the lost heir, the bargain that must be kept by midsummer. Each
one is planned in `planning/src/quests/<slug>.md` before its first beat is drafted, tied to the
arcs it moves and the causality beats it rests on, so that no quest wanders off the page
unfinished and no reward arrives without a cost.

## The parts of a quest

| Part | The question it answers |
|---|---|
| Goal | What, concretely, is being sought? |
| Stakes | What is lost if it fails, and to whom? |
| Trigger | Which beat sets it going, and why now? |
| Obstacles | What stands in the way, in the order met? |
| Reversals | Where does the quest turn against the seeker? |
| Cost | What does success, or failure, take from them? |
| Reward | What do they gain, and is it what they wanted? |

## Ties to the rest of the plan

- **Arcs.** Name each character whose arc the quest moves, and the arc beat it carries. A quest
  that changes nobody is travel.
- **Causality.** The trigger and every reversal cite a beat in `planning/src/causality.md`.
- **The world.** Every creature, culture, place or rule the quest relies on is checked against
  its entry in `world/src/`. A rule bent for the quest's convenience is a continuity fault.

## The shape of a quest file

```text
---
title: <quest name>
slug: <slug>
kind: main                  # main | side
status: open                # open | resolved | left-open
---
# <Quest name> — quest
## Goal · ## Stakes · ## Trigger · ## Obstacles · ## Reversals · ## Cost · ## Reward
## Ties          arcs and arc beats · causality beat IDs · world entries relied on
## Ending        how it resolves, or why it is deliberately left open
```

## How we apply it here

- Design a quest when it is first planned, not when its first scene is drafted.
- A quest still `open` at the last unit must say, under `## Ending`, why it is left open; the
  author confirms the reason. Otherwise it is dangling.
- Side quests obey the same rules; a side quest with no cost or no tie is a candidate for
  cutting, and the author decides.

## Who implements it

- **Workflow:** `planning/workflows/05-design-a-quest/`.
- **Skills:** `design-quest` writes the quest; `causality` checks its causes;
  `chart-character-arc` keeps the arcs it moves in step.

## Governing standard

`standards/method/FICTION.md` owns the story engine. The standard owns the requirement; this
guide owns how a quest is planned and closed.
