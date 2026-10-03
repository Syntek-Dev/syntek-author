---
name: create-name
description: >-
  Name a character, place, people, creature, object or title for a novel, and register it.
  Reads the world first (the places and characters, and where they exist the peoples, cultures
  and history files and the source language's sound rules and real-world models), then offers
  three to five options, each with its reasoning, IPA and a reader respelling. Checks every
  option for look-alike and sound-alike clashes in world/src/names-register.md, for unintended
  meanings in its model languages and English slang, and by reading it aloud; the author
  chooses, and the name is registered with every column filled. Use when the author says 'I
  need a name for the ferryman', 'name this river', 'what would her people call her?', 'give me
  some options for the city', 'rename Arden', or 'is this name too like another?'. Not coining a
  dictionary word (the word skill of the constructed-language kit, where installed), not
  writing the character's file or arc (`chart-character-arc`), not checking names already in
  prose (`continuity`).
---

# Skill: Create a name (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A name is the most repeated piece of invention in a novel; the reader meets it hundreds of times. It
has three jobs: to sound as if it came from somewhere, to stay distinct from every other name on the
page, and to be sayable without stopping. This skill builds options from what the world already says
about the people who give the name, checks each one before the author sees it, and registers the one
the author chooses. It never chooses on the author's behalf.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/03-name-something/` — any single name, or a renaming; this skill is that
  procedure in skill form, and its steps and these are numbered alike.
- Step 4 of `world/workflows/01-create-a-character/` and of `world/workflows/02-create-a-place/` —
  the same steps inside a larger job; the culture and people procedures of the worldbuilding kit
  call them too.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/naming.md` — names come from somewhere, clashes and false friends,
  respellings and the read-aloud test.
- `standards/method/FICTION.md` — rule 6: the register is part of the story bible.
- `standards/risk/FICTION.md` — rules 3 (real people), 7 (real languages lend their sound, never
  their words) and 8 (a hostile people is never a real people in disguise).
- `standards/style/terminology.md` — where a name's likely misspelling is recorded as a form to
  avoid.

## How to create a name

1. **State what is being named.** The kind (one of the register's kinds: character, place, people,
   culture, creature, event, object, title, other), the people or language it comes from, who says
   it and how often, the tone and the register it should carry (everyday, formal, sacred, intimate,
   a name for strangers), and for a renaming the name being replaced and why. *Complete when:* the
   author has confirmed the brief in one or two sentences.

2. **Read the register, the world and the naming customs.** Read `world/src/names-register.md` in
   full, the files under `world/src/places/` and `world/src/characters/` the name touches, and any
   naming customs recorded in a world file or in `world/docs/project/`. Where the worldbuilding kit
   is installed, read the people's file (bodies that shape speech), the culture's file (naming
   customs; values; rank, which gives titles and forms of address; religion, which gives sacred
   names) and the history files (eras, migrations, conquests and contact, which leave loan names and
   old, worn place names). Where the constructed-language kit is installed and the name comes from
   one of its languages, read that language's `language.toml` (its real-world models and what each
   lends), `phonology.toml` (inventory, syllable shapes, stress) and `lexicon.toml` (the roots a
   meaningful name is built from), and the setting notes in `research/src/setting/` on the models'
   naming habits. If the files are too thin to justify a choice, say what is missing and which
   procedure would settle it, rather than guess.

   When no sound palette, naming custom or real-world model is recorded for the people who give the
   name, settle the name style before any name: offer two or three styles, each with a real-world
   language and period, the reasoning tied to named world files, what readers will associate with
   it, three sample names and its risks, and state which you recommend and why. Always flag
   modelling a hostile people's names on a real ethnic group's language, because readers carry the
   association back to real people; suggest an ancient or extinct model, or a blend (fiction risk
   rule 8). On the author's word, record the style where the people's naming customs live: the
   culture's file where the worldbuilding kit is installed, otherwise `.claude/MEMORY.md`
   `## Decisions`. *Complete when:* the constraints on the name are listed, each with the file it
   came from, and a name style is recorded.

3. **Offer three to five options.** For each: the name; its reasoning (sound palette or
   phonotactics, custom, meaning, and the model language's naming habit it follows); broad IPA with
   no slashes; a reader respelling with the stressed syllable in capitals (VAH-ree); the language it
   comes from; its meaning, or a dash. A name from a constructed language obeys its syllable shapes
   and is built from its own words, with the derivation shown; a real word is never lifted whole.
   Vary the set: a safe choice, a bolder one, and one that breaks a custom deliberately, if breaking
   it might serve the story. Say each aloud, at speed and inside a sentence, as a reader would on
   first sight, and drop any a reader would stumble on. Where the constructed-language kit is
   installed and the author asks to hear one, the pronounce skill voices it; audio is never made
   unasked, because every call spends credits. *Complete when:* three to five options sit in a table
   with every field filled, each one said aloud.

4. **Check every option for clashes and false friends.** For each, mark it clean or name its fault:

   - **Look-alike:** shares an initial letter, a length and an ending with a registered name.
   - **Sound-alike:** shares a stressed syllable or a rhyme with a registered name, or a retired
     one.
   - **False friend:** an unintended meaning in a model language, in English (slang included) or
     another major language, as a brand, or as the name of a prominent real person. Every claim
     about a real language comes from a researched, cited source (the `research` skill, notes in
     `research/src/setting/`), never from memory; an option that cannot yet be checked is marked
     unchecked, not clean.
   - **Restraint:** apostrophes, diacritics, doubled vowels and stacked consonants spent only where
     the strangeness is the point.

   *Complete when:* every option carries a verdict for each check.

5. **Let the author choose.** Present the options with their checks, your recommendation and its
   reason. Never choose for the author. A name the author offers is checked the same way before it
   is registered. *Complete when:* the author has named their choice, and any clash or unchecked
   meaning they accept is noted with their reason.

6. **Register the name.** Add one row to `world/src/names-register.md` in alphabetical order:
   `Name · Kind · IPA · Respelling · Language · Meaning · First appears · Notes`, with First appears
   left empty until promoted prose uses the name, and Notes holding the derivation, any model or
   echo it draws on, and any accepted clash. For a renaming, keep the old row, mark it 'retired
   DD/MM/YYYY' in Notes, and list every section that used it. Where the name comes from a
   constructed language, run `make lexicon LANG=<slug>`, which also checks the register against that
   language's sound rules. *Complete when:* the row exists and any check passes or its finding is
   reported.

7. **Record a likely misspelling.** Where the name has an obvious wrong form (a doubled letter, a
   familiar near-twin) and the author agrees, add it as a form to avoid in
   `standards/style/terminology.md`. *Complete when:* the wrong form is recorded, or the author has
   declined.

8. **Hand back.** Report the registered name with its IPA and respelling, any clash or unchecked
   meaning the author accepted, and for a renaming the sections still using the old name. A naming
   custom or style the choice settled goes to `.claude/MEMORY.md` `## Decisions` through
   `grill-with-docs` when it is hard to reverse. *Complete when:* the author has the report.

## Anti-patterns

- **Proposing before reading.** A name that ignores the culture's customs or the language's sounds
  has to be thrown away later, after the reader has met it.
- **Asserting a real language from memory.** 'That means "river" in Welsh' is a claim; research and
  cite it, or mark it unchecked.
- **Choosing for the author.** Recommend, with a reason; the author decides.
- **One option dressed as three.** Three spellings of one sound is not a choice.
- **Apostrophe soup.** Marks the reader cannot pronounce slow every one of the hundreds of readings.
- **Borrowing a real people's sacred or living names wholesale.** Take the feel of a model, never
  its words; flag the case under rule 7 of the fiction risk standard.
- **Renaming silently, or deleting a row.** A retired name keeps its row so stray uses are caught.
- **Registering late.** A name enters the register before it enters promoted prose.

## Cross-references

- `world/src/names-register.md` — the one list of every invented name.
- `world/docs/reference/naming.md` — the craft this skill applies.
- `world/docs/reference/story-bible.md` — where the register sits in the story bible.
- `.claude/skills/chart-character-arc/SKILL.md` — the character work a name often sits inside.
- `.claude/skills/continuity/SKILL.md` — checks the prose against the register.
- `.claude/skills/spelling/SKILL.md` — treats every registered name as a known word.
- `.claude/skills/research/SKILL.md` — the cited source behind every claim about a real language.
- `.claude/skills/grill-with-docs/SKILL.md` — records a naming custom or style that is hard to
  reverse.
