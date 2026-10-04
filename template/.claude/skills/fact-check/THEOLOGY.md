# THEOLOGY.md — fact-check in a theology book

The claims a theology book is checked on first: Scripture and its wording, quotations of the
Church's writers, what a Hebrew or Greek word means, what the Church has held and when, and what a
survey of believers found.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with section drafts
  in its `drafts/` folder. Flags are Markdown comments, in the body and in footnotes alike.
- **The sweep** is step 6 of `manuscript/workflows/05-review-a-chapter/`; a single claim, before or
  during drafting, goes through `research/workflows/02-verify-a-claim/`.
- **Extra reads:** `standards/method/THEOLOGY.md` rule 9 (Scripture and original languages);
  `standards/verification/THEOLOGY.md` Section 2 (Scripture is part of V5); the chapter's argument
  map in `planning/src/arguments/`; the maps in `research/src/contested-readings/` the chapter
  leans on; `research/docs/reference/contested-readings.md`.
- **The default translation** is named in `00-project.md` `## Brief`, by its citation key.
- **Keying sources:** where the project keeps the citation database, every source (each
  translation and edition included) is keyed with the add-reference skill in the same pass as its
  evidence entry.

## Additions to the steps

- **Step 2 — also queue:** every Scripture quotation and every bare reference; every quotation of
  a theologian, a church father, a creed or a confession; every claim about a Hebrew, Aramaic or
  Greek word (its meaning, form or range); every historical claim about what a council, a tradition
  or 'the early Church' held, and when; every survey or study about churches, belief or practice.
  In a section draft, the trailing claim-categories block shows which sentences are Biblical text,
  textual observation or historical interpretation: those are checkable.
- **Step 3 — also:** a sweeping historical claim ('the Church has always taught…') reduces to named
  witnesses with dates. If no witness can be named, that is the finding.
- **Step 5 — also, for Scripture:** compare the quotation word for word with the named translation
  in the edition its key names, punctuation and the capitalisation of divine names included; check
  the reference to the verse, minding that verse numbering differs between Hebrew and English
  Bibles and between some translations. A quotation from any other translation names it at the
  quotation.
- **Step 5 — also, for a word in the original languages:** a standard lexicon or grammar, cited by
  entry, reporting how the word is used in texts of the period, not where it came from.
- **Step 5 — also, for the Church's writers:** a critical edition or a scholarly translation, with
  its locator (work, book, chapter, section). Anthologies, sermon collections and quotation websites
  are scouts that point to the edition, never the source.
- **Step 6 — also check these conflations:** a translation's wording treated as the original's; a
  word's etymology, or a later English word built on it, presented as its meaning; a later doctrinal
  formulation read back into an earlier writer; one tradition's reading quoted as 'the Church's'; a
  minority reading presented as consensus, or the reverse; a devotional paraphrase quoted as
  Scripture; a survey of one denomination or one country quoted for all Christians.
- **Step 7 — also:** a verdict may say that a reading exists, who holds it and since when. Which
  reading is right is never a verdict: it belongs in `research/src/contested-readings/` and to
  `tradition-check`.
- **Step 10 — also:** an unchecked Scripture quotation keeps its `VERIFY` flag, and V5 cannot pass
  while one remains. Agreed wording changes go back through the section
  (`manuscript/workflows/02-adapt-a-draft/` or `manuscript/workflows/03-improve-your-draft/`, then
  `manuscript/workflows/04-promote-a-section/`).

## Domain rules

- **Three of the six claim categories are checkable:** Biblical text (the wording), textual
  observation (a feature anyone can check) and historical interpretation (who read it so). An
  interpretive inference, the author's theological conclusion and a pastoral application are
  argued, not verified: never give them a verdict, and never let a verified fact stand in for one.
  The labels are `category-check`'s.
- **Scripture is never quoted from memory**, however familiar the verse.
- **A fact does not settle a theological question.** Report what the sources establish and where
  they stop; the conclusion is the author's.
- **What was heard in pastoral confidence is not a source** (`standards/risk/THEOLOGY.md` rule 3).
- **Claims about the author's ministry, posts and qualifications** are checked against the `Facts`
  heading of `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`) and put to the
  author where it is silent; an overstated credential is the error a hostile reviewer finds first.

## Examples

Invented claims, shown as report lines; bracketed parts stand for real details.

> **`the-turn`, line 6.** Quotation of [reference] checked against the default translation: two
> words differ from the printed text. `verified-with-caveat`: the reference is right; usable
> wording is the translation's own text, quoted exactly. Flag kept until the line matches.

> **`opening`, footnote 2.** 'The Greek word here literally means [an English word derived from
> it].' The cited lexicon gives the word's range in the period as [senses], and none is the modern
> derivative. `unsupported` as written; recommend cutting, or rewording to the lexicon's sense with
> the entry cited.

> **`opening`, line 14.** 'The early Church read this passage as [reading A].' Checked as: '[writer
> X] and [writer Y], both before [date], read the passage as [reading A].' Two witnesses found in
> critical editions; a third early writer reads it otherwise. `verified-with-caveat`; usable
> wording: 'Several early writers, among them [X] and [Y], read it as [reading A]; it was not the
> only reading.' The other reading is added to the passage's map in `research/src/contested-readings/`.

> **`the-turn`, line 22.** '[N] per cent of churchgoers [do Z].' One survey, of one denomination,
> in one country, self-reported, [year]. `thin`: usable only as 'one survey of [denomination]
> churchgoers in [country] found…', with its date in the note.
