@./CONTEXT.md

# CLAUDE.md — world/workflows/07-add-a-word/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Coin a word that the language could really have produced, record it completely, and prove it
with the checker before the book uses it.

## How to work here

- **Routing:** skill `add-word`, with `research` for echoes and false friends; guides
  `world/docs/reference/lexicon-format.md` and `world/docs/reference/building-a-language.md`;
  checks `make lexicon LANG=<slug>`, `make derive LANG=<slug>` (daughters) and
  `python3 tooling/script.py transliterate <lang> "<headword>"`.
- **Model:** **Opus** for the derivation and every choice of form or meaning; the mechanical
  tier for appending the entry and running the checks
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: the need →
  search the lexicon → place it in history → build it → echoes and false friends → IPA and
  spelling → native spelling → append the entry → check → register if it is a name → hand back.
- **Definition of done:** the entry has every key, its history reproduces its IPA from entries
  in the lexicon and the language's sound changes, the checks pass, and its native spelling
  exists or the missing glyph is reported.

## Guardrails

- **Search before coining.** A meaning the language already covers, or can derive from an
  existing word, is not a new root.
- **Derive, do not invent.** Every inherited word comes from roots through the ordered changes;
  a loan or a late coinage records when it entered, and undergoes only the later changes. A new
  root is a new `pos = "root"` entry, added only with the author's approval.
- **Structure, not vocabulary.** A real language lends flavour, never words; a deliberate echo
  is verified and cited, never remembered.
- **One word, or the small batch asked for.** Never coin more than requested; every word is a
  commitment the language must keep.
- **Append, never reorder or overwrite.** A word used in promoted prose is never deleted; it is
  retired in `notes` with the date.
- **A missing glyph is reported, never drawn here.** Drawing belongs to
  `world/workflows/08-design-a-script/`.

## Output & naming

- **Produces:** one `[[word]]` appended to `world/src/languages/<lang>/lexicon.toml`.
- **Also writes:** a root entry, when the author approves one; the `derived` list of each word
  it was formed from; a register row when the word is a name.
- **Generated:** nothing; the checks only report.
- **Does not touch:** `language.toml`, `phonology.toml`, `sound-changes.toml`, the script, or
  promoted prose.
