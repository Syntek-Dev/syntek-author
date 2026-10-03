---
type: guide
skills: [typeset]
model: opus
---

# The house class — every option, every macro, and when each is right

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** `tooling/latex/housebook.cls` sets the printed book. Its options carry the author's
page-design choices; its macros are the only styling a chapter may gain. Anything else in a
styled chapter is reported by `make tex-check`.

## Class options (in `typeset/src/book.tex`, mirrored in `typeset/src/page-design.md`)

| Option | Values (default first) | Sets |
|---|---|---|
| `trim=` | `demy` 138×216 mm, `b-format` 129×198, `a-format` 110×178, `royal` 156×234, `a5`, `us-trade` 6×9 in, `digest` 5.5×8.5 in | the page, which is the trim |
| `trimwidth=`, `trimheight=` | lengths | a custom trim (both, or neither) |
| `inner=`, `outer=`, `top=`, `bottom=` | lengths | margins; defaults suit the trim |
| `fontsize=` | `11pt`, `10pt`, `12pt` | the body size |
| `mainfont=`, `headingfont=` | an installed typeface | body and headings; a missing one falls back, with a warning |
| `chapterstyle=` | `centred`, `left`, `plain` | the chapter opener |
| `chapterlabel=` | `numeral`, `word`, `none` | 'Chapter 3', 'Chapter Three', or no label |
| `scenebreak=` | `stars`, `asterism`, `fleuron`, `rule`, `space` | the scene-break mark (a missing glyph falls back to stars) |
| `footnotes=` | `hang`, `plain` | number in a hanging box, or a superscript |
| `dropcaps=` | `true`, `false` | whether `\dropcap` draws a drop capital |
| `greekfont=`, `hebrewfont=` | an installed typeface | the faces for `\greek` and `\hebrew` |
| `final` | (present or absent) | an open `\dnote`, or a character no font can draw, stops the print |

## Macros Pandoc writes from the Markdown

`\begin{epigraph}` … `\epigraphsource{}` … `\end{epigraph}`, `\scenebreak`, `\smallcaps{}`,
`\greek{}`, `\hebrew{}`, `\conlang[slug]{}`, `\conlangnative[slug][romanised]{}`, and `\dnote{}`
for a flag still open in the Markdown. These arrive in the base; never add one by hand, because
each stands for a mark the author made (semantic-markdown.md, beside this guide).

## Macros the styling may add

| Macro | Use it for | Never |
|---|---|---|
| `\dropcap{T}{he river}` | the first word of a chapter's first paragraph, split at its first letter | to change a word's case or spelling |
| `\smallcaps{Lord}` | small capitals the Markdown implies but could not mark; letter case inside is styling | around a whole sentence |
| `\housemap{assets/maps/…}` | a full-page map, where the author places it | with a caption the author did not write |
| `~` between two words | a non-breaking space (`John~3`, `Mr~Tam`) | to join words that were apart |
| `\-` inside a word | a hyphenation point | anywhere but inside a word |
| `\enlargethispage{\baselineskip}`, `\looseness=-1`, `\pagebreak`, `\linebreak`, `\clearpage` | fitting the page after a proof: a widow, a lone line | before the proof shows the need |

`\setscenebreak{…}` in `book.tex` replaces the scene-break mark outright, and `\runningtitle{…}`
shortens the title in the running heads. `\houseinput{units/NN-kebab-title}` and
`\housereferences` belong to `book.tex` alone.

## How we apply it here

- A styled chapter differs from its base only by the macros above; read the diff before checking.
- Every option change is the author's, and goes into `page-design.md` and `book.tex` together.
- Fit pages last, after the proof, one nudge at a time, then `make tex-check` and print again.

## Who implements it

- **Skills:** `typeset` styles and prints; the author chooses every option.
- **Workflows:** `typeset/workflows/01-design-the-page/`, `typeset/workflows/02-typeset-a-chapter/`.

## Governing standard

`tooling/latex/housebook.cls` is the definition; `.claude/rules/syntek-author/03-authorship.md` owns
the author's decisions. The class owns what each macro does; this guide owns when to use it.
