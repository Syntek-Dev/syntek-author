# CONTEXT.md — world/workflows/07-add-a-word/

The procedure for coining one word in a constructed language, or a small batch the author asks
for: what the word must mean, whether the language already has it, where it sits in the
language's history (inherited, borrowed early or late, or coined), how it is built from roots,
affixes or compounds and shifted by the sound changes, any echo of a real word, its IPA and
spelling, its native-script form, and its entry in the lexicon. It mirrors adding a reference:
one entry, every field filled, checked by a script before anything uses it.

## Directory Tree

```text
world/workflows/07-add-a-word/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- A scene, a name or a title needs a word from a constructed language.
- A name being coined should mean something in the language it comes from.
- The author wants a small set of related words (kin terms, numbers, the parts of a boat).

Reach for a **different** procedure when the language's sounds, patterns or history need to
change first (`world/workflows/06-build-a-language/`), or when the word is needed only as a
name with no meaning in any language (`world/workflows/03-name-something/`).

## What it produces, and where

- **A lexicon entry**: one `[[word]]` appended to the language's `lexicon.toml`, every field
  present, passing `make lexicon`.
- **A word history** in the entry's own fields: `roots`, `affixes` or `compound_of`;
  `proto_form`, `stratum` and `entered_after`; `drift`; and, for a loan, `loan_from` and
  `loan_source`. A new root, if one was needed, is its own entry with `pos = "root"`.
- **A cited echo**, only where the author wants one: the real word, its verified meaning and a
  source, in `echo`.
- **A native spelling check**: the headword transliterated through the script's glyph table,
  or a missing glyph reported.
- **A register row** in `world/src/names-register.md`, when the word is used as a name.

## The failure this procedure exists to prevent

The word that sounds right and belongs to nothing. A word made up on the spot cannot be derived
from the language's roots, often breaks its phonotactics, has no place in the language's
history, and contradicts the next word built from the same idea. Building every word from the
language's own roots, placing it in time, and running the checks before use keeps the lexicon
one language rather than a list.

## Cross-references

- `world/docs/reference/lexicon-format.md` — every field, and what the checks test.
- `world/docs/reference/building-a-language.md` — the rules for words: derivation, word
  histories, loans, echoes.
- `world/src/history/` — when the word entered, and from whom.
- `world/docs/reference/writing-systems.md` — transliteration through the glyph table.
- `tooling/lexicon.py` and `tooling/script.py` — the checks.
