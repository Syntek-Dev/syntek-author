# FICTION.md — promote-section, fiction mode

The domain for promoting a beat of a novel into its chapter: where the chapter file and its
markers live, and which story-bible records a promotion brings up to date.

## Paths and unit

- **Unit:** a chapter. **Procedure:** `manuscript/workflows/04-promote-a-section/`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`.
- **Unit file:** `manuscript/src/NN-kebab-title/NN-kebab-title.md`, holding an H1 with the brief's
  title and one `<!-- section: <slug> -->` marker per planned section, in plan order, each on its
  own line with a blank line between. No frontmatter: the chapter's metadata lives in its brief.
- **Records a promotion touches (step 7):** `planning/src/continuity.md`,
  `world/src/names-register.md`, and the `first_appears` key of each file in
  `world/src/characters/` and `world/src/places/`; with the kits, the same key in the peoples,
  cultures, creatures and history files, and `first_used` in each language's lexicon.
- **Review procedure (step 9):** `manuscript/workflows/05-review-a-chapter/`.
- **Guides:** `manuscript/docs/reference/section-anatomy.md`,
  `manuscript/docs/reference/the-status-ladders.md` and `world/docs/reference/story-bible.md`.

## Additions to the steps

- **Step 3 — also create the chapter file when it is missing:** the H1, then the markers in the
  brief's order, and nothing else. `promote-section` is the only skill that creates it.
- **Step 4 — also keep the spans whole.** A constructed word in its `{.conlang …}` span, a
  scene-break line and an epigraph block are prose, carried exactly. The internal note stays in
  the draft.
- **Step 6 — also record the chapter text.** `## Author final` holds the text exactly as inserted
  into the chapter.
- **Step 7 — also propose the facts the beat establishes.** Once promoted, the beat's prose is
  canon. List each fact it newly establishes (an age, a scar, a distance, a family tie) and add it
  under `## Proposed` in `planning/src/continuity.md`, proposed from `<unit-slug> · <section-slug>`.
  It moves to `## Established facts`, with the next free ID, only when the author confirms it.
- **Step 7 — also record first appearances.** For every registered name this beat uses for the
  first time in promoted prose, set `First appears` in `world/src/names-register.md` and
  `first_appears` in its character or place file to `<unit-slug>/<section-slug>`. A name used
  that is not in the register stops the run: register it through `create-name` first. Where the
  worldbuilding or language kit is installed, also set `first_used` on each lexicon headword the
  beat uses for the first time in promoted prose, and `first_appears` on any people, culture,
  creature or history-event file whose registered name first appears here, to the same value.
- **Step 8 — also read for continuity seams.** Read the beat with its neighbours for a jump in
  time, place or knowledge, and report it for `continuity` and `causality` at review.

## Domain rules

- **Promoted prose is canon.** A fact changed after promotion changes the book, so it is
  superseded in `planning/src/continuity.md`, never edited, and the affected sections are listed
  for the author (`world/docs/reference/story-bible.md`).
- **New facts are proposed, not added** (`.claude/rules/syntek-author/03-authorship.md` Section 7):
  only the author moves a proposed fact into the established table.
- **Promotion never moves the chapter's status**; continuity, causality, character voice and
  pacing are judged at review (`standards/verification/verification.md` and its mode file).

## Examples

An invented proposed-facts row, as added at promotion:

```markdown
| Fact | Kind | Proposed from | Notes |
|---|---|---|---|
| Ilsa's left palm is scarred from the mill wheel. | character | 04-the-mill · the-ledger | first mentioned here |
```

An invented first appearance, as set in a character file's frontmatter:

```yaml
first_appears: 04-the-mill/the-ledger
```
