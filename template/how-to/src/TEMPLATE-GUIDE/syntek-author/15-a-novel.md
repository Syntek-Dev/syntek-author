# A novel — causes, continuity and the story bible

A novel holds together when every event has a cause and every fact stays true from the first page to the last.
A fiction project carries tools for both: a chain of causes, a story bible, character arcs and voices, and a pacing report.
This chapter shows each tool, then the printed book and the options a fiction project can add; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Every beat has a cause

A beat is one movement of the story, such as a decision, a discovery or a blow.
Each beat should follow from an earlier one, with 'because' or 'therefore' between them, never 'and then'.
`causality` charts a chapter's beats before it is drafted, each with its cause, its consequence and its place in story time.
The chain lives in `planning/src/causality.md`, and `planning/workflows/03-chart-the-causality/` builds it with you.
Once the chapter is drafted, `causality` checks the prose against the chain.
It flags a coincidence that gets a character out of trouble, a beat with no cause, a payoff with no set-up and a set-up left hanging.
You decide every change, and the chain records it.
At the structural review of a chapter, `causality` runs straight after `continuity`, because fixing either changes scenes.

## Continuity and the story bible

The story bible is everything the novel has established: the world files in `world/src/`, the names register, the continuity ledger and the timeline.
The names register is `world/src/names-register.md`, the continuity ledger `planning/src/continuity.md`, and the timeline `planning/src/timeline.md`.
`continuity` checks a chapter against the bible, and reports every contradiction with both locations and a question for you.
It never repairs either side in silence: you decide which is true, and the ledger records your choice.
A new fact the chapter establishes, such as an age, a scar or a distance, is proposed for the ledger for you to accept.
Real-world detail, such as a place, a period, a weapon or a medicine, carries a `VERIFY` flag until `fact-check` has a source for it.
A chapter climbs a ladder of statuses, from idea to final, and passes a numbered gate at each step.
`continuity` is the first extra check a novel's chapter passes at its structural review.

## Characters and voice

`chart-character-arc` charts how a character changes across the novel, and writes the chart to `planning/src/arcs/`.
It sets out the arc's type, what the character wants against what they need, the wound, the lie it taught them and the turn.
`planning/workflows/04-chart-a-character-arc/` runs it with you, and `world/workflows/01-create-a-character/` starts a new character.
Each character has a file in `world/src/characters/`, whose voice markers say how that character speaks.
`character-voice` checks dialogue and point-of-view narration against those markers, and against the narrator's voice in `standards/style/voice-notes.md`.
It reports drift, such as a line a character would never say or two characters who sound alike, and you decide each change.
`create-name` offers three to five names for a character, place or thing, each with its reasoning and how to say it.
It checks each option for names that look or sound alike, and for unwanted meanings, then registers the one you choose.
Names are never coined in passing: a name the register lacks is flagged.
`world/workflows/03-name-something/` runs it.

## Pacing

`pacing` reports on a chapter's pace: the length of each scene, whether scenes and their aftermaths alternate, and how the tension rises.
It notes where the story slows into summary, backstory or description, and whether the chapter ends on a question.
It is a report only: it never cuts, merges or rewrites, and you answer every item.
`pacing` and `character-voice` are the extra checks at the line edit, because both judge finished lines.
`standards/verification/FICTION.md` numbers every extra check, and `manuscript/workflows/05-review-a-chapter/` runs every review in order.

## The printed book

The printed book is set from your promoted text through Pandoc and LaTeX, and the AI never retypes a word of it.
`typeset` turns a promoted chapter into a styled LaTeX file using the house design, and only ever changes how the words look.
A check then compares the styled chapter's words with your Markdown, and fails on any word that differs.
The fiction design handles scene breaks, epigraphs and chapter openers.
The page design is your choice, recorded in `typeset/src/page-design.md`.
Before any of that, this command builds a proof of the whole manuscript, as a Word file and a PDF:

```bash
make book
```

The files appear in `build/`, which Git ignores, and building one changes nothing in the work.
Once the chapters are typeset, `make print` sets the printed book itself.

## Options

Each option was chosen when the project was made, and can be turned on later through an update.

- The worldbuilding option adds peoples, cultures, a world history, creatures and quests, with skills to create a creature and to design a quest.
- The constructed-language option adds languages built from their own sound rules, a lexicon, a writing system and its font, and pronunciation audio.
- The proposal option adds the query package: a query letter, a short and a long synopsis, comparable titles and a tracker of the literary agents you approach.
- The references option adds a citation database, and the sensitive-content option adds a standard and a check for sensitive material.

With the constructed-language option, the pronunciation in each language's lexicon is the source of truth, and audio is made from it.
The pronunciation skill makes audio through an ElevenLabs server called `elevenlabs`, and uses the free espeak-ng program where that server is absent.
It makes audio only when you ask, and states the number of characters before each batch, because every call spends your ElevenLabs credits.
The template never adds the ElevenLabs server to the project, because it needs a key, and a key never belongs in a repository.
Add the server once for your own account, so every project on your machine can use it, and its key stays in your own Claude Code settings.
Set `ELEVENLABS_API_KEY` in your shell first, in your own terminal, rather than typing the key into the command, and never commit it.
Then this command adds the server:

```bash
claude mcp add --env ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" --transport stdio --scope user elevenlabs -- uvx elevenlabs-mcp
```

Keep the name `elevenlabs`, because the skill calls the server's tools by that name.
The server saves audio in `~/Desktop` unless you set `ELEVENLABS_MCP_BASE_PATH` when you add it.
Each language's audio folder in the project is ignored by Git.
Where your binary files live under the data root, file each clip you keep with `make files-add FILE=… ROLE=generated`.

`.claude/rules/syntek-author/02-skills.md` lists the option skills this project has.
`how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` explains how to turn an option on or off, and what turning one off deletes.

## Where the rules live

- `.claude/rules/syntek-author/03-authorship.md` Section 7 holds the fiction rules: contradictions are reported, never repaired.
- `.claude/rules/syntek-author/03-authorship.md` Section 10 says why the printed book is never retyped.
- `standards/method/FICTION.md` holds the fiction method, and `standards/verification/FICTION.md` its gates.
- `.claude/rules/syntek-author/02-skills.md` Section 5 lists the fiction skills.

## Next

- The loop every section goes through → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Proofs, flags and checks → `how-to/src/TEMPLATE-GUIDE/syntek-author/08-building-proofs.md`
- Every skill and its job → `how-to/src/TEMPLATE-GUIDE/syntek-author/13-a-guide-to-skills.md`
