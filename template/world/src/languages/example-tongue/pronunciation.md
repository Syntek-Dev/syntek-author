# pronunciation.md — Example Tongue

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The recorded narrator and settings for this language's audio.
The IPA in `lexicon.toml` is the record; audio is derived from it only when the author asks, and lives in this language's audio folder, which Git ignores.
The `pronounce` skill reads this file before every call and uses exactly what it records.

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

No voice has been chosen, so no audio has been made.
Choose one voice with the author, record it here with the date, and keep it for every word: a second narrator makes one language sound like two.

## Request text

Each word is sent as its surface IPA between forward slashes: the phonemic IPA from the lexicon with the allophones applied and the stress mark placed, exactly as `python3 tooling/lexicon.py surface example-tongue <word> --headword` prints it.

| Word | Phonemic | Sent as |
|---|---|---|
| hebo | hebo | /ˈheβo/ |
| hebado | hebado | /heˈβaðo/ |
| mibiga | mibiga | /miˈβiɣa/ |
| quaru | kʷaru | /ˈkʷaru/ |

A sentence is sent as the surface IPA of each word in turn.

## Fallback

When ElevenLabs is unavailable, `espeak-ng` gives an approximate voice for checking stress and segment order.
It takes its own ASCII phoneme notation, so each IPA symbol needs a mapping; record the mapping here when the fallback is first used.

| IPA | espeak-ng phoneme |
|---|---|

## Log

Record each batch: date, words, character count, voice, and anything the voice got wrong.

| Date | Words | Characters | Voice | Notes |
|---|---|---|---|---|
