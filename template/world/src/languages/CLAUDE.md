@./CONTEXT.md

# CLAUDE.md — world/src/languages/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/src/CONTEXT.md` → `world/src/CLAUDE.md` → this folder's `CONTEXT.md` (imported
above) → this file → the target language's pair.

## Purpose (one line)

Keep each constructed language consistent with itself and its family, so that every word, name
and glyph in the book could have come from the same people and the same history.

## How to work here

- **Routing:** `build-language` for the speakers, models, sound system, history and grammar
  (`world/workflows/06-build-a-language/`); `add-word` for vocabulary
  (`world/workflows/07-add-a-word/`); `design-script` for the writing system and its font
  (`world/workflows/08-design-a-script/`); `pronounce` for audio
  (`world/workflows/09-record-a-pronunciation/`).
- **Model:** **Opus** for every design decision and every coined word; the mechanical tier for
  running `make lexicon`, `make derive`, `make coverage`, `make family`, `make glossary`,
  `make font` and `make script-sample` (`.claude/rules/syntek-author/05-model-allocation.md`).
- **Concrete steps:**
  1. Read the language's `language.toml`, `phonology.toml` and `lexicon.toml` (and a daughter's
     `sound-changes.toml` and its parent) before changing any of them; they constrain each other.
  2. Change one subsystem at a time, with the author's approval.
  3. Run `make lexicon` after every change to a data file, and `make derive` after any change to
     a parent, a daughter or its rules; fix what fails before anything else uses it.
- **Definition of done:** `make lexicon` and `make derive` pass, every headword transliterates
  through the glyph table, and every word or name the book uses is registered.

## Guardrails

- **IPA is canonical.** The lexicon's IPA is the record; spelling follows from it through the
  romanisation map, and audio follows from its surface form on request.
- **Every real-world claim is cited.** A model language or script is researched with `research`
  and noted in `research/src/setting/` before it is recorded, never asserted from memory.
- **Words in promoted prose are frozen.** A sound change or spelling rule that would alter one
  is a change to the book: list the words and the sections that use them for the author first.
- **Never generate audio unasked.** Every call spends credits; state the character count
  before any batch and wait for the author's word.
- **Data files are written for the tooling.** Keep the TOML schemas exactly; a renamed key
  breaks the checks silently or loudly, and either way the checks stop protecting you.
- **Never overwrite a language file** without confirming with the author.

## Output & naming

- **Hand-written:** one folder per language, named for its slug (kebab-case, matching `slug` in
  its `language.toml` and `lexicon.toml`), with the layout shown in this folder's `CONTEXT.md`.
- **Each language's `pronunciation.md`** starts from this skeleton, one sentence per line, with
  no voice chosen; `pronounce` fills the narrator, the fallback table and the log:

```markdown
# pronunciation.md — <language name>

The recorded narrator for this language's audio; the IPA in `lexicon.toml` is the record.

## Narrator

| Setting | Value |
|---|---|
| Service | ElevenLabs, through the user-scope MCP server `elevenlabs` |
| Voice | Not chosen yet |
| Voice ID | — |
| Model ID | Not recorded yet; find it with `mcp__elevenlabs__list_models` |
| Stability | — |
| Similarity | — |
| Speed | — |
| Output format | — |
| Date chosen | — |

## Request text

Each word is sent as its surface IPA between slashes, from `python3 tooling/lexicon.py surface`.

| Word | Phonemic | Sent as |
|---|---|---|

## Fallback

| IPA | espeak-ng phoneme |
|---|---|

## Log

| Date | Words | Characters | Voice | Notes |
|---|---|---|---|---|
```

- **Generated (never hand-edit):** each language's audio folder, which `world/src/.gitignore`
  keeps out of Git, and the glossary, font and script samples written into the build folder.
