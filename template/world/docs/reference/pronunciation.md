---
type: guide
skills: [pronounce]
model: opus
---

# Pronunciation — IPA first, surface IPA to the voice, audio on request

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** How a constructed word or name is said is recorded once, as phonemic IPA, in the
lexicon or the names register. Audio is derived from that IPA: useful for hearing a name before
committing to it, for the read-aloud test, or for briefing an audiobook narrator, but never the
record. If the audio and the IPA disagree, the audio is wrong.

## Phonemic IPA is stored; surface IPA is spoken

The lexicon holds phonemic IPA: no slashes or dots; no stress mark unless the language's stress
rule is lexical, in which case ˈ marks the stressed syllable. What a voice is given is the
**surface** form: the language's `[[allophone]]` rules applied in order and stress placed by its
`[stress]` rule, from `python3 tooling/lexicon.py surface <lang> <ipa>`. The surface form goes
into the request only; it is never written back. Never change the IPA to suit what a voice can
say.

## ElevenLabs, through the user-scope MCP server

- The server is configured once, at user scope, under the name `elevenlabs`; the project adds
  nothing to `.mcp.json`, so a collaborator without the server simply gets the fallback. Export
  the key in your shell (never type it on the command line or commit it), then run:

  ```bash
  claude mcp add --env ELEVENLABS_API_KEY="$ELEVENLABS_API_KEY" --transport stdio \
    --scope user elevenlabs -- uvx elevenlabs-mcp
  ```

- Find the Eleven v4 model with `mcp__elevenlabs__list_models`. Eleven v4 reads IPA written
  inline between forward slashes (/ˈheβo/). If a test word comes back read as letters, stop and
  check ElevenLabs' current guidance on IPA before spending more.
- **One voice and one model per language.** Choose the voice with the author
  (`mcp__elevenlabs__search_voices`); a second voice makes the language sound inconsistent.
- Record the voice, its ID, the model ID, the settings (Eleven v4 takes stability and
  similarity) and the date chosen in the language's `pronunciation.md`, and use exactly those
  on every call to `mcp__elevenlabs__text_to_speech`, with the language's audio folder as
  `output_directory` (the server otherwise saves to its own default place).

## Cost discipline

- **Never generate audio the author has not asked for**: not as a demonstration, not to test a
  setting, not because a word was added. Every call spends the author's credits.
- Before any batch, state the number of calls and the character count of the request text
  exactly as it will be sent, and wait for a yes; `mcp__elevenlabs__check_subscription` shows
  the balance. Trying voices costs credits too; say so before any trial.
- Stop at the first error and report it, rather than retrying into spent credits.

## The espeak-ng fallback

When ElevenLabs is unavailable and the author agrees, `espeak-ng` voices the IPA approximately.
Check it is installed first (`command -v espeak-ng`); with neither route, say so, give the
install hint (the system package `espeak-ng`) and the setup command above, and stop.
It takes phonemes in its own ASCII notation between double square brackets, so the surface IPA
is mapped first (keep the mapping table in the language's `pronunciation.md`), and `-w` writes a
WAV file. Expect a robotic voice that is good for stress and segment order, not for sharing;
label fallback files as approximate.

## How we apply it here

- Audio lives in the language's audio folder, named `<headword>.mp3` (or `.wav`), and
  `world/src/.gitignore` keeps every language's audio out of Git: it is regenerable from the
  IPA, and large binaries do not belong in plain Git.
- The author listens and judges; a wrong result is regenerated on the author's word, or noted.
- Names from a language are voiced with that language's voice, whichever character says them.

## Who implements it

- **Skill:** `pronounce`. **Workflow:** `world/workflows/09-record-a-pronunciation/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` owns who decides what, and the author decides
what is spent; `lexicon.toml` owns the IPA. This guide owns how audio is made from that IPA, and
at what cost.
