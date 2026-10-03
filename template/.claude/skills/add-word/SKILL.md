---
name: add-word
description: >-
  Coin one word (or a small listed batch) for a constructed language and append it to its
  lexicon.toml: built from existing roots, affixes or compounds first, with a new root only
  when none fits; phonemic IPA and a romanised headword; senses that need not map one-to-one to
  English; an etymology from root through sound-shifted form to semantic drift; its stratum and
  where it entered the language's history; a borrowed word adapted to the sound rules; any
  deliberate echo of a real word verified and cited; a false-friend check for prominent words;
  the native spelling; then validated with make lexicon and, for a daughter, make derive. Use
  when the author says 'I need a word for "ford"', 'what is "river" in the hill tongue?', 'coin
  a word for oath-breaker', 'add these five words', 'borrow a word from the coast language', or
  'derive this from the proto-root'. Not the sound system or grammar (`build-language`), not a
  character or place name (`create-name`), not a glyph (`design-script`), not audio
  (`pronounce`).
---

# Skill: Add a word (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A word that feels as if it belongs comes from somewhere: a root the language already has, an affix
it already uses, a sound change it has already been through, a neighbour it borrowed from at a point
in its history. This skill coins words that way and records each one in full, the way a reference is
added to a bibliography: searched for first, built from what exists, checked, then appended once and
never overwritten. The author approves every coinage.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`. These
are the procedure of record — do not restate them at length here.

- `world/workflows/07-add-a-word/` — this skill is that procedure in skill form; its steps and these
  are numbered alike.
- If the layer's `workflows/local/` holds a folder with the same `NN-name` as the procedure above,
  follow that procedure instead: the author's local procedure replaces the template's
  (`run-workflow`, step 2).
- `world/docs/reference/lexicon-format.md` — every `[[word]]` field and what the checks test.
- `world/docs/reference/building-a-language.md` — the conlang method: rules 14 to 17 and 19 govern
  how a word is built, dated, borrowed and allowed to be irregular.
- `world/docs/reference/naming.md` — when the word is also a name.
- `standards/risk/FICTION.md` — rule 7: real languages lend their sound, never their words.

## How to add a word

1. **State the need.** The meaning in English and the senses it should cover, the part of speech,
   who says it and in what register, where in the book it is needed, and whether it will be
   prominent (a title, a repeated word, a name). For a batch, the full list, confirmed with the
   author before any word is coined. *Complete when:* the author has confirmed each word's need.

2. **Search the lexicon first.** Read the language's `lexicon.toml`: every entry's `senses`, and the
   roots and affixes (entries with `pos = "root"` or `"affix"`), with `grammar.md` for its living
   affixes and compounding rules. If the language has the word, or can build it from an existing one
   with a living affix or a compound, offer that first. *Complete when:* the search result is
   reported: an existing word, a derivation from one, or nothing that fits.

3. **Place the word in the language's history.** Open with the model: which of the language's
   `[[inspiration]]` models, and which period, gives the word its flavour, and whether a deliberate
   echo of a real word is wanted. Then its `stratum` (`inherited`, `early-loan`, `late-loan`,
   `coinage`) and, for a daughter, `entered_after`: the index of the last sound-change rule the word
   did not undergo (0 for an inherited word, which undergoes them all), tied to an era in
   `world/src/history/eras.md` or to an event whose `## Linguistic consequences` records the
   contact. A loan names `loan_from` (the source language's slug) and `loan_source` (its form
   there). Each question carries a recommended answer with its reason. *Complete when:* the model,
   stratum, entry point and any loan source are agreed with the author.

4. **Build the word.** Roots, affixes and compounds first; propose a new root (an entry with
   `pos = "root"`) only when none fits, and wait for the author's approval of it. In a daughter,
   start from the `proto_form` and apply the rules of `sound-changes.toml` after `entered_after`, in
   order, showing each stage. A loan is reshaped to the borrowing language's phonotactics. Record
   the etymology as root, then sound-shifted form, then semantic drift (`drift`), and give `senses`
   that do not map one-to-one onto English: say what the word covers that English splits, or splits
   that English covers. Mark `irregular = true` only with a note saying why. Offer two or three
   candidates where the derivation allows a choice. *Complete when:* the author has chosen a
   candidate and its derivation is written stage by stage.

5. **Check echoes and false friends.** A deliberate echo is verified with the `research` skill (the
   real word, its meaning, the source, in a note in `research/src/setting/`) before it is written
   into `echo`, never from memory. For every prominent word, check the candidates for unintended
   meanings in each model language and in English, slang included, the same way. A check that cannot
   be completed yet is reported, and the word stays out of prominent use until it is. A living,
   minority or sacred language's words are never lifted; flag the case under rule 7 of the fiction
   risk standard. *Complete when:* every echo is cited and every prominent word's check is done or
   reported open.

6. **Fix the IPA and the spelling.** Write the phonemic IPA (no slashes or dots; no stress mark
   unless the language's stress rule is lexical, in which case ˈ marks the stressed syllable) and
   spell it through `[romanisation]` in `phonology.toml`; that spelling is the headword. Read its
   surface form from `python3 tooling/lexicon.py surface <lang> <ipa>` and say it aloud for the
   author. Add a reader respelling to `notes` where the stress or a sound will surprise an English
   reader. *Complete when:* the IPA fits the phonotactics, the headword is its romanisation, and the
   author has heard it said.

7. **Check the native spelling.** If the language has a script, run
   `python3 tooling/script.py transliterate <lang> "<headword>"`. If a unit is missing, record it
   for the hand-back and route the glyph to `design-script`; never draw one here. Leave `native`
   empty: the tooling derives it. *Complete when:* the word transliterates, or the missing units are
   listed.

8. **Append the entry.** Check the headword is not already in the file. Append one `[[word]]` at the
   end of `lexicon.toml` with every key present, empty where it does not apply: `headword`, `ipa`,
   `pos`, `senses`, `concept` (the core-concept key it fills, if any), `roots`, `affixes`,
   `compound_of`, `proto_form`, `drift`, `loan_from`, `loan_source`, `irregular`, `stratum`,
   `entered_after`, `echo`, `derived`, `native`, `first_used`, `notes`. Add the new headword to the
   `derived` list of each word it was formed from. Never reorder or overwrite an entry.
   *Complete when:* the entry is appended with every key, and its source words list it.

9. **Run the checks.** Run `make lexicon LANG=<slug>`; for a daughter, also
   `make derive LANG=<slug>`, which reports any entry whose IPA differs from its derivation unless
   it is marked irregular; where the word fills a core concept, `make coverage LANG=<slug>` shows it
   filled. Fix any failure in the new entry before anything uses it; report a failure in an older
   entry rather than fixing it in passing. *Complete when:* the checks report no error in the new
   entry.

10. **Register it, if it is a name.** When the word is used as a name, add its row to
    `world/src/names-register.md` by the steps of `create-name`, with this language's slug in the
    Language column and the main sense as the Meaning. *Complete when:* the row exists, or the word
    is not a name.

11. **Hand back.** Report the headword, IPA, respelling, senses and history (stratum, entry point,
    derivation, drift); any echo and its source; any open false-friend check; the native spelling or
    the missing glyph; any new root awaiting approval; and the checks' results. *Complete when:* the
    author has the report.

## Anti-patterns

- **Inventing before searching.** A fresh root for a meaning the language can already build makes
  the vocabulary feel unrelated.
- **A word with no history.** Without stratum and entry point, a daughter's derivation cannot be
  checked and the word cannot be told from a mistake.
- **English in disguise.** One sense per English word, mapped one-to-one, makes a cipher, not a
  language.
- **An echo from memory.** 'This sounds like the Old Norse for wind' is a claim; verify and cite it,
  or drop it.
- **Unadapted loans.** A borrowed word keeps sounds the borrowing language does not have only with a
  documented exception.
- **Hand-made irregularity.** `irregular = true` without a note hides an error rather than recording
  a choice.
- **Drawing a glyph here.** A missing glyph is routed to the script procedure.
- **Overwriting or reordering entries.** The file is append-only; a word used in promoted prose is
  retired in `notes` with the date, never deleted.

## Cross-references

- `world/src/languages/` — each language's `lexicon.toml`, `phonology.toml` and
  `sound-changes.toml`.
- `world/docs/reference/lexicon-format.md` — the entry schema.
- `research/src/setting/` — the cited notes behind every echo and false-friend check.
- `.claude/skills/build-language/SKILL.md` — the sound system, grammar and core lexicon.
- `.claude/skills/design-script/SKILL.md` — a glyph the word needs.
- `.claude/skills/create-name/SKILL.md` — registers the word when it is a name.
- `.claude/skills/pronounce/SKILL.md` — hearing the word voiced, on request.
- `.claude/skills/research/SKILL.md` — verifying an echo or a false friend.
