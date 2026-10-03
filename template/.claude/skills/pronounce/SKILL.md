---
name: pronounce
description: >-
  Make audio of a constructed-language word, name or sample sentence, only when the author asks:
  takes the IPA from the lexicon or the names register, turns it into surface IPA with
  'python3 tooling/lexicon.py surface', and voices it through the user-scope ElevenLabs MCP server
  (Eleven v4, IPA between forward slashes, the language's recorded voice and model) into the
  language's git-ignored audio folder, falling back to an approximate espeak-ng voice. States
  the character count before any batch, because every call spends credits. Also the read-it-aloud
  test for a new name. Use when the author says 'how does "hebori" sound?', 'let me hear the
  name', 'pronounce these five words', 'choose a narrator for the hill tongue', 'read the oath
  aloud in the language', or 'make an audio guide for the narrator'. Not the IPA itself
  (`add-word`), not the sound system (`build-language`), not choosing a name (`create-name`).
---

# Skill: Pronounce (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

How a constructed word is said is recorded once, as phonemic IPA, in the lexicon or the names
register. Audio is derived from that IPA: useful for hearing a name before committing to it, for the
read-aloud test, or for briefing an audiobook narrator, but never the record. If the audio and the
IPA disagree, the audio is wrong. This skill voices the surface form (allophones and stress applied
by the tooling), with one recorded narrator per language, and only when the author asks, because
every call spends the author's credits.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/09-record-a-pronunciation/` — this skill is that procedure in skill form; its
  steps and these are numbered alike.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/pronunciation.md` — phonemic IPA stored, surface IPA spoken; the narrator,
  cost discipline and the fallback.
- `world/docs/reference/lexicon-format.md` — where each word's IPA lives.
- `.claude/rules/syntek-author/03-authorship.md` — the author decides what is made and what is
  spent.

## How to make a pronunciation

1. **Confirm the request.** Confirm that the author asked for audio, and for exactly what: which
   words, names or sentence, from which language. If nothing was asked, stop: never generate
   unasked, including as a 'helpful' extra after another skill. *Complete when:* the author's
   request is restated item by item.

2. **Read the IPA.** Take each item's phonemic IPA from the language's `lexicon.toml` (`ipa`) or
   from `world/src/names-register.md` (the IPA column). If an IPA is missing or doubtful, stop and
   route it to `add-word` or `create-name`; never improvise one. *Complete when:* every item has its
   recorded IPA, quoted with its source.

3. **Check the narrator, or choose one with the author.** The ElevenLabs tools come from a server
   the author configures once at user scope under the name `elevenlabs`; the project adds nothing to
   `.mcp.json`. They may be deferred: load them with ToolSearch, searching for 'elevenlabs'. If they
   are absent, run `command -v espeak-ng`: if it finds the program, tell the author and offer the
   fallback at step 7, or stop. If neither route exists, say so, give the install hint (the system
   package `espeak-ng`) and the server's setup command from `world/docs/reference/pronunciation.md`,
   and stop. Read the language's `pronunciation.md`. If a voice and model are recorded, use exactly
   those. If not: call `mcp__elevenlabs__list_models` and find the Eleven v4 model's ID (never
   assume it: without a `model_id` the server falls back to its default model); list candidate
   voices with `mcp__elevenlabs__search_voices`; and let the author choose one voice, saying first
   that every trial listen costs credits too. Record the voice name, voice ID, model ID, settings
   (stability and similarity, and any speed or output format chosen) and the date chosen in
   `pronunciation.md`. Keep one narrator per language: a second voice makes one language sound
   like two. *Complete when:* `pronunciation.md` records a voice and a model ID, the author has
   chosen the installed fallback or to stop, or the setup steps are given and the run has stopped.

4. **Build the request text from the surface IPA.** For each word, run
   `python3 tooling/lexicon.py surface <lang> <ipa>`, which applies the language's allophone rules
   in order and places stress by its `[stress]` rule, and write the output between forward slashes
   (for example /heˈβori/); for a sentence, each word's surface form in turn. The surface form goes
   in the request only, never back into the lexicon or the register. *Complete when:* every item's
   request text is built from the tool's output.

5. **State the cost and wait.** Count the characters of the request text exactly as it will be sent,
   and the number of calls. For a single word, mention the count in one line; for a batch, give the
   total and, if the author wants it, the balance from `mcp__elevenlabs__check_subscription`, then
   wait for a yes. *Complete when:* the author has seen the count and said yes.

6. **Generate.** Call `mcp__elevenlabs__text_to_speech` once per item with the text, the recorded
   voice, `model_id` and settings, and `output_directory` set to the **absolute** path of the
   language's audio folder, `world/src/languages/<lang>/audio/` under the repository root (resolve
   the root with `git rev-parse --show-toplevel`; create the folder if it is missing). Without it
   the server saves to its own base path or the desktop. Stop at the first error and report it,
   rather than retrying into spent credits. If the first item comes back read as letters rather than
   as sounds, stop: the IPA syntax needs checking against ElevenLabs' current guidance before
   anything more is spent. *Complete when:* each item has one file in the audio folder, or the first
   error is reported.

7. **Fall back to espeak-ng when ElevenLabs is unavailable.** Only if the author agrees and step 3
   found `espeak-ng` installed: map the surface IPA to espeak-ng's phoneme notation with the table
   in `pronunciation.md` (adding a missing symbol with the author), and write
   `espeak-ng -w <audio folder>/<headword>.wav "[[<phonemes>]]"`. Label the result approximate: good
   for checking stress and segment order, not for sharing. *Complete when:* each file exists and is
   labelled approximate.

8. **Name, listen and log.** Rename each file to `<headword>.mp3` (or `.wav`). The author listens; a
   wrong result is regenerated only on the author's word, or noted as a known fault of the voice,
   and the IPA stays as it is. For a read-aloud test of a new name, ask whether a reader would
   stumble on it, and report the answer to the naming procedure. Add a row to the log in
   `pronunciation.md`: date, words, character count, voice, notes. Audio is git-ignored (the rule
   is in `world/src/.gitignore`): never add it to Git, and never force it past the ignore rule.
   *Complete when:* the files are named, the author has listened and the log row exists.

9. **Hand back.** Report the files made, the characters spent, the voice and model used, and
   anything the voice got wrong. Confirm that no IPA was changed. *Complete when:* the author has
   the report.

## Anti-patterns

- **Generating unasked.** Every call spends the author's credits; a sample nobody requested is a
  cost nobody agreed.
- **Sending the phonemic IPA.** The lexicon records phonemes; the voice needs the surface form the
  tool produces, with allophones and stress.
- **Fixing the IPA to suit the voice.** The IPA is the record; a voice that cannot say it is a fault
  of the voice, noted in the log.
- **Omitting the model ID.** The server's default model is not the one the language's audio was
  recorded with.
- **Audio on the desktop.** Without the absolute `output_directory`, files land outside the project
  and its ignore rule.
- **A second narrator.** One language, one recorded voice.
- **Committing audio.** It is regenerable from the IPA and too large for plain Git.
- **Retrying on error.** Stop at the first failure and report it.
- **Offering a fallback that is not installed.** Check for `espeak-ng` before offering it; with
  neither route, give the setup steps and stop.

## Cross-references

- `world/src/languages/` — each language's `pronunciation.md` (narrator, settings, fallback table,
  log) and its audio folder, which `world/src/.gitignore` keeps out of Git.
- `world/docs/reference/pronunciation.md` — the guide this skill applies.
- `world/src/names-register.md` — the IPA of every registered name.
- `.claude/skills/add-word/SKILL.md` — a word's IPA, when it is missing.
- `.claude/skills/create-name/SKILL.md` — the read-it-aloud test this skill serves.
- `.claude/skills/build-language/SKILL.md` — the allophone and stress rules the surface form
  applies.
