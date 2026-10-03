# transliteration.md — Example Tongue

The rules for moving between the three forms of every word: IPA, the romanised spelling used in prose, and the native script.
These rules are the single source of truth for romanised spellings; `phonology.toml` and `glyphs.toml` are their executable form.

## IPA to romanised spelling

Spell each IPA symbol as itself, except kʷ, which is spelled qu, and j, which is spelled y (the `[romanisation]` table in `phonology.toml`).
Stress is not written; it falls on the second-to-last syllable.
The surface sounds [β ð ɣ] are not written either: they are how b, d and g sound between vowels, and the spelling records the phoneme.

| IPA | Romanised |
|---|---|
| kʷ | qu |
| j | y |
| every other symbol | itself |

## Romanised spelling to IPA

Read qu as kʷ, y as j, and every other letter as itself.
The language has no q except in qu, so qu is never ambiguous.

## Romanised spelling to native script

Read the romanised word from left to right, and at each point take the longest letter in `glyphs.toml` that matches its `romanisation`; that is the next letter written.
So qu is one letter, never q and then u, and quaru is written qu · a · r · u.
If no letter matches, the word cannot yet be written natively, and the missing letter is reported, not invented.
A hyphen or other punctuation passes through unchanged, so the suffix -ri is written as a hyphen and r · i.

| Romanised | Letters | Notes |
|---|---|---|
| quaro | qu · a · r · o | o takes its final form |
| quaru | qu · a · r · u | |
| mibo | m · i · b · o | o takes its final form |
| mibiga | m · i · b · i · g · a | |
| hebo | h · e · b · o | o takes its final form |
| hebado | h · e · b · a · d · o | o takes its final form |
| hepom | h · e · p · o · m | o inside the word keeps its plain form |
| kelo | k · e · l · o | o takes its final form |
| mipfebo | m · i · p · f · e · b · o | o takes its final form |
| -ri | - r · i | |
| hebori | h · e · b · o · r · i | |

`python3 tooling/script.py transliterate example-tongue "hebo"` applies the same rule; with `--pua` it prints the Private Use Area characters the font draws, and `make script-sample` renders a sample.

## Native script to romanised spelling

Write each letter's romanisation in order, with no separator inside a word.
A break in the stem is a space in the romanised text, and a closing bar is read as o.

## Positional forms

A final o (one followed by no letter of the script) is drawn with the closing bar; every other o is plain.
In a font the choice is made by the contextual-alternates rule `make font` writes, so the text itself never changes: the code point is always o's.

## Rules not yet made

The letters t, s and n are planned but not drawn, and w and y have no place in the families yet (see `script.md`).
When one is needed, its rule is added here first, then its glyph, then every headword is checked again.
