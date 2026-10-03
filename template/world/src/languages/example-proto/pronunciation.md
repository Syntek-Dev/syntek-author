# pronunciation.md — Example Proto

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The recorded narrator and settings for this language's audio.
Example Proto is reconstructed and nobody in the book speaks it, so no audio is planned; this file is kept so that every language carries the same files.
If a reconstructed form is ever wanted aloud (for an author's own note on a word's history, say), the `pronounce` skill reads this file first and uses exactly what it records.

## Narrator

| Setting | Value |
|---|---|
| Service | ElevenLabs, through the user-scope MCP server `elevenlabs` |
| Voice | Not chosen |
| Voice ID | — |
| Model ID | Not recorded; find it with `mcp__elevenlabs__list_models` |
| Date chosen | — |

## Request text

A word is sent as its surface IPA between forward slashes, as `python3 tooling/lexicon.py surface example-proto <ipa>` prints it, with the stress mark the penultimate rule places: fepom is sent as /ˈfepom/, mipika as /miˈpika/.

## Fallback

When ElevenLabs is unavailable, `espeak-ng` gives an approximate voice for checking stress and segment order; record its phoneme mapping here when it is first used.

| IPA | espeak-ng phoneme |
|---|---|

## Log

| Date | Words | Characters | Voice | Notes |
|---|---|---|---|---|
