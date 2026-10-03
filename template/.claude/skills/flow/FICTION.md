# FICTION.md — flow in a novel

In a novel, flow is the joins between beats, the rhythm of the narration and the dialogue, and one
narrator across scenes drafted out of order. It is not pacing: how long a scene runs and where the
tension rises are the `pacing` skill's, and this pass hands them on. It also watches the density of
invented words on the page.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, its beats between
  `<!-- section: <slug> -->` markers.
- **The pass** is step 8 of `manuscript/workflows/05-review-a-chapter/`.
- **Extra reads:** the voice markers of each point-of-view character in `world/src/characters/`;
  `manuscript/docs/reference/scene-craft.md`; how the style sheet marks a scene break.

## Additions to the steps

- **Step 2 — also:** a seam inside a scene must not reset the moment (a character reacting twice to
  the same blow, a door opened twice); a scene break is marked as the style sheet says, and the
  time that has passed across it is signalled.
- **Step 4 — also, dialogue:** long speeches with no beat; runs of tags; tags other than 'said'
  that draw attention to themselves; the same filler beats again and again (turned, nodded,
  looked, sighed).
- **Step 4 — also:** scene length, the alternation of scene and sequel, and tension across the
  chapter are pacing. Name the place, hand it to `pacing`, and do not judge it here.
- **Step 5 — also:** a tic recorded in a character's voice markers repeats on purpose; the
  narration's own tics do not.
- **Step 6 — also:** narrative distance, tense and point of view are held within each scene. A
  character's dialogue drifting from their voice markers is handed to `character-voice`.
- **Step 6 — also, the density of invented words:** where the conlang kit is installed, run its
  density check on the chapter file (the density subcommand of tooling/lexicon.py), which lists
  every paragraph holding more than three invented words that their context does not gloss. Read
  each listed paragraph, count only the words the reader is truly left to guess, and report the
  paragraph with those words. Without the kit, apply the same test by eye to invented names and
  terms. Restraint on the page is part of the constructed-language method.

## Domain rules

- **Pacing is `pacing`'s.** This pass never recommends lengthening, shortening or reordering scenes
  for tension; it names the place and hands it on.
- **More than three unglossed invented words in a paragraph is a finding.** The fix (a gloss in
  context, fewer words, an English word) is the author's.
- **Never suggest glossing by dialogue that tells both speakers what they already know.**
- **The voice markers win** over any general rule about dialogue rhythm.

## Examples

> **Blocking.** Seam between `opening` and `the-turn`: Maren sees the lantern go out at the end of
> `opening` and again at the start of `the-turn`. Suggestion: keep one.

> **Density.** `the-turn`, paragraph 4: five invented words, two glossed by the sentence around
> them; three left for the reader. Reported with the three words listed.

> **Handed on.** `the-turn` paragraphs 6 to 12: three sequel beats in a row after a small
> outcome. For `pacing`.
