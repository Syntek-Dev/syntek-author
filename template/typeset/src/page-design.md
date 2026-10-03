# page-design.md — how <%PROJECT_NAME%> looks in print

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.**
> It ships with the project so that the typesetting skill and procedures point at something real from day one.
> Every choice below is open until the author makes it, and carries an `AUTHOR TO CONFIRM` flag so that `make flags` lists it.
> Meanwhile the house class uses the default each section names.

The record of the author's page-design choices for the printed book.
Each choice is a class option in `typeset/src/book.tex`; this file says what was chosen, why and when.
The `typeset` skill asks and recommends; the author decides (`typeset/workflows/01-design-the-page/`).
Every option is explained in `typeset/docs/reference/the-house-class.md`.

## Writing rules

1. **One choice per section, in the order below.**
   Trim comes first, because margins, type size and the page count all follow from it.
2. **Record a decision as its value, its reason and its date** (DD/MM/YYYY) under its heading, remove the flag, and add a row to the decisions table.
3. **Change this file and the class options in `book.tex` together.**
   If the two disagree, `book.tex` is what prints, and the disagreement is reported to the author.
4. **A typeface must be installed, and licensed for print and embedding.**
   The print warns and falls back when a named typeface is missing; never ship a book on the fallback.
5. **The printer or publisher's specification wins** over any preference recorded here; note it as the reason.

## Trim size

Class option `trim=` (`demy`, `b-format`, `a-format`, `royal`, `a5`, `us-trade`, `digest`), or `trimwidth=` with `trimheight=`.
Default meanwhile: `demy`, 138 × 216 mm.
<!-- AUTHOR TO CONFIRM: the trim size, from the printer's or publisher's specification. -->

## Margins

Class options `inner=`, `outer=`, `top=`, `bottom=`.
Default meanwhile: suited to the trim.
<!-- AUTHOR TO CONFIRM: the margins, or the printer's minimums plus the default. -->

## Body typeface and size

Class options `mainfont=` and `fontsize=` (`11pt`, `10pt`, `12pt`).
Default meanwhile: Latin Modern at 11 pt.
<!-- AUTHOR TO CONFIRM: the body typeface and its size. -->

## Heading typeface

Class option `headingfont=`.
Default meanwhile: the body typeface.
<!-- AUTHOR TO CONFIRM: the heading typeface, or the body typeface for both. -->

## Chapter opener

Class options `chapterstyle=` (`centred`, `left`, `plain`) and `chapterlabel=` (`numeral`, `word`, `none`).
Default meanwhile: centred, with 'Chapter 3' above the title.
<!-- AUTHOR TO CONFIRM: the chapter opener and its label. -->

## Scene-break mark

Class option `scenebreak=` (`stars`, `asterism`, `fleuron`, `rule`, `space`), or `\setscenebreak{…}` in `book.tex`.
Default meanwhile: three spaced asterisks.
<!-- AUTHOR TO CONFIRM: the mark between scenes or sections. -->

## Footnote style

Class option `footnotes=` (`hang`, `plain`).
Default meanwhile: the number in a hanging box.
<!-- AUTHOR TO CONFIRM: the footnote style. -->

## Drop capitals

Class option `dropcaps=` (`true`, `false`).
Default meanwhile: drop capitals on, where a chapter's styling places one with `\dropcap`.
<!-- AUTHOR TO CONFIRM: whether chapters open with a drop capital. -->
<: if DOC_TYPE == 'theology' :>
## Greek and Hebrew typefaces

Class options `greekfont=` and `hebrewfont=`, used by `[…]{lang=grc}` and `[…]{lang=hbo}` in the Markdown.
Default meanwhile: none set, so the print warns and uses the body typeface.
<!-- AUTHOR TO CONFIRM: a Greek typeface and a Hebrew typeface, if the book quotes either. -->
<: endif :><: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>
## Constructed languages on the page

No class option: a word marked `.conlang` prints in romanised italic, and one marked `.conlang-native` in the font `make font` builds from the language's glyphs.
<!-- AUTHOR TO CONFIRM: which words print in native script, and whether a glossary goes at the back. -->
<: endif :>
## Decisions

| Date | Choice | Was | Now | Reason |
|---|---|---|---|---|
