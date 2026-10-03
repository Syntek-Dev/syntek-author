---
workflow: 09-record-a-pronunciation
phase: produce
skills: [pronounce]
model: opus
---

# CHECKLIST.md — record a pronunciation

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `world/docs/reference/pronunciation.md` and the `pronounce` skill. Gates cite
> `standards/verification/verification.md` by number; this list never restates them.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] **The author asked for this audio, and the items are confirmed.** · _opus_
- [ ] Every item's phonemic IPA found in the lexicon or the names register; any missing or doubtful IPA routed, not improvised. · _sonnet_

## Execution Checklist

**The narrator**

- [ ] With no `elevenlabs` tools, `command -v espeak-ng` run; with neither route, the install hint and setup command given and the run stopped. · _sonnet_
- [ ] The language's `pronunciation.md` read; the recorded voice and model used if present. · _sonnet_
- [ ] If none was recorded: Eleven v4 model found with `mcp__elevenlabs__list_models`, voices listed, one chosen by the author. · _opus_
- [ ] Voice, voice ID, model ID, settings (stability, similarity) and date recorded in `pronunciation.md`. · _sonnet_

**Cost**

- [ ] Request text built from the surface IPA (`lexicon.py surface`), between slashes, in the request only. · _sonnet_
- [ ] Character count and number of calls stated before generating; balance given if asked. · _sonnet_
- [ ] The author said yes. · _opus_

**Generating**

- [ ] `mcp__elevenlabs__text_to_speech` called with the recorded voice, `model_id` and settings, and the language's audio folder as `output_directory`. · _sonnet_
- [ ] Stopped and reported at the first error, or at a first item read as letters, instead of retrying. · _sonnet_
- [ ] Fallback used only with the author's agreement and `espeak-ng` installed, mapped through the language's table, labelled approximate. · _sonnet_
- [ ] Files renamed to `<headword>.mp3` (or `.wav`). · _sonnet_
- [ ] The author listened; regeneration only on the author's word; a read-aloud verdict reported to the naming procedure. · _opus_
- [ ] Log row added: date, words, characters, voice, notes. · _sonnet_

## Done When

- [ ] **No IPA was changed, and nothing was generated beyond what the author agreed.** · _opus_
- [ ] The audio sits in the audio folder `world/src/.gitignore` ignores, and nothing generated was committed. · _sonnet_
- [ ] Handed back: files, characters spent, voice and model, faults heard. · _opus_
