---
name: build-language
description: >-
  Build or change a constructed language for the novel, one subsystem at a time in the house
  method's order: the speakers; two or three real-world models from the world files (period,
  reasoning, reader associations, sample names, risks and a recommendation), researched and cited;
  proto-language or daughter; phonology (20 to 35 IPA phonemes, phonotactics, one stress rule, a
  few allophones); a readable romanisation; the grammar the book needs; a core lexicon built from
  roots; until make lexicon, derive, coverage and family run clean, each settled with the author
  first. Use when the author says 'build a language for the river people', 'what should Old Hethic
  sound like?', 'make a daughter language of the proto-tongue', 'set up the phonology', 'fix the
  language's spelling', or 'the language needs a grammar'. Not one word (`add-word`), not the
  writing system (`design-script`), not audio (`pronounce`), not a name (`create-name`), not
  settling the model by interview alone (`grill-with-docs`, which step 4 uses).
---

# Skill: Build a language (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A constructed language for a novel exists to make names, words and the odd phrase feel as if they
belong to one people with one history. It need not be complete; it must be consistent. This skill
builds it world first and sound first: who speaks it, which real languages it is modelled on and
when, where it sits in its family, then its sounds, spelling, grammar and core words. Each subsystem
is settled with the author before the next begins, because every later layer is built on the ones
below it. The method's twenty-three rules live in the guide; this skill applies them in order and
cites them as 'conlang rule N'.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/06-build-a-language/` — this skill is that procedure in skill form; its steps and
  these are numbered alike.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/building-a-language.md` — the house conlang method in full: the twenty-three
  rules, real-world models, and how a model is chosen from the world files.
- `world/docs/reference/lexicon-format.md` — the schemas of the language's data files.
- `research/workflows/01-ingest-a-source/` — how every claim about a real language is researched and
  cited.
- `standards/method/FICTION.md` — rule 6: the language is part of the story bible.
- `standards/risk/FICTION.md` — rules 7 (real languages lend their sound, never their words) and 8
  (a hostile people is never a real people in disguise).

## How to build a language

1. **Fix what the book needs.** Ask the author: names only, a few words, phrases, or speech on the
   page; which people speak it; how it should feel beside the book's other languages. The answer
   sets how far down this list this pass goes. *Complete when:* the job and the depth of this pass
   are agreed.

2. **Read the speakers' world.** Read the people's file in `world/src/peoples/` (above all its
   `## Body and speech`), the culture's file in `world/src/cultures/` (values, rank, the sacred,
   materials and tools), the eras and events in `world/src/history/` that touch them (each event's
   `## Linguistic consequences`), their places, and any related language. List the domains where
   vocabulary must run deep (conlang rule 2), and what the world implies: sounds the bodies cannot
   make, honorifics a rank system needs, a sacred register. If the files are too thin to justify a
   choice, stop and name what is missing and which procedure fills it. *Complete when:* the value
   domains and the world's constraints are listed, each with its file, or the missing files are
   named.

3. **Propose real-world models and recommend one.** Run `make family` to see the existing families
   and their models. Offer two or three options, each with a real language (or blend), its family
   and period (a parent leans older than its daughters); the reasoning, tied to the named world
   files; what readers will associate with it; three to five sample names in the proposed sound; and
   the risks (false friends, a living, minority or sacred language, an association readers will
   carry). State your recommendation and its reason. Sound comes first: say what each borrows in
   phonology, phonotactics, stress and rhythm, and how strongly (`primary`, `secondary`, `accent`);
   morphology, syntax and naming habits only if wanted. Always flag a hostile or 'evil' people's
   language modelled on a real ethnic group's, and offer ancient or extinct models, or blends,
   instead (fiction risk rule 8; the outcome goes in the people file's depiction note).
   *Complete when:* the author has chosen each model, its period, its weight and what it borrows.

4. **Research the chosen models and cite them.** With the `research` skill, find out how each model
   actually sounds and works, into cited notes in `research/src/setting/`; nothing about a real
   language is asserted from memory. Each model becomes an `[[inspiration]]` entry (`language`,
   `period`, `family`, `weight`, `borrows`, `sources` pointing at the notes, `notes`). Words are
   never borrowed, only structure and flavour. Record the choice under the `Decisions` heading of
   `.claude/MEMORY.md` (mapped in `00-project.md` `## Memory headings`) through `grill-with-docs`,
   because it is hard to reverse. *Complete when:* every
   chosen model has its entry drafted and every source is a real note.

5. **Place the language in its family.** Proto, daughter or isolate (conlang rule 18). A daughter
   names its parent, which must exist and pass `make lexicon LANG=<parent>`, and its split is tied
   to an era in `world/src/history/eras.md` or an event file where one exists. Related languages
   share or descend from related models. *Complete when:* `kind`, and for a daughter `parent` and
   the dated split, are agreed.

6. **Create the language folder.** Agree the slug. Check that `world/src/languages/<slug>/` does not
   exist; if it does, stop and ask. Create the layout in `world/src/languages/CONTEXT.md`: the
   folder's pair; `language.toml` with `culture` (the culture file's path), `speakers`, `values`,
   `kind`, `parent` and every `[[inspiration]]`; `phonology.toml`; `sound-changes.toml` for a
   daughter; `grammar.md`; `lexicon.toml` with `[meta]` only; and `pronunciation.md` from the
   skeleton in `world/src/languages/CLAUDE.md` (narrator, request text, fallback and log), with no
   voice chosen. *Complete when:* every file exists and `language.toml` records what steps 2 to 5
   settled.

7. **For a daughter, write the ordered sound changes.** Starting from the parent's forms, write the
   changes in order as `[[rule]]` entries, each regular and each dated to the history where it can
   be. Show one derivation per change and one pair of changes whose order matters. Irregularity is
   left to fall out of the changes (conlang rule 19). For a proto-language or an isolate, record
   that this step does not apply. *Complete when:* the author has agreed the rules and the sample
   derivations, or the step is recorded as not applying.

8. **Settle the inventory.** Propose 20 to 35 phonemes in IPA, modelled on the chosen inspiration
   and allowed by the people's bodies; for a daughter, the inventory the changes produced (change a
   rule, not the inventory, to change it). Add `[classes]` as single capital letters.
   *Complete when:* the author has approved the inventory and `[inventory]` records it.

9. **Settle phonotactics, stress and allophones.** Write the syllable templates, permitted clusters
   and forbidden sequences, one `[stress]` rule, and a few ordered `[[allophone]]` rules. Show
   sample words that pass and one that fails, with the surface form of each from
   `python3 tooling/lexicon.py surface <slug> <ipa>`, and say them aloud for the author (conlang
   rule 23). *Complete when:* the author approves how the samples sound and `phonology.toml` records
   the rules.

10. **Settle the romanisation.** A separate question from the sound: English-friendly by default,
    with only a few model-flavoured spellings; one spelling per sound, no apostrophe soup, sparing
    diacritics, and every exception listed with its reason in `[romanisation.exceptions]`. The
    native script is a later, separate question for `design-script`. *Complete when:* no two sounds
    share a spelling unless an exception says why, and the author has read the sample words from
    their spellings.

11. **Record the grammar the book needs.** Word order and morphology type chosen together; what the
    language marks and what it ignores; the irregular frequent words; the pronouns (the grid in
    `tooling/data/core-concepts.toml`). Record each in `language.toml` (`word_order`, `morphology`,
    `marks`, `ignores`) and in `grammar.md` with an example built from real lexicon words; state
    every undecided point as undecided, so silence never implies a rule. *Complete when:* every
    point the book needs is decided or stated undecided.

12. **Build the core lexicon.** Roots first (entries with `pos = "root"`), then the core concepts
    and pronouns `make coverage LANG=<slug>` lists, deepest in the speakers' value domains, as far
    as this pass reaches; each word by the `add-word` procedure, in small batches the author
    confirms. A daughter's words come from its parent's through the sound changes. *Complete when:*
    the core words this pass needs exist and each traces to its roots.

13. **Check the files.** Run `make lexicon LANG=<slug>`, `make derive LANG=<slug>` for a daughter,
    then `make family`. Fix every error in the new work and explain every warning that stays. For a
    change to a language with words, list every word that now fails and every promoted section that
    uses one, and stop for the author before going further. *Complete when:* the commands run clean,
    or each remaining warning carries the author's accepted reason.

14. **Hand back.** Report the models chosen and their sources, the subsystems settled, what is still
    undecided, and the next procedures: `add-word` for vocabulary, `design-script` for a writing
    system, `pronounce` when the author wants to hear it, `create-name` for names in the language,
    and `make glossary LANG=<slug>` for a reader's glossary. *Complete when:* the author has the
    report.

## Anti-patterns

- **Sounds before speakers.** A language built before its people is decoration; the world decides
  where its vocabulary runs deep.
- **A model from memory.** Every claim about how a real language sounds or works is researched and
  cited.
- **Lifting real words.** Models lend sound and structure; words come from the language's own roots,
  and a deliberate echo is recorded and cited by `add-word`.
- **A villain's language on a real people's.** Readers carry the association back to real people.
- **Daughters invented beside the parent.** A daughter is derived by ordered sound changes, or it is
  a second isolate pretending to be family.
- **Hand-made irregularity.** Let it fall out of sound change, and keep it to frequent words.
- **Spelling to look exotic.** Readers say every word with English habits; spelling that fights them
  is mispronounced hundreds of times.
- **Two subsystems at once.** Each is settled with the author before the next is started.
- **Flooding the page.** More than three unglossed invented words in a paragraph loses the reader
  (conlang rule 22); `make lint` reports them.
- **Changing a frozen word.** A word in promoted prose changes only with the author, after its
  sections are listed.

## Cross-references

- `world/src/languages/` — one folder per language, with the layout in its `CONTEXT.md`.
- `world/docs/reference/building-a-language.md` — the method in full.
- `world/docs/reference/peoples.md` and `world/docs/reference/world-history.md` — the world files
  the models are reasoned from.
- `research/src/setting/` — the cited notes behind every `[[inspiration]]`.
- `.claude/skills/add-word/SKILL.md` — every word after the core.
- `.claude/skills/design-script/SKILL.md` — the writing system, with its own inspiration.
- `.claude/skills/pronounce/SKILL.md` — audio from the surface IPA, on request.
- `.claude/skills/create-name/SKILL.md` — names built from the language.
- `.claude/skills/grill-with-docs/SKILL.md` — opens language work with the model and its period.
- `.claude/skills/research/SKILL.md` — the cited notes on each real-world model.
