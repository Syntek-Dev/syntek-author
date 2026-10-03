---
type: guide
skills: [typeset]
model: opus
---

# The fidelity check — the author's words are never retyped

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** `make tex-check` runs `tooling/texcheck.py` on every styled chapter (or one,
with `UNIT=`). It strips the LaTeX back to the words a reader will see, reads the same chapter's
Markdown through Pandoc, and compares the two in order. One word inserted, deleted or changed,
one comma moved, and the check fails with a line number on each side.

## Why the AI never types the words

A model that retypes a paragraph can drop a word, 'correct' a dialect spelling or smooth a
deliberate oddity, and the change looks like styling in a diff of thousands of lines. So the
words enter the LaTeX only through Pandoc, and the check proves nothing changed afterwards. A
check that passes is evidence a publisher can rely on; a styled file nobody checked is not.

## What it compares, and what it ignores

| Compared | Ignored |
|---|---|
| every word, in order, and its letter case | layout: `\vspace`, `\enlargethispage`, `\looseness`, page breaks |
| punctuation, quotation marks, dashes | how a quotation mark or dash is spelt in LaTeX (`` ` `` or `‘`, `---` or `—`) |
| footnote text where the footnote is called, and where each note opens and closes | comments, labels, `\dnote` flags, a long table's repeated head |
| every scene break, epigraph and quotation: one added or dropped fails | ligatures, non-breaking and thin spaces, hyphenation points |
| text inside any macro, house or not; a URL as written | the kind of block the words sit in: a heading's level, a list, a table's cells, emphasis |

Letter case inside `\smallcaps{}` is styling, so it may differ there and nowhere else. A command
the house does not use is reported as a warning, and any words in its braces are still compared.

## Reading a failure

```text
texcheck: typeset/src/units/03-the-ford.tex differs from manuscript/src/03-the-ford/03-the-ford.md
  changed: Markdown line 14 'stones' → .tex line 41 'stone'
```

- **changed**, **deleted**, **inserted**: the styled file is wrong. Undo the edit that caused it,
  or copy the line back from the base. Never change the Markdown to match the LaTeX.
- **⟦note⟧**, **⟦break⟧**, **⟦epigraph⟧** or **⟦quote⟧** in a report: the structure moved. A word
  crossed a footnote's edge, or a scene break, epigraph or quotation was added or dropped.
- **unresolved merge conflict**: a carry-forward was left half done; finish it first.
- Every line of the styled file disagrees: the Markdown changed and the chapter was not
  re-typeset (`typeset/workflows/03-retypeset-after-edits/`).

## How we apply it here

- Run it after every styling session and before every `make print`; a print of an unchecked
  chapter is not a proof of the author's book.
- Treat a warning as a question: is that command styling the house allows, or text in disguise?

## Who implements it

- **Skills:** `typeset` runs it and acts on every finding.
- **Workflows:** `typeset/workflows/02-typeset-a-chapter/`,
  `typeset/workflows/03-retypeset-after-edits/`, `typeset/workflows/04-typeset-the-book/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns the rule that nothing reaches the book except
the author's approved words. What it cannot check (maths, the look of the page, whether a styling
choice was the author's) is listed in `tooling/texcheck.py` itself. The rule owns the requirement;
this guide owns reading the check.
