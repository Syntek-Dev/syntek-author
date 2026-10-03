---
type: guide
skills: [typeset, design-script, add-word, build]
model: opus
---

# Constructed languages in print — romanised italic or the native script

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** A word in one of the book's invented languages is marked in the Markdown with its
language, so the page can set it the way the book has chosen: in the romanised spelling, in
italic, as most novels do, or in the language's own script, from a font the project builds.

## The two marks

| Markdown | In print | Elsewhere |
|---|---|---|
| `[hebori]{.conlang lang=example-tongue}` | `\conlang[example-tongue]{hebori}`: romanised, italic | italic |
| `[hebori]{.conlang-native lang=example-tongue}` | `\conlangnative[…][hebori]{…}`: the native script | italic, romanised |

`lang=` is the language's folder name under `world/src/languages/`. The Markdown always holds the
romanised headword from the lexicon, so the word is searchable, checkable and spelt one way.

## Where the native script comes from

- `tooling/script.py transliterate <slug> --pua -- <word>` turns the romanised word into the
  font's Private Use Area characters, by the transliteration rules in the language's
  `script/glyphs.toml`. The filter calls it for every native-script word.
- `make font LANG=<slug>` builds `build/fonts/<slug>.otf` from the glyph SVGs; `make print`
  builds every script's font first, one language at a time. A font that fails to build is
  reported and the print goes on, with that language's font from an earlier build if there is
  one. Fonts are generated, never committed.
- With no font, or a letter the script cannot yet write, the word prints in romanised italic and
  the print or the filter says why. Nothing fails silently.

## Right-to-left and vertical scripts

`\conlangnative` sets a word's glyphs in logical order, left to right, whatever `direction` the
script's `glyphs.toml` declares: print has no right-to-left or top-to-bottom setting yet.

- Check every native-script word of an `rtl` or `ttb` script in the proof; a word that reads in
  the wrong direction is wrong, however clean it looks.
- Until print supports the direction, set such words in romanised italic (`.conlang`), or place
  an image of the word (`make script-sample` draws one in the script's direction) by hand where
  the author says.

## Restraint on the page

- Most readers meet a constructed language one word at a time. `make lint` reports any paragraph
  with more than three unglossed conlang words; take that to the author, never cut by yourself.
- Native script is for moments the story earns: an inscription, a sign, a name on a seal. A
  paragraph in an unreadable script is a paragraph the reader skips.
- A glossary and pronunciation guide (`make glossary`) can go in the back matter, if the author
  wants one; it is generated, so regenerate it rather than editing the copy.

## How we apply it here

- Use the lexicon's headword, exactly; `make lexicon` and `make tex-check` both notice a stray
  spelling.
- The fidelity check compares the native-script characters on both sides, so a word whose glyphs
  changed in `glyphs.toml` must be re-typeset.
- Read every native-script word in the proof. A glyph the font lacks prints as nothing, not as a
  box: `make print` counts every missing character and shows the first, and a `final` print
  stops on one.

## Who implements it

- **Skills:** `typeset` sets the words; `design-script` makes the glyphs and the font;
  `add-word` fixes the headword.
- **Workflows:** `typeset/workflows/02-typeset-a-chapter/`, `world/workflows/08-design-a-script/`.

## Governing standard

`world/docs/reference/building-a-language.md` owns the method, including restraint on the page;
`world/docs/reference/writing-systems.md` owns the script and its transliteration. They own the
rules; this guide owns how the words reach the printed page.
