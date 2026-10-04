---
type: guide
skills: [draft-section, comprehension, category-check, tradition-check]
model: opus
---

# Main text and footnotes — the two-register rule

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The book runs on two registers at once. The **main text** is plain, warm prose the
reader named in `00-project.md` `## Brief` can follow without a dictionary. The **footnotes**
carry the depth that earns the trust of the specialist who reads them. Same claim, two audiences:
the body persuades; the note proves.

## What belongs in the body

- The argument itself, in plain words, at the reader's level.
- A plain gloss of any technical term the moment it is unavoidable: 'eschatology, the Church's
  teaching about the last things'. The gloss stays up here; the discussion goes below.
- Every signal of a **move between claim categories**: when the prose passes from what the text
  says to what it implies, from what the Church has held to what the author concludes, or from
  conclusion to pastoral application.
- The honest admissions: 'I do not know', 'this is my reading, not the text's plain sense'.

## What belongs in a footnote

- Scholarly engagement, qualifications and the longer form of a counter-argument.
- Technical exegesis and any extended discussion of Hebrew or Greek.
- The fuller history of an interpretation: who has held it, when and where.
- Translation comparisons, textual variants and the basis of any figure or date.

**The test:** if the reader named in `00-project.md` `## Brief` would stumble on a sentence, it
belongs in a note. If removing a sentence from the body leaves the argument intact but a specialist
unsatisfied, it belongs in a note.

## Four things never demoted to a footnote

1. **The concession.** A cost stated in a note has not been conceded.
2. **The contested reading.** Where the argument leans on a passage serious Christians read
   differently: which reading is adopted, and what would change if another were right.
3. **The author's own stake**, where it bears on the argument. Declared, not neutralised.
4. **The category shift.** The reader must see the moment exegesis becomes the author's
   conclusion.

These four are the book's argument about its own honesty. Burying them is how a book quietly
stops meaning them.

## How we apply it here

- Draft the body first at the reader's level; move qualifications into notes as you go.
- Write notes in Pandoc's form: `[^label]` in the sentence and the note beneath the paragraph, or
  an inline `^[…]` for a short one. One sentence per line applies inside notes too.
- Never let a source's register set the body's tone. Quote only what has been checked against the
  source, with its reference; anything unchecked carries a `VERIFY` flag.

## Who implements it

- **Skills:** `draft-section` builds the split in from the first draft; `comprehension` reads the
  body as the stated reader; `category-check` catches a silent category shift; `tradition-check`
  checks the contested readings are fairly stated in the body.
- **Workflows:** `manuscript/workflows/01-draft-a-section/`,
  `manuscript/workflows/05-review-a-chapter/`,
  `manuscript/workflows/10-steelman-the-objections/`.

## Governing standard

`standards/method/THEOLOGY.md` owns the six claim categories, the contested-reading rule and
concede-before-rebut; `standards/style/voice-notes.md` owns how each register sounds. The
standards own the rules; this guide owns the everyday call of body or footnote.
