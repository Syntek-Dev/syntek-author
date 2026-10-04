# THEOLOGY.md — typeset, theology mode

The domain for setting a work of Christian non-fiction for print: footnotes that carry the
scholarly register, Scripture references, the original languages, and LORD in small capitals.

## Paths and unit

- **Unit:** the chapter. Markdown `manuscript/src/NN-kebab-title/NN-kebab-title.md`; base
  `typeset/src/units/.base/NN-kebab-title.tex`; styled file `typeset/src/units/NN-kebab-title.tex`.
- **Extra reads before styling:** `manuscript/docs/reference/main-text-and-footnotes.md` (what
  belongs in the body and what in a note) and the default Bible translation named in
  `00-project.md` `## Brief`, whose copyright notice the title verso will need.
- **Page-design choices this book adds:** a Greek typeface and a Hebrew typeface (`greekfont=`,
  `hebrewfont=`), asked only if the book quotes either language.

## Additions to the steps

- **Step 2 — also ask about the original languages.** If any chapter carries `{lang=grc}` or
  `{lang=hbo}` spans, recommend an installed typeface for each that covers its accents and points,
  and say plainly that Hebrew runs right to left in print.
- **Step 3 — also expect footnotes and citations.** Where the project keeps references, `make tex`
  renders each citation through the reference style; `make print` sets the reference list in the
  back matter. A Citeproc 'citation … not found' warning from `make tex`, or a bold key followed
  by `?` in the base, means a reference is missing: report it for the add-reference skill, never
  type a citation.
- **Step 5 — also style the Scripture and the divine name.** Tie a book's name to its chapter and
  verse with `~` (`John~3:16`, `1~Cor.~13`), so a reference never breaks across lines. Where the
  Markdown writes LORD (the translation's rendering of the divine name), set it as
  `\smallcaps{Lord}`; the check treats case inside small capitals as styling.
- **Step 7 — also read for the scholarly register:** every footnote under its sentence and on its
  page; Greek and Hebrew in their own typefaces, with no missing character in `make print`'s report;
  Hebrew reading right to left; Scripture references unbroken.

## Domain rules

- **Footnotes stay footnotes.** Never turn notes into endnotes, or move text between body and
  note, in the LaTeX: the split is the author's argument about its two readers.
- **Never alter a quotation from Scripture**, its spelling, capitals or punctuation, to suit the
  page. The words are the translation's, quoted by the author.
- **Original-language words arrive as the author marked them.** Never transliterate, re-point or
  'correct' Greek or Hebrew; a doubt about a form is a `VERIFY` for `fact-check`.
- **The translation's permission notice is the author's to supply**, from the publisher of the
  translation, for the title verso; never compose one.

## Examples

A styled line, against its base (invented prose):

```latex
% base
The LORD did not answer at once, and Psalm 13 does not pretend otherwise.
% styled
The \smallcaps{Lord} did not answer at once, and Psalm~13 does not pretend otherwise.
```

`make tex-check` passes: `~` is a space, and the case of LORD inside `\smallcaps` is styling.
Writing `The Lord God` for `The LORD` in the styled file fails it: that is a word added.
