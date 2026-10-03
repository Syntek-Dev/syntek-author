---
workflow: 06-build-a-language
phase: produce
skills: [build-language, research]
model: opus
---

# CHECKLIST.md — build a language

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/building-a-language.md`, `world/docs/reference/lexicon-format.md`
> and the `build-language` skill. Gates cite `standards/verification/verification.md` by number;
> this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] What the book needs from the language agreed with the author, and how far this pass goes. · _opus_
- [ ] For an existing language: its `language.toml`, `phonology.toml`, `sound-changes.toml`, `grammar.md` and `lexicon.toml` read. · _opus_

## Execution Checklist

**World and models**

- [ ] **People, culture, history and places read; value domains listed; any thin file named with the procedure that fills it, instead of a guess.** · _opus_
- [ ] Two or three real-world models offered, each with period, reasoning tied to named world files, reader associations, sample names and risks; one recommended with its reason. · _opus_
- [ ] A hostile people modelled on a real ethnic group's language flagged, with ancient, extinct or blended alternatives. · _opus_
- [ ] The author chose; each chosen model researched and cited in `research/src/setting/`. · _opus_
- [ ] Kind settled (proto, daughter, isolate); a daughter's parent exists and passes, and its split is tied to the history. · _opus_

**Setting up**

- [ ] Slug agreed; checked the language folder does not exist; if it did, stopped and asked. · _sonnet_
- [ ] Folder created with the shared layout; `language.toml` carries `culture`, `values` and every `[[inspiration]]`. · _sonnet_

**One subsystem at a time, each settled before the next**

- [ ] Daughters: ordered sound changes written, one derivation per change, one order-sensitive pair shown. · _opus_
- [ ] Inventory of 20–35 phonemes in IPA, fitting the model and the speakers' bodies, approved. · _opus_
- [ ] Phonotactics, one stress rule and a few allophones written, with passing and failing samples said aloud. · _opus_
- [ ] Romanisation English-friendly, one spelling per sound, exceptions listed with reasons. · _opus_
- [ ] Word order with morphology type, marks and ignores, irregular frequent words and pronouns recorded; gaps stated as undecided. · _opus_
- [ ] Roots and core concepts built as far as this pass reaches, deepest in the value domains. · _opus_

**Checking**

- [ ] `make lexicon LANG=<slug>` run and passing; `make derive LANG=<slug>` too for a daughter; `make family` run. · _sonnet_
- [ ] For a change to a language with words: every broken word and every section using one listed, and the author consulted before going on. · _opus_

## Done When

- [ ] **Every model is cited, and every subsystem built in this pass was settled with the author before the next began.** · _opus_
- [ ] The language passes `make lexicon` (and `make derive` for a daughter). · _sonnet_
- [ ] Handed back: models and sources, subsystems settled, what is undecided, and the next procedures. · _opus_
