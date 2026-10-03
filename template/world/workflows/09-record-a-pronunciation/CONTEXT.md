# CONTEXT.md — world/workflows/09-record-a-pronunciation/

The procedure for making audio of a constructed word, name or sample sentence from its IPA, on
the author's request. The stored phonemic IPA is turned into its surface form (allophones and
stress applied), then voiced through ElevenLabs (the user-scope MCP server `elevenlabs`, Eleven
v4 reading IPA between slashes, the language's recorded voice and model), or approximately
through `espeak-ng` when ElevenLabs is unavailable. It states the cost before spending anything,
and saves the audio, git-ignored, beside the language.

## Directory Tree

```text
world/workflows/09-record-a-pronunciation/
├── CHECKLIST.md        ← model-tagged checklist; tick it as you go
├── CLAUDE.md           ← operating rules for this procedure
├── CONTEXT.md          ← this file: when to use it, what it produces
└── STEPS.md            ← the ordered steps, each naming its skill and guide
```

## When to use this

- The author asks to hear a word, a name or a sentence before committing to it, including the
  read-aloud test of a new name.
- The author wants reference audio for an audiobook narrator.
- The author asks for a batch (every name in a chapter, the whole lexicon).

Never run it unasked. Reach for a **different** procedure when the IPA itself is missing or in
doubt: fix the word first (`world/workflows/07-add-a-word/`) or the name
(`world/workflows/03-name-something/`).

## What it produces, and where

- **Audio files** in the language's audio folder, named `<headword>.mp3` (`.wav` from the
  fallback). `world/src/.gitignore` ignores the folder: the files are regenerable from the IPA.
- **A voice record** in the language's `pronunciation.md` the first time: voice, voice ID,
  model ID, settings (stability, similarity), date chosen.
- **A log row** in the same file: date, words, character count, voice, anything it got wrong.

## Two things this procedure will never do

Spend the author's credits without a yes, and change the IPA to suit a voice. Every call costs
credits, so a batch is costed in characters and waits for the author's word. And the IPA is the
record: if a voice cannot say a sound, the audio is wrong, not the word.

## Cross-references

- `world/docs/reference/pronunciation.md` — IPA first; ElevenLabs; credits; the fallback.
- `world/src/languages/` — where each language's audio folder and `pronunciation.md` sit.
- `world/src/names-register.md` — the IPA of every name.
