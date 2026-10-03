# CONTEXT.md — typeset/docs/reference/

The template's guides for the typesetting layer. Each answers one question that comes up while
the printed book is being made, in the same shape (what it is, the practice, how we apply it here,
who implements it, the governing rule), and each defers to a standard or a rules file. They are
template-owned: `copier update` replaces them when the template improves, so nothing written for
this book alone belongs here. Project guides and overrides live in `typeset/docs/project/`.

## Directory Tree

```text
typeset/docs/reference/
├── CONTEXT.md                     ← this file
├── CLAUDE.md                      ← operating rules
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>├── conlang-in-print.md            ← constructed-language words in the book: romanised or native script
<: endif :>├── semantic-markdown.md           ← what the author may mark in Markdown, and what each becomes
├── the-fidelity-check.md          ← how the check proves no word was retyped, and reading its report
├── the-house-class.md             ← every class option and macro, and when to use each
└── the-typesetting-pipeline.md    ← Markdown to base to styled file to print, and back after edits
```

## What's here

| Guide | The question it answers |
|---|---|
<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>| `typeset/docs/reference/conlang-in-print.md` | How does a word in a constructed language reach the page? |
<: endif :>| `typeset/docs/reference/semantic-markdown.md` | What may I mark in the Markdown, and what does each mark become? |
| `typeset/docs/reference/the-fidelity-check.md` | How do we know the printed words are the author's? |
| `typeset/docs/reference/the-house-class.md` | Which macro or option does this, and when is it right? |
| `typeset/docs/reference/the-typesetting-pipeline.md` | How does a chapter get from Markdown to the printed page, and back? |

Four guides serve every book. A project with the constructed-language kit has a fifth, for words
in an invented language and their native script.

## Cross-references

- `typeset/docs/project/` — this book's own guides; a same-named guide there overrides one here.
- `typeset/workflows/` — the procedures that name these guides on each step.
- `tooling/latex/housebook.cls` — the house class the guides describe.
- `.claude/rules/syntek-author/03-authorship.md` — the rules the fidelity check serves.
