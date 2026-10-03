# FICTION.md — prototype, fiction mode

The two branches for a novel, SCENE and VOICE, and what each relaxes.

## Paths and unit

- **Where a spike lives:** `manuscript/src/NN-kebab-title/drafts/SPIKE-<slug>.md`, beside the
  chapter's section drafts.
- **Reads (step 1):** the brief's `## Continuity facts`, `planning/src/causality.md`, the point-of-
  view character's file in `world/src/characters/` and their arc in `planning/src/arcs/`.
- **The unit's guide:** `manuscript/docs/reference/scene-craft.md`.

## Additions to the steps

- **Step 2 — also name the branch: SCENE or VOICE.** SCENE asks 'does this scene work: does its
  turn hold, does its cause carry it?'; VOICE asks 'how should this sound?'
- **Step 4 — also, SCENE:** draft the scene at rough length with its goal, conflict and outcome
  visible. The hardest beat is usually the turn (the reversal, the reveal, the choice); write it
  first, and check that it happens *because* of what came before, not merely after it.
- **Step 4 — also, VOICE:** vary what genuinely differs: point-of-view distance, tense, the
  narrator's register, one character's dialogue voice, or how much invented language reaches the
  page.
- **Step 4 — also, what relaxes:** polish, scene transitions, the continuity check, and names:
  an unnamed person or place is a placeholder such as `[FERRYMAN]`, never a name coined on the
  spot. **What does not relax:** a spike never registers a name, never adds a word to a lexicon,
  and never becomes a fact in the story bible.
- **Step 5 — also** record a SCENE verdict in the brief (`## Continuity facts` or
  `## Draft notes`) and, if the turn changed, in `planning/src/causality.md`; a VOICE verdict for
  a character goes to their voice markers in their file, and one for the narration to
  `.claude/MEMORY.md` `Decisions` through the gate.

## Domain rules

- **A spike may break continuity on purpose**, to test an alternative; it says so at the top, and
  nothing it invents leaks into the story bible.
- **A scene spike that only works by coincidence has answered its question:** the cause is
  missing (`standards/method/FICTION.md` Section 7).

## Examples

```markdown
# SPIKE — does the crossing turn on the oar-lock?

Question: does the turn in 'crossing-at-night' hold if the oar-lock fails, rather than the weather?
Branch: SCENE.

## The turn (written first)
…
## Verdict
It holds, and it pays off the set-up in section 2; recorded in causality.md and the brief's
draft notes, 03/10/2026. Spike deleted.
```
