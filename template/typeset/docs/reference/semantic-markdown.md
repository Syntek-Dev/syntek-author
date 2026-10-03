---
type: guide
skills: [typeset, draft-section, promote-section, build]
model: opus
---

# Semantic Markdown — what the author may mark, and what each mark becomes

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The Markdown says what a passage *is*: an epigraph, a break between scenes, a
word in small capitals. It never says how it looks. The house filter, `tooling/pandoc/house.lua`,
turns each mark into the right thing for every output, so one source makes the quick proof, the
Word file, the e-book and the printed book alike.

## The marks

| Write in Markdown | It is | In print | In `.docx` and `.epub` |
|---|---|---|---|
| `::: epigraph` … `:::` | an epigraph; a last paragraph opening '—' is its source | `epigraph` set right, italic; the source upright | styles 'Epigraph' and 'Epigraph Source' |
| a lone `* * *`, or `::: scene-break` with `:::` | a break between scenes or sections | `\scenebreak`, the mark page design chose | a centred `* * *` |
| `[Lord]{.smallcaps}` | small capitals | `\smallcaps{Lord}` | small capitals |
| `[λόγος]{lang=grc}`, `[דָּבָר]{lang=hbo}` | Greek or Hebrew | `\greek{}`, `\hebrew{}` (right to left) | the text, marked with its language |
| `[^1]` and its note | a footnote | a footnote, in the chosen style | a footnote |
| `<!-- section: slug -->` | a section marker | a `%` comment, never printed | dropped |

An epigraph in Markdown:

```markdown
::: epigraph
'Count the stones, and the river lets you pass.'

— a saying of the ford villages
:::
```

In a project with the constructed-language kit, a word in an invented language is marked too, so
it can print in italic or in its own script; the conlang-in-print guide beside this one has the
two forms and what each becomes.

## What not to mark

- **No layout in the Markdown**: no raw LaTeX, no HTML, no blank lines to push text down, no
  `---` to draw a line. Page-fitting belongs to the styled file, after a proof.
- **No invented marks.** A class the filter does not know passes through as plain text, so it
  looks right in the Markdown and does nothing in print. Ask for a new mark instead.
- **No styling in place of meaning.** Italics (`*…*`) are for emphasis and titles; a word in an
  invented language or a term in Greek has its own mark, because print treats them differently.

## How we apply it here

- Marks go in when the section is drafted or revised, and reach the chapter file through
  promotion like every other word.
- An epigraph quoting another work needs its permission or its public-domain basis recorded
  before the book is released.
- A flag still open in the Markdown prints as a red `\dnote` in the proof, so it cannot be missed.

## Who implements it

- **Skills:** `draft-section` and the revision skills write the marks; `typeset` and `build`
  render them.
- **Workflows:** `typeset/workflows/02-typeset-a-chapter/`, and every section procedure in
  `manuscript/workflows/`.

## Governing standard

`tooling/pandoc/house.lua` defines what each mark becomes;
`.claude/rules/syntek-author/03-authorship.md` owns who decides the words. The filter owns the
mapping; this guide owns what an author may write.
