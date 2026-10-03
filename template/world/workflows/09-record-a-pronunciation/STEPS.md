---
workflow: 09-record-a-pronunciation
phase: produce
skills: [pronounce]
model: opus
---

# STEPS.md — record a pronunciation

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for making audio from IPA on the author's request. Each step names the
skill and guide it uses. **Run in order** (nothing is generated before the cost is stated and
agreed) and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The `pronounce`
> skill is this procedure in skill form.

## 1. Confirm the request

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Confirm that the author asked for audio, and for exactly what: which words, names or sentence,
from which language. If nothing was asked, stop. _Substantive._

## 2. Read the IPA

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Take each item's phonemic IPA from the language's `lexicon.toml` or from
`world/src/names-register.md`.
If an IPA is missing or doubtful, stop and route it to `world/workflows/07-add-a-word/` or
`world/workflows/03-name-something/`; never improvise one. _Mechanical._

## 3. Check the narrator, or choose one with the author

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

If the `elevenlabs` tools are absent, run `command -v espeak-ng`: if it finds the program, offer
the fallback at step 7, or stop. If neither route exists, say so, give the install hint (the
system package `espeak-ng`) and the server's setup command from
`world/docs/reference/pronunciation.md`, and stop.
Read the language's `pronunciation.md`. If a voice and model are recorded, use them. If not:
find the Eleven v4 model with `mcp__elevenlabs__list_models`, list candidate voices with
`mcp__elevenlabs__search_voices`, and let the author choose one voice. Record the voice, its ID,
the model ID, the settings (stability and similarity) and the date. Choosing a voice by
listening costs credits too; say so before any trial. _Substantive._

## 4. Build the request text from the surface IPA

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

For each item, turn the stored phonemic IPA into its surface form with
`python3 tooling/lexicon.py surface <lang> <ipa>` (the allophone rules applied in order, stress
placed by the `[stress]` rule), and write it between forward slashes (/ˈheβo/); for a sentence,
each word's surface form in turn. The surface form goes in the request only, never back into
the lexicon or the register. _Mechanical._

## 5. State the cost and wait

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Count the characters of the request text exactly as it will be sent, and the number of calls.
For a batch, give the total and, if the author wants it, the balance from
`mcp__elevenlabs__check_subscription`. Wait for a yes. _Mechanical._

## 6. Generate

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Call `mcp__elevenlabs__text_to_speech` once per item with the recorded voice, `model_id` and
settings, and the language's audio folder as `output_directory`. Stop at the first error and
report it, rather than retrying into spent credits. If the first item comes back read as letters
rather than sounds, stop: the IPA syntax needs checking before anything more is spent.
_Mechanical._

## 7. Fall back to espeak-ng when ElevenLabs is unavailable

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Only if the author agrees and step 3 found `espeak-ng` installed: map the surface IPA to
`espeak-ng` phoneme notation with the table in the language's `pronunciation.md` (adding to it
with the author where a symbol is missing), and write a WAV with `-w`. Label the result
approximate. _Mechanical._

## 8. Name, listen and log

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Rename each file to `<headword>.mp3` (or `.wav`). The author listens; a wrong result is
regenerated only on the author's word, or noted as a known fault of the voice. For a read-aloud
test of a new name, ask whether a reader would stumble on it, and report the answer to the
naming procedure. Add a log row to `pronunciation.md`: date, words, character count, voice,
notes. The audio stays out of Git (`world/src/.gitignore`); never force it in. _Substantive._

## 9. Hand back

> **Skill:** `pronounce` · **Guide:** `world/docs/reference/pronunciation.md`

Report the files made, the characters spent, the voice and model used, and anything the voice
got wrong. Confirm that no IPA was changed. _Substantive._
