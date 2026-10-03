---
type: guide
skills: [chart-character-arc, character-voice, causality]
model: opus
---

# Character arcs — how a character changes, beat by beat

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** An arc is the shape of a character's change across the story: what they believe
at the start, what the story costs them, and what they believe at the end. The character's
entry in `world/src/characters/` records who they are; the arc in `planning/src/arcs/<slug>.md`
records how they move, mapped to the units and sections where each shift happens, so the change
is planned rather than hoped for.

## Three arc types

| Type | The movement |
|---|---|
| Positive | The character gives up the lie they believe and reaches the truth, at a cost |
| Negative | The character refuses the truth, or trades it for the lie, and is diminished |
| Flat | The character already holds the truth and is tested by it; the world around them changes |

## Want, need, the wound and the lie

The *want* is what the character pursues; the *need* is what would actually make them whole.
The *wound* is the past harm that taught them the *lie*, the false belief that keeps want and
need apart. These four live in the character's entry and are cited from the arc, never copied
into it. The arc records how the gap between want and need closes, or widens.

## The shape of an arc

```text
---
character: <slug>
arc_type: positive          # positive | negative | flat
world_entry: world/src/characters/<slug>.md
---
# <Name> — arc
## Shape        one paragraph: from what, to what, at what cost
## The truth    the truth reached, refused, or held and tested
## Beats        # · unit · section · what shifts · causality beat ID
## The turn     the beat where the lie can no longer be held, and why
## Open         decisions only the author can make, flagged AUTHOR TO CONFIRM
```

## How we apply it here

- Chart an arc for every character who changes, and for a flat-arc protagonist; a minor
  character needs only their entry.
- Every beat names the causality beat that forces it. A change with no cause in
  `planning/src/causality.md` is a change the reader will not believe.
- The character's entry carries `arc:` pointing at the arc file; keep the two in step.
- Voice markers live in the character's entry; `character-voice` checks the prose against them
  at line edit.

## Who implements it

- **Workflow:** `planning/workflows/04-chart-a-character-arc/`.
- **Skills:** `chart-character-arc` writes the arc; `causality` checks each beat's cause;
  `character-voice` checks that the voice shifts where the arc says it does.

## Governing standard

`standards/method/FICTION.md` owns want against need and the story engine. The standard owns
the requirement; this guide owns how an arc is charted and kept in step with the prose.
