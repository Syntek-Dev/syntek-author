# THEOLOGY.md — grammar in a theology book

In a theology book some small words carry the argument's honesty: 'on this reading', 'I conclude',
'the text says'. They tell the reader which kind of claim a sentence makes. A grammar pass that
tidies one away has changed the claim, so this mode protects them, along with the wording and
punctuation of Scripture.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with section drafts
  in its `drafts/` folder. Main text and footnotes are both checked.
- **The pass** is step 9 of `manuscript/workflows/05-review-a-chapter/`.
- **Extra reads:** the claim categories in `standards/method/THEOLOGY.md` rules 1 and 2;
  `manuscript/docs/reference/main-text-and-footnotes.md` (the two registers); the Project settings
  of `standards/style/style-sheet.md` (how Scripture is quoted).
- **Where corrections go:** an accepted punctuation correction may be applied in the chapter file
  directly, logged as a row in that section's ledger entry. Any correction that changes a word,
  however small, is a wording change: it goes back through `manuscript/workflows/02-adapt-a-draft/`
  or `manuscript/workflows/03-improve-your-draft/` and is promoted again through
  `manuscript/workflows/04-promote-a-section/` (`manuscript/workflows/05-review-a-chapter/`,
  'Applying agreed fixes').

## Additions to the steps

- **Step 3 — also:** a hedge or a first-person marker that signals a claim category ('on this
  reading', 'I take this to mean', 'the passage says') is never removed, moved or merged by a
  correction. Where a sentence cannot be put right without touching one, report it to the author
  and note it for `category-check`.
- **Step 4 — also:** Scripture references are punctuated as the style sheet settles them (the
  chapter and verse separator, an en dash in a range, semicolons between references); on the first
  two conflicting forms, propose an entry. Footnote markers sit where the style sheet places them
  relative to punctuation.
- **Step 4 — also:** inside a Scripture quotation the translation's words, order and punctuation
  stand. Only its outer quotation marks follow the house nesting (single outside, double inside),
  unless the style sheet records otherwise.
- **Step 5 — also:** the footnotes' academic register (longer sentences, more subordinate clauses)
  is the register working as designed, not an error; it is checked for grammar, not for length.

## Domain rules

- **Quoted Scripture and quoted writers are never corrected.** A quotation that seems wrong goes to
  `fact-check`.
- **The claim-category signals are part of the argument.** A correction that changes which kind of
  claim a sentence makes is a change of substance, and goes back through the section.
- **Divine names and pronouns** take capitals as the style sheet settles, consistently in the
  author's prose.
- **Cross-references read 'Section 3.2'**, never the section sign.

## Examples

> **Agreement.** `the-turn` line 8: 'The welcome team, like many churches, were divided' → 'was
> divided' (the subject is 'the welcome team'). Accepted; because it changes a word, it goes back
> through the section's draft and is promoted again.

> **Hedge kept.** `opening` line 15: 'On this reading the passage commends welcome, it does not
> command it.' A comma splice. Offered: a semicolon after 'welcome', which keeps 'On this reading'
> governing both clauses; not the tidier 'The passage commends welcome…', which would present an
> inference as the text. Applied in the chapter file once accepted; ledger row added.

> **Style-sheet proposal.** References appear as '[book] 3:16' and '[book] 3.16' (two and four
> places, listed). Proposed entry for approval: a colon between chapter and verse.
