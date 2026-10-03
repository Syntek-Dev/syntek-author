# FICTION.md — draft-section, fiction mode

The domain for drafting a section of a novel: where it lives, the story bible it is written
against, and the craft every beat must carry.

## Paths and unit

- **Unit:** a chapter. **Section:** one scene beat, typically 300–500 words.
- **Procedure:** `manuscript/workflows/01-draft-a-section/`.
- **Brief:** `planning/src/units/NN-kebab-title.md`, whose settled-positions section is
  `## Continuity facts`.
- **Draft:** `manuscript/src/NN-kebab-title/drafts/<NN>-<section-slug>.md`. The unit slug in the
  draft and in the ledger is the chapter folder's name, number included (`03-kebab-title`).
- **A new chapter folder (step 5)** gets its `CONTEXT.md` and `CLAUDE.md` as
  `manuscript/src/CLAUDE.md` describes, and `drafts/README.md` in the four-line pattern every
  chapter uses. The chapter file itself is left to `promote-section`.
- **The story bible:** `world/src/characters/`, `world/src/places/`,
  `world/src/names-register.md` and the rest of `world/src/`. **The plot record:**
  `planning/src/causality.md`, `planning/src/timeline.md`, `planning/src/continuity.md` and
  `planning/src/arcs/`.
- **Guides:** `manuscript/docs/reference/section-anatomy.md`,
  `manuscript/docs/reference/drafting-with-ai.md`, `manuscript/docs/reference/scene-craft.md`
  and `world/docs/reference/story-bible.md`.
- **Method:** `standards/method/FICTION.md`. **Real-world detail:** `research/src/setting/`.

## Additions to the steps

- **Step 2 — also read the story bible first.** Read the file of every character in the beat
  (their `## Voice markers` above all), the place files, the names register,
  `planning/src/continuity.md` and `planning/src/timeline.md`, the causality beats this section
  dramatises, and the point-of-view character's arc in `planning/src/arcs/`. Where the project
  has constructed languages, read the lexicon of each language the beat uses.
- **Step 3 — also stop on a missing cause or name.** A beat with no cause in
  `planning/src/causality.md` stops for `planning/workflows/03-chart-the-causality/`. A name the
  beat needs that is not in the register comes from `create-name` first
  (`world/workflows/03-name-something/`); never coin one in passing.
- **Step 4 — also check the real world.** Real places, periods, technology, medicine, law and
  weapons go through `fact-check`, with their sources noted in `research/src/setting/`, or carry
  `VERIFY`.
- **Step 6 — also give the beat its engine.** A goal, a conflict and an outcome; one point of view,
  telling the reader only what that character can know; beats joined by 'because' and
  'therefore', never 'and then'; dialogue written to each speaker's voice markers.
- **Step 6 — also write constructed words with restraint.** Where the project has a constructed
  language, write its words romanised inside a span, `[word]{.conlang lang=<slug>}`, using only
  headwords already in that language's lexicon. A missing word is coined first, through the
  add-word skill, never invented on the page. No paragraph carries more than three unglossed
  constructed words.
- **Step 7 — also report, never repair.** A contradiction with the story bible gets an
  `AUTHOR TO CONFIRM` naming both places; neither side is changed. A new fact the draft
  introduces (an age, a scar, a distance, a family tie) is listed for the hand-back, never written
  into `planning/src/continuity.md` from here.
- **Step 10 — also list what the beat establishes.** Report each new fact with its kind and the
  section, and every name used that the register lacks. `continuity`, `causality` and
  `character-voice` check the assembled chapter at structural review.

## Domain rules

- **The story bible is the source of truth** (`standards/method/FICTION.md` Section 6), and a
  contradiction is reported, never repaired (`.claude/rules/syntek-author/03-authorship.md`
  Section 7).
- **Every beat has a cause** (Section 1); **coincidence may make trouble, never resolve it**
  (Section 7).
- **Point-of-view discipline** (Section 5): nothing leaks from outside the point-of-view
  character's knowledge.
- **Setup and payoff** (Section 4): a detail planted in this beat is named in the hand-back, so its
  payoff can be planned.
- **Names come from the register**, and a constructed language's words from its lexicon.

## Examples

An invented line with a constructed word in its span:

```markdown
She used her grandmother's word for the river, [quaro]{.conlang lang=<slug>}, and the boy only frowned.
```

An invented hand-back entry for a new fact:

```text
New facts (for planning/src/continuity.md, for the author to accept):
- Ilsa's left hand is scarred across the palm · character · 04-the-mill · the-ledger
```
