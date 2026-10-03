# FICTION.md — fact-check in a novel

A novel makes two kinds of factual claim: about the real world it borrows, which is checked
against sources, and about its own world, which is checked against the story bible. This mode keeps
the two apart, and adds a third: what a constructed language claims about the real languages it
is modelled on.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with section drafts
  in its `drafts/` folder. Flags are Markdown comments.
- **The sweep** is step 6 of `manuscript/workflows/05-review-a-chapter/`; a single claim goes
  through `research/workflows/02-verify-a-claim/`.
- **The real world:** setting notes in `research/src/setting/`, the guide
  `research/docs/reference/real-world-detail.md`, and the quotation register
  `research/src/permissions.md`.
- **The story bible:** `planning/src/continuity.md`, `planning/src/timeline.md`, `world/src/` and
  `world/src/names-register.md`.
- **Real languages behind a constructed one,** where the conlang kit is installed: each language
  folder's `language.toml` (its inspiration entries and their sources) and `lexicon.toml` (each
  word's `echo`), in the languages folder under world/src/.
- **Extra reads:** `standards/verification/FICTION.md` Section 2 (real-world detail is part of V5);
  `standards/risk/FICTION.md` (real people, real places, quoted material).

## Additions to the steps

- **Step 2 — also queue:** every real-world detail a reader could check (dates and events; what had
  been invented by then; prices and wages of the period; geography, distances, travel times,
  seasons and light; how a trade, a procedure or a weapon works; injury, illness and recovery; law
  and procedure as they stood; the idiom of a time and place); every real person, organisation or
  product named; every quotation, epigraph or lyric.
- **Step 2 — also queue, on a separate list,** the internal facts the scope relies on: an age, a
  distance, a date in the story's calendar, a scar, a family tie. They are compared, never given a
  verdict.
- **Step 2 — also queue,** where the conlang kit is installed, each claim about a real language:
  what an inspiration entry says the model language sounded like at its period, its family, and
  every `echo` (the real word and its meaning).
- **Step 3 — also:** a departure from the real world that is logged (in the setting note's
  `## Departures` and in `planning/src/continuity.md`) is a choice, not a claim to verify. An
  unlogged departure is put to the author as a question: error, or choice?
- **Step 5 — also, for internal facts:** the source is the story bible. A match needs no entry. A
  contradiction is reported with both locations and handed to `continuity`; a fact the prose
  establishes that the bible lacks is proposed for the `## Proposed` table of
  `planning/src/continuity.md`, for the author to confirm.
- **Step 5 — also, for period detail:** sources of the period itself (records, maps, manuals,
  newspapers, the testimony of people who did the work), never another novel or a film. Texture
  that is not a plain claim goes into a setting note in `research/src/setting/` with its source.
- **Step 5 — also, for a real language:** a descriptive grammar, a historical phonology or a
  period dictionary, read through `research`, recorded in a setting note in `research/src/setting/`
  that the inspiration entry's `sources` or the `echo` cites. Never from memory, and never from a
  forum's summary.
- **Step 6 — also check these conflations:** a modern practice read back into the period; a
  place's later name used before it existed; one region's custom given for a whole country; film
  convention taken for history; a modern form of a language quoted for the period the inspiration
  names; a word's modern meaning given for an older one; a romanised spelling taken for its sound.
- **Step 8 — also:** a detail the prose states plainly gets an evidence entry; the setting note
  that supplied it and the entry cite each other.
- **Step 9 — also:** a contradiction with the bible gets no `VERIFY` flag. It is reported, never
  repaired in either direction.
- **Step 10 — also:** agreed wording changes go back through the section
  (`manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`, then
  `manuscript/workflows/04-promote-a-section/`); a departure the author confirms as deliberate is
  logged in its setting note's `## Departures` and in `planning/src/continuity.md`.

## Domain rules

- **The real world is checked against sources; the invented world against the bible.** Never use
  one to correct the other.
- **A departure is a choice only when it is logged.** Unlogged, it is indistinguishable from an
  error.
- **A real person or organisation on the page** is checked for its public, checkable basis
  (`standards/risk/risk.md` rule 1); whether and how to depict them is the risk standard's, and
  the author's.
- **Claims about real languages are researched and cited, never asserted.** A minority, Indigenous
  or sacred language's actual words lifted into an invented one are reported to the author with
  `standards/risk/FICTION.md`.
- **Every quoted passage** has its row in `research/src/permissions.md`; fact-check confirms the
  quotation matches its source word for word.

## Examples

Invented claims, shown as report lines; bracketed parts stand for real details.

> **`crossing-at-night`, line 9.** 'The toll was [a sum] a head.' A county record of [period] gives
> that toll for a cart, not for a walker. `verified-with-caveat`; usable wording names the cart,
> or the walker's own rate from the same record. Setting note and evidence entry cross-cited.

> **`opening`, line 3.** 'Tam, two years older than Maren…' `planning/src/continuity.md` row F004
> makes Tam the younger. No verdict: contradiction reported with both locations and handed to
> `continuity`; neither side changed.

> **Inspiration entry for the example language.** '[Model language] of [period] stressed the first
> syllable.' A historical phonology read through `research` says so for the earlier part of the
> period and not the later. `contested`; the setting note records both, and the author chooses
> which point in history the language borrows.

> **`the-turn`, line 17.** A pocket watch in [year]. Period catalogues show such watches were sold
> then, at a price beyond a ferryman's wage. `verified-with-caveat`; the author decides whether
> the watch is explained or replaced.
