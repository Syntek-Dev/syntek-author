---
workflow: 07-add-a-word
phase: produce
skills: [add-word, research]
model: opus
---

# CHECKLIST.md — add a word

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/lexicon-format.md`, `world/docs/reference/building-a-language.md`
> and the `add-word` skill. Gates cite `standards/verification/verification.md` by number; this
> list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Read the language's `language.toml`, `phonology.toml`, `sound-changes.toml` (a daughter) and `grammar.md`. · _opus_
- [ ] The need stated: meaning, part of speech, speaker, register, where in the book; a batch confirmed in full. · _opus_

## Execution Checklist

**Before coining**

- [ ] **Searched the senses, roots and affixes; an existing or derivable word offered first.** · _opus_
- [ ] Model and period, stratum and entry point settled from the world history, each with a recommended answer. · _opus_

**The word**

- [ ] Built from roots, affixes or compounds; a daughter's form derived through the sound changes after `entered_after`, each stage shown. · _opus_
- [ ] Any new root proposed as a `pos = "root"` entry and approved by the author before use. · _opus_
- [ ] A loan reshaped to the phonotactics, with `loan_from` and `loan_source`. · _opus_
- [ ] Drift recorded; `senses` not one-to-one with English. · _opus_
- [ ] Any echo verified and cited; a prominent word checked for false friends in the model languages and English. · _opus_
- [ ] Phonemic IPA written; headword spelled through `[romanisation]`; said aloud; respelling in `notes` where needed. · _opus_
- [ ] The author chose among the candidates. · _opus_

**Recording and checking**

- [ ] Native spelling checked by transliterating the headword with `tooling/script.py`; any missing glyph recorded, not drawn. · _sonnet_
- [ ] One `[[word]]` appended with every key present; nothing reordered or overwritten. · _sonnet_
- [ ] The `derived` list of each source word updated. · _sonnet_
- [ ] `make lexicon LANG=<slug>` run (and `make derive LANG=<slug>` for a daughter); the new entry passes; older failures reported, not fixed in passing. · _sonnet_
- [ ] Register row added when the word is used as a name. · _sonnet_

## Done When

- [ ] **The entry's history reproduces its IPA, and the checks pass.** · _opus_
- [ ] Handed back: headword, IPA, respelling, senses, history, echo and source, native spelling or missing glyph, roots awaiting approval. · _opus_
