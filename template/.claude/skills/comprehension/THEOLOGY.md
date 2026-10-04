# THEOLOGY.md — comprehension in a theology book

A theology book runs on two registers: a main text the stated reader can follow without a
dictionary, and footnotes that carry the depth a specialist needs. This pass reads the main text as
the stated reader and checks that nothing they need has been sent below the line.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`.
- **The pass** is step 7 of `manuscript/workflows/05-review-a-chapter/`.
- **Extra reads:** `manuscript/docs/reference/main-text-and-footnotes.md` (the two registers, and
  the four things never demoted to a footnote); the claim categories in
  `standards/method/THEOLOGY.md` rule 1; the contested terms in `standards/style/terminology.md`.
- **The audience** in `00-project.md` `## Brief` is one of lay, ministry leaders or academic.

## Additions to the steps

- **Step 1 — also:** what each audience brings. A lay reader: no theological vocabulary, a Bible
  familiarity that varies widely, no knowledge of church history assumed. Ministry leaders: church
  practice and the common terms of their own tradition, not technical scholarship or other
  traditions' vocabulary. Academic: the technical vocabulary, but the main text is still written to
  be read, and the reader test in `00-project.md` `## Brief` still governs it.
- **Step 3 — also:** theological terms ('eschatology', 'sanctification'), terms that mean different
  things in different traditions (a word one church uses of a sacrament and another of a memorial),
  and transliterated Hebrew and Greek: each glossed in the body at its first use, in a phrase,
  with any longer discussion in a note.
- **Step 4 — also:** a bare reference ('see [reference]') asks a lay reader to stop and look it up;
  where the argument depends on what the passage says, the body quotes enough of it to follow.
  The reader must also see the moment the prose moves from what the text says to what the author
  concludes: a move between claim categories the reader cannot see is a comprehension finding
  as well as a `category-check` one.
- **Step 5 — also:** a body sentence that makes sense only with its footnote is a finding; so is
  a footnote the reader must read to follow the argument.
- **Step 6 — also:** a remedy that moves material into a note may never move one of the four things
  the guide keeps in the body: the concession, the contested reading, the author's own stake, the
  category shift.

## Domain rules

- **The main text is read as the stated reader; the notes are read only for what the body depends
  on.** The notes' register is the specialist's, and is not a finding.
- **Glossing is not simplifying.** A term the argument needs stays, glossed; it is never replaced by
  a looser word that changes the claim.
- **Never resolve a contested term to make it easier.** Where a term is contested, the reader is
  told so, briefly, in the body.

## Examples

> **Blocking.** `the-turn` line 3: 'The passage is eschatological.' A lay reader does not know the
> word, and the argument turns on it. Suggested remedy: a gloss in the body ('…is about the last
> things: what God will do at the end'), the discussion in a note.

> **Friction.** `opening` line 12: 'As [reference] makes clear…' The reader is not told what the passage
> says. Suggested remedy: quote the clause the argument rests on.

> **Not a finding** (audience: ministry leaders). 'Liturgy' used without a gloss: this audience
> owns the word.
