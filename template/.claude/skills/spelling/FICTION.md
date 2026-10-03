# FICTION.md — spelling in a novel

A novel invents words: the names of its people and places, and, where the book has a constructed
language, whole vocabularies. A dictionary knows none of them, so the spelling pass reads the story
bible as its dictionary and reports the near-misses that a reader would notice first.

## Paths and unit

- **The unit** is a chapter: `manuscript/src/NN-kebab-title/NN-kebab-title.md`, with section drafts
  in its `drafts/` folder.
- **The pass** is step 10 of `manuscript/workflows/05-review-a-chapter/`.
- **The project's own words:** every name in `world/src/names-register.md`; the narration's fixed
  terms (titles, offices, technologies) in `standards/style/terminology.md`; and, where the
  conlang kit is installed, every headword in each language's `lexicon.toml`, in the languages
  folder under world/src/.
- **Extra reads:** each point-of-view character's voice markers in `world/src/characters/`, which
  record dialect and a character's own spellings; `world/docs/reference/naming.md`.
- **Where corrections go:** an accepted spelling correction may be applied in the chapter file
  directly, logged as a row in that section's ledger entry
  (`manuscript/workflows/05-review-a-chapter/`, 'Applying agreed fixes'); in a draft, in the draft.

## Additions to the steps

- **Step 2 — also add to the known words:** every name in the register's Name column, each word of
  a name of several words, with its plural and possessive forms; every name marked retired, kept on
  a separate list so that a stray use is reported as 'retired name'; and, where the conlang kit is
  installed, every `headword` and every form in each word's `derived` list. With the kit, run
  `make lexicon` first: a lexicon with errors gives a wrong list, and its errors are reported to the author before
  this pass trusts it.
- **Step 3 — also:** dialogue and close narration keep a dialect spelling or a character's own
  misspelling when the voice markers record it; an invented word keeps its lexicon spelling,
  diacritics included; a name's spelling comes only from the register.
- **Step 4 — how near-misses are found:** take every capitalised word that is not the first word of
  a sentence, and every word not in an en_GB dictionary; drop those on the known list; compare each
  of the rest with every known word by edit distance (distance 1 always; distance 2 when both words
  have five letters or more). This is the same measure the conlang kit's lexicon tool uses to
  report look-alike names inside the register (tooling/lexicon.py names, run by `make lexicon`);
  where that tool's density check is available, it lists the invented words it recognises in a
  passage, which narrows the candidates. Without the conlang kit, the register is the whole list.
- **Step 5 — also:** a capitalised word that is near no known word may be a new name. It is not a
  spelling error: report it as unregistered and hand it to `create-name`, because names are never
  coined in passing (`.claude/rules/syntek-author/03-authorship.md` Section 7).

## Domain rules

- **The register and the lexicons beat any dictionary.** A word in either is spelt as it is there,
  whatever a spell-checker suggests.
- **Never correct an invented word into an English one,** or into another invented word. Report the
  near-miss and let the author choose.
- **A wrong spelling in the register is the author's to change,** in the register; a change of a
  name's spelling across the book is a continuity decision (`continuity`), never a spelling sweep.
- **Dialect is voice.** A non-standard spelling in dialogue is reported only when the voice markers
  do not record it, and then as a question.

## Examples

> **'Marren' → 'Maren'?** Edit distance 1 from the register's 'Maren'. Three places: `opening`
> lines 2 and 9; `the-turn` line 4.

> **'heborri' → 'hebori'?** Edit distance 1 from a headword in the example language's lexicon
> (only where the conlang kit is installed). One place: `the-turn` line 12.

> **Unregistered.** 'Corran' is near no registered name. A new name, or a slip? If new, it goes
> through `create-name` before the chapter moves on.

> **Not reported.** A character's 'summat' in dialogue, recorded in that character's voice markers.
