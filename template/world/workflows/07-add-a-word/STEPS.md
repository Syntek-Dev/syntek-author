---
workflow: 07-add-a-word
phase: produce
skills: [add-word, research]
model: opus
---

# STEPS.md — add a word

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for coining one word (or a small requested batch) and recording it in the
lexicon. Each step names the skill and guide it uses. **Run in order** (search before building,
place in history before deriving, check before use) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `add-word`
> skill is this procedure in skill form.

## 1. State the need

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

The meaning in English, the part of speech, who says it and in what register, and where in the
book it is needed. For a batch, the full list, confirmed with the author before any is coined.
_Substantive._

## 2. Search the lexicon first

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

Search the language's `lexicon.toml`: every entry's `senses`, and the roots and affixes (entries
with `pos = "root"` or `"affix"`). If the language has the word, or can derive it from an
existing one with a living affix or a compound, offer that first. _Substantive._

## 3. Place the word in the language's history

> **Skill:** `add-word` · **Guide:** `world/docs/reference/building-a-language.md`

Open with the model: which of the language's real-world models (and which period) gives the word
its flavour, and whether a deliberate echo of a real word is wanted. Then its stratum
(inherited, early loan, late loan or coinage) and, from `world/src/history/`, when it entered:
which sound changes it has been through. A loan names its source language and form. Each
question carries a recommended answer with its reason. _Substantive._

## 4. Build the word

> **Skill:** `add-word` · **Guide:** `world/docs/reference/building-a-language.md`

From roots, affixes or compounds first; a new root (a `pos = "root"` entry) only when none fits,
and only with the author's approval. In a daughter, start from the `proto_form` and apply the
sound changes after `entered_after`, showing each stage; a loan is reshaped to the phonotactics.
Record the semantic drift, and give `senses` that do not map one-to-one onto English. Offer two
or three candidates where the derivation allows a choice. _Substantive._

## 5. Check echoes and false friends

> **Skill:** `research` · **Guide:** `world/docs/reference/building-a-language.md`

A deliberate echo is verified from a source (the real word, its meaning, the source) before it
is written into `echo`, never from memory. For a prominent word, check the candidates for
unintended meanings in the model languages and in English, including slang. _Substantive._

## 6. Fix the IPA and the spelling

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

Write the phonemic IPA (no slashes or dots; no stress mark unless the language's stress rule is
lexical, in which case ˈ marks the stressed syllable) and spell it through `[romanisation]` in
`phonology.toml`; that spelling is the headword. Say it aloud for the author. Add a reader
respelling to `notes` where the stress or a sound will surprise an English reader.
_Substantive._

## 7. Check the native spelling

> **Skill:** `add-word` · **Guide:** `world/docs/reference/writing-systems.md`

If the language has a script, run `python3 tooling/script.py transliterate <lang> "<headword>"`.
If a unit is missing, record it for the hand-back and route the glyph to
`world/workflows/08-design-a-script/`; never draw one here. _Mechanical._

## 8. Append the entry

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

Append one `[[word]]` at the end of `lexicon.toml` with every key present: `native` and
`first_used` empty, `derived` empty. Add the new headword to the `derived` list of each word it
was formed from. Never reorder or overwrite an entry. _Mechanical._

## 9. Run the checks

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

Run `make lexicon LANG=<slug>`, and `make derive LANG=<slug>` for a daughter; where the word fills
a core concept, `make coverage LANG=<slug>` shows it filled. Fix any failure in the new entry
before anything uses it; a failure in an older entry is reported, not fixed in passing.
_Mechanical._

## 10. Register it, if it is a name

> **Skill:** `add-word` · **Guide:** `world/docs/reference/naming.md`

When the word is used as a name, add a row to `world/src/names-register.md` with the language's
slug in the Language column and the main sense as the Meaning. _Mechanical._

## 11. Hand back

> **Skill:** `add-word` · **Guide:** `world/docs/reference/lexicon-format.md`

Report the headword, IPA, respelling, senses and history (stratum, entry point, derivation,
drift); any echo and its source; the native spelling or the missing glyph; any new root awaiting
approval; and the checks' results. _Substantive._
