# A theology book — arguments, claims and traditions

A theology book makes an argument, and readers trust each sentence according to the kind of claim it makes.
A theology project carries tools that keep the argument honest: argument maps, six claim categories, and checks for other traditions and objections.
This chapter shows each tool, then the printed book and the options a theology project can add; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Argument maps

An argument map sets out a chapter's argument before it is drafted.
It names the thesis, the claims that carry it, the support and evidence for each claim, the objections, and what you concede.
You build one with `planning/workflows/02-map-the-argument/`, through an interview in which you settle every point.
Each map lives in `planning/src/arguments/`, one file for each chapter.
`planning/docs/reference/argument-maps.md` explains the form.
Once the chapter is drafted, `argument-audit` checks the prose against its map.
It flags a move with no support, a missing step, a conclusion stated beyond its evidence, and a move in the prose that the map does not carry.
It reports, and never repairs the argument: you decide whether the map or the prose changes.

## The six claim categories

Every substantive sentence in a theology book makes one kind of claim, and the prose should show which.

| Category | What it is | How the prose shows it |
|---|---|---|
| Biblical text | What the passage says | The reference, in the named translation |
| Textual observation | A feature of the text anyone can check: a word, a tense, a structure | 'the passage repeats …' |
| Interpretive inference | What the observation suggests the text means | 'on this reading …' |
| Historical interpretation | How a named tradition or writer has read it | The tradition or writer, cited |
| The author's theological conclusion | What you hold, all things weighed | In the first person, owned |
| Pastoral application | What it means for a reader or a church | Addressed to the reader |

A silent collapse presents an inference as if it were the text, a conclusion as if it were history, or an application as if it were exegesis.
A move from one passage to a whole doctrine, made without saying so, is a collapse too.
`category-check` labels every substantive sentence with its category, and flags each collapse it finds.
`draft-section` labels each move it drafts with its category, in a comment after the section.
Scripture is never quoted from memory.
Every quotation names its reference and its translation, and carries a `VERIFY` flag until it has been checked word for word.
Your default translation is the one you chose when the project was made, recorded under `## Brief` in `.claude/rules/syntek-author/00-project.md`.
A claim about a Greek or Hebrew word needs a lexicon or a grammar as its source, or a `VERIFY` flag.

## Other traditions and objections

A contested reading is a passage that careful readers from different traditions read differently.
`tradition-check` shows how readers from other traditions would push back on your reading.
It states each reading so that the people who hold it would recognise it.
A contested reading the chapter leans on is named in the main text, never only in a footnote.
The text also says which reading you adopt, and what would change if another were right.
`research/workflows/03-map-a-contested-reading/` maps one such reading into `research/src/contested-readings/`.
`steelman` tests how fairly the chapter states each objection to your argument.
It asks whether the objection's holders would recognise it, whether it is the strongest form, and whether a serious objection is missing.
It checks that each concession comes before your response to it.
It reports, and never rewrites.
`manuscript/workflows/10-steelman-the-objections/` runs it over a chapter.

## The theology checks at review

A chapter climbs a ladder of statuses, from idea to final, and passes a numbered gate at each step.
At the step from structural review to fact check, gate V4, a theology chapter passes four extra checks.
They run in order: the argument against its map with `argument-audit`, then the claim categories with `category-check`.
Then come the contested readings with `tradition-check`, and the objections with `steelman`.
The argument and its categories come first, because weighing objections against an argument that is about to change wastes the work.
At the fact check, `fact-check` compares every Scripture quotation with its translation, word for word, and every original-language claim with its source.
A quotation not yet checked keeps its `VERIFY` flag, and the chapter cannot move on while it does.
`standards/verification/THEOLOGY.md` numbers these checks, and `standards/method/THEOLOGY.md` holds the method rules they test.
`manuscript/workflows/05-review-a-chapter/` runs every review in order.

## The printed book

The printed book is set from your promoted text through Pandoc and LaTeX, and the AI never retypes a word of it.
`typeset` turns a promoted chapter into a styled LaTeX file using the house design, and only ever changes how the words look.
A check then compares the styled chapter's words with your Markdown, and fails on any word that differs.
A change of wording is always made in the Markdown, through the writing loop, and carried into the styled chapter afterwards.
The theology design handles footnotes, Scripture references, Greek and Hebrew type, and small capitals for LORD.
The page design is your choice, recorded in `typeset/src/page-design.md`: the trim size, the typefaces, the chapter openers and the footnote style.
The typesetting procedures run from `typeset/workflows/01-design-the-page/` to `typeset/workflows/04-typeset-the-book/`.
Before any of that, this command builds a proof of the whole manuscript, as a Word file and a PDF:

```bash
make book
```

The files appear in `build/`, which Git ignores, and building one changes nothing in the work.
Once the chapters are typeset, `make print` sets the printed book itself.

## Options

Options add more to a theology project, each chosen when the project was made or turned on later through an update.

- The proposal option adds a proposal layer: a book proposal, a sample, and a tracker of the people you ask to endorse the book.
- With it comes a skill that drafts each approach to an endorser for you to send yourself, and it never sends anything.
- The references option adds a citation database, a skill that adds each work under a key that never changes, and Harvard references in every proof.
- The sensitive-content option adds a standard for handling sensitive material and testimony with care, and a skill that checks a chapter against it.

`.claude/rules/syntek-author/02-skills.md` lists the option skills this project has.
`how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` explains how to turn an option on or off, and what turning one off deletes.

## Where the rules live

- `.claude/rules/syntek-author/03-authorship.md` Section 7 holds the theology rules: the claim categories, Scripture and contested readings.
- `.claude/rules/syntek-author/03-authorship.md` Section 10 says why the printed book is never retyped.
- `standards/method/THEOLOGY.md` holds the theology method, and `standards/verification/THEOLOGY.md` its gates.
- `.claude/rules/syntek-author/02-skills.md` Section 5 lists the theology skills.

## Next

- The loop every section goes through → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Proofs, flags and checks → `how-to/src/TEMPLATE-GUIDE/syntek-author/08-building-proofs.md`
- Every skill and its job → `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md`
