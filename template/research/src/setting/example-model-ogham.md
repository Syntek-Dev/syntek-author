---
subject: "Ogham, as the model for the Example Tongue script"
period: "Orthodox ogham inscriptions, about the fourth to the sixth centuries AD"
serves: []               # no chapter: it serves world/src/languages/example-tongue/script
checked: 03/10/2026
---

# Ogham, as the model for the Example Tongue script

> **An invented example's research note, seeded once when this project was generated.**
> It shows what `design-script` files before a real script family is recorded in `glyphs.toml` `[meta.inspiration]`: only the claims the script relies on, each with its source.
> Delete it with the example languages; `copier update` never brings it back.

## What is true

Ogham is a script of Ireland and Britain (OG(H)AM project), and its early inscriptions record mainly Primitive Irish (Ferrari 2018).
The alphabet originally had twenty letters in four groups (aicmí) of five (Ferrari 2018).
On standing stones the edge of the stone served as the stem line, and an inscription was cut along the edges, beginning at the bottom (Ferrari 2018).
The points below are leads, not citations: each comes from Wikipedia alone, so its verdict is `thin` until a cited source confirms it.
The earliest inscriptions date to about the fourth century AD, and the classical inscriptions flourished in the fifth and sixth centuries (lead: Wikipedia). <!-- VERIFY: the dates; confirm in McManus (1991) or the OG(H)AM database. -->
Each letter is one to five strokes or notches set against a stem line; the groups differ by where the strokes fall: to one side of the line, to the other, slanting across it, or as notches on it (lead: Wikipedia). <!-- VERIFY: the stroke counts and the four placements; confirm in McManus (1991). -->

## Sources

- Ferrari, J. (2018) 'Ancient scripts: Ogham – Old Irish inscriptions', *Taylor Institution Library blog*, 19 February. Oxford: Bodleian Libraries. Available at: https://blogs.bodleian.ox.ac.uk/taylorian/2018/02/19/ancient-scripts-ogham-old-irish-inscriptions/ (accessed 03/10/2026). It cites McManus, D. (1991) *A guide to Ogam*. Maynooth.
- OG(H)AM project (2021–2025) *Ogham in 3D and the OG(H)AM database*. University of Glasgow and Maynooth University, hosted by the Dublin Institute for Advanced Studies. Available at: https://ogham.celt.dias.ie/ (accessed 03/10/2026).
- Lead, not a citation: Wikipedia (no date) 'Ogham'. Available at: https://en.wikipedia.org/wiki/Ogham (accessed 03/10/2026). The source of the dates and the stroke placements above, until McManus (1991) confirms them.

## Departures

The Example Tongue script takes ogham's structure (each letter a count of cuts against a running stem, the letters in families by where the cuts fall) and its stroke style (short, straight cuts suited to a blade).
It takes none of ogham's letters: its families are its own (voiceless stops above, voiced stops below, fricatives slanting above, nasals and liquids slanting below, vowels as notches), the counts are its own, and the commonest sounds take the fewest cuts.
It is written left to right in horizontal lines, not up the edge of a stone, because its first surfaces were the flat faces of ford posts.
None of these departures touches the book's prose, so none is logged in `planning/src/continuity.md`.

## History

- 03/10/2026: sources read and the note written for the template's example family.
- <%DATE%>: seeded into this project when it was generated.
