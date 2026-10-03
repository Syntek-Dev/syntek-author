@./CONTEXT.md

# CLAUDE.md — world/workflows/09-record-a-pronunciation/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `world/CONTEXT.md` → `world/CLAUDE.md`
→ `world/workflows/CONTEXT.md` → `world/workflows/CLAUDE.md` → this folder's `CONTEXT.md`
(imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Let the author hear a constructed word as its IPA records it, with one consistent narrator per
language, at a cost the author has agreed.

## How to work here

- **Routing:** skill `pronounce`; guide `world/docs/reference/pronunciation.md`; tools
  `mcp__elevenlabs__list_models`, `mcp__elevenlabs__search_voices`,
  `mcp__elevenlabs__check_subscription` and `mcp__elevenlabs__text_to_speech` from the
  user-scope server `elevenlabs`; surface IPA from `python3 tooling/lexicon.py surface <lang> <ipa>`;
  fallback `espeak-ng`.
- **Model:** **Opus** for choosing a voice and judging a result with the author; the mechanical
  tier for building request text, counting characters and generating
  (`.claude/rules/syntek-author/05-model-allocation.md`). The checklist tags are authoritative.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go: confirm the
  request → read the IPA → check or choose the voice → build the request text from the surface
  IPA → state the cost and wait → generate → fall back if needed → name, listen and log → hand
  back.
- **Definition of done:** the audio the author asked for exists in the language's audio folder,
  made with the recorded narrator and model; the cost was stated before it was spent; the log
  row is written; the IPA is unchanged.

## Guardrails

- **Never generate unasked.** Not as a demonstration, not to check a setting, not because a new
  word was added. Every call spends credits.
- **State the character count before any batch, and wait for a yes.** Count the request text
  exactly as it will be sent.
- **One narrator per language.** Use the voice and model recorded in the language's
  `pronunciation.md`; changing either is the author's decision, recorded with the date.
- **The IPA is never changed to suit a voice.** If the result is wrong, regenerate or note it.
  The surface form is built for each request and never stored.
- **Audio is derived and git-ignored** (`world/src/.gitignore`). Never commit it, never force it
  past that rule, and never treat it as the record.
- **If the `elevenlabs` server is not configured, say so and offer the fallback** only when
  `command -v espeak-ng` finds it; with neither, give the setup steps in
  `world/docs/reference/pronunciation.md` and stop. The project adds nothing to `.mcp.json`; the
  server is configured at user scope, by the author.

## Output & naming

- **Produces:** `<headword>.mp3` (or `<headword>.wav` from the fallback) in the language's audio
  folder; a sentence is named for its first three headwords joined by hyphens.
- **Also writes:** the narrator record, the first time, and a log row in the language's
  `pronunciation.md`.
- **Does not touch:** the lexicon, the names register, or any IPA.
