# numerals-and-punctuation.md — Example Tongue

Numerals, punctuation and diacritics for the Example Tongue script.
None is designed yet: the book has not needed a number or a written sentence in the script.
This file records the interim rules and the decisions still to make, so that nothing is improvised on the page.

## Interim rules

- A word is one unbroken stem; a break in the stem divides words, so no divider is needed.
- `tooling/script.py` passes a space through unchanged, and the font gives the space half the default letter width.
- Romanised prose uses ordinary English punctuation; a hyphen in a romanised form (the suffix -ri) passes through untouched.
- No number is written in the native script; prose writes numbers in English.

## Decisions to make

- The base of counting: the culture tolls carts and cattle at the fords, so a tally-like count (one notch per unit, a longer cut for each five) would fit how the people already mark posts.
- Whether numbers have their own signs or are tallied on the stem itself.
- A mark for the end of a sentence, if the posts ever carry more than names and tolls.
- Whether names are marked, for example by a cut across both ends of the stem.

Each decision, once made with the author, gets its glyph entries in `glyphs.toml`, its SVGs, and a line in `transliteration.md`.
