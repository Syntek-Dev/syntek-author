@./CONTEXT.md

# CLAUDE.md — tooling/pandoc/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `tooling/CONTEXT.md` →
`tooling/CLAUDE.md` → this folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep one filter between the author's Markdown and every output, so a mark means the same thing in
every format and no word is ever changed on the way.

## How to work here

- **Routing:** the filter is run by `make` alone; the `build` skill and the skills that render
  the work never call Pandoc themselves.
- **Model:** **Opus** for any change to the filter; reading it needs no model tier of its own
  (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps (a new mark, or a change to one):**
  1. Agree the mark with the author first: what it means, how it is written in Markdown, and what
     it becomes in each output. A mark is a promise every later chapter relies on.
  2. Change `house.lua` and its header table together; keep every output covered, the plain
     output included, which the fidelity check reads.
  3. In a book project, where the mark becomes a LaTeX macro, the house class must define it and
     the fidelity check must know whether its arguments are words or layout; change all three
     together.
  4. Run the filter on a sample through each target (`make pdf`, `make docx`, and any print or
     check target this project has) and read every output.
- **Definition of done:** every output renders the mark as intended, the words are unchanged in
  each, and the header table matches the code.

## Guardrails

- **Never change a word.** The filter may wrap, rename or drop markup, never text the reader
  reads. A filter that edits words breaks the guarantee the fidelity check gives.
- **Fail soft and say so.** A mark the filter cannot honour (a missing script tool, say) falls back
  to plain italic or plain text with a warning on standard error, the same way in every output.
- **No layout from the Markdown.** The filter maps meaning to presentation; it never reads raw
  layout instructions from an author's text.
- **Standard Pandoc Lua only.** No Lua modules beyond Pandoc's own.

## Output & naming

- **Hand-written:** `house.lua` and this pair.
- **Generated:** nothing here; what the filter writes lands in `build/`, or in a book project in a
  typeset chapter's base, through `make`.
