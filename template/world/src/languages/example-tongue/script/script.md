# script.md — the Example Tongue script

**Type:** alphabet · **Direction:** left to right, in horizontal lines · **Letters drawn:** 16, and one positional form

## How it works

Every letter is a short run of a horizontal stem with cuts made against it, and the stem runs from edge to edge, so the letters of a word join into one unbroken line.
A space breaks the stem, so a word is a single carved stroke with its marks.
What a letter says is decided by where its cuts fall and how many there are:

| Family | The cuts | Letters, by number of cuts |
|---|---|---|
| vowels | notches across the stem | o 1 · a 2 · e 3 · i 4 · u 5 |
| voiceless stops | upright cuts above | k 1 · p 2 · (t 3) · qu 4 |
| voiced stops | upright cuts below | b 1 · d 2 · g 3 |
| fricatives | cuts slanting up and forward above | h 1 · f 2 · (s 3) |
| nasals and liquids | cuts slanting down and forward below | r 1 · l 2 · m 3 · (n 4) |

Letters in brackets are planned but not drawn, because no word yet needs them; w and y have no place yet.
A voiced stop hangs below the line under the place of its voiceless partner, so b sits under k's single cut and d under p's two.
The commonest sounds take the fewest cuts, because every cut is work with a knife.

## Positional forms

One letter has a second shape: o at the end of a word closes the stem with a short upright bar.
Most of the language's words end in o, after the changes that turned *-om and *-u into -o, so the closing bar marks the end of most words and makes a run of carving easy to divide.
The bar is a form, not a letter: `glyphs.toml` records it under o's `forms`, and the font chooses it by position.

## The grid

The glyphs are drawn on a 1,000-unit em: the baseline at y 800 in each SVG, the stem from y 470 to 530, cuts above reaching y 250 (slanting ones y 270), cuts below reaching y 750 (slanting ones y 730), and notches from y 400 to 600.
A cut is 60 units wide with 60 between cuts, and 80 units of stem at either side, so each letter's width follows from its number of cuts.
Every glyph is one filled outline: the stem and its cuts traced as a single shape, never strokes, so the same file serves the composed sample and the font.

## Inspiration

The structure comes from ogham, the early script of Ireland and Britain whose letters are one to five strokes or notches set against a stem line, in families by where the strokes fall (`research/src/setting/example-model-ogham.md`).
It takes that structure and the short, straight knife-cut style; it takes none of ogham's letters, its families or its counts, and it runs along a flat face rather than up the edge of a stone.
`glyphs.toml` records the choice in `[meta.inspiration]`.

## History

The ford-keepers cut marks into the alder posts that stand on either bank of each ford, with the short knife every adult carries (see the culture file).
A knife in wet wood will not make a loop, so every cut is short and straight, and the post's face gives the long stem.
The script was made by the river folk themselves, which is why `origin` is native: it was never borrowed from a neighbour.
This history is an invention for the example; a real project ties its script to the culture file of the people who write it.

## Design principles

- The stem is unbroken within a word and broken between words, so word division needs no extra mark.
- A letter is read by counting, so no two letters in one family differ by shape alone.
- Cuts are short and straight; nothing is closed into a loop.
- No ceremonial hand yet.

## The font

`make font` compiles the glyphs into `build/fonts/example-tongue.otf`, giving each letter a Private Use Area code point from U+E000 in the order of `glyphs.toml` (no code point is pinned yet), and a contextual-alternates rule that puts the closing bar on a final o.
`python3 tooling/script.py transliterate example-tongue "<word>" --pua` prints the same code points, which is how native-script words reach a typeset page.
