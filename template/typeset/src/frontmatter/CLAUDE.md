@./CONTEXT.md

# CLAUDE.md — typeset/src/frontmatter/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `typeset/CONTEXT.md` →
`typeset/CLAUDE.md` → `typeset/src/CONTEXT.md` → `typeset/src/CLAUDE.md` → this folder's
`CONTEXT.md` (the pages it holds, imported above) → this file.

## Purpose (one line)

Set the pages before the text with words the author or the publisher supplied, and nothing else.

## How to work here

- **Routing:** the `typeset` skill, within `typeset/workflows/04-typeset-the-book/`.
- **Model:** **Opus** for setting a page; the mechanical tier for adding its `\houseinput` line
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps for a page:**
  1. Ask the author for the exact words (and, for the title verso, the publisher's details).
  2. Write `<name>.tex` here: plain LaTeX with house macros only, no preamble, no
     `\begin{document}`; `\thispagestyle{empty}` for a page that carries no folio.
  3. Add or confirm its `\houseinput{frontmatter/<name>}` line in `typeset/src/book.tex`.
  4. `make print`, and read the page.
- **Definition of done:** the page prints in its place, its words are exactly the ones supplied,
  and nothing on it was invented.

## Guardrails

- **Never compose these words.** A dedication, a copyright line or an acknowledgement drafted by
  the AI is an invention in the author's voice. Ask; leave the file out until the words come.
- **Never invent an ISBN, an edition, a date or a permission.** An unknown value stays out, with
  an `AUTHOR TO CONFIRM` flag for the author, as `\dnote{AUTHOR TO CONFIRM: …}`.
- **Never overwrite a page** the author has approved without confirming.

## Output & naming

- **Hand-written (with the author):** `copyright.tex`, `dedication.tex` and any other page, named
  in kebab-case for what it is.
- **Generated:** nothing.
