---
unit: 01-example-chapter
section: opening
origin: author          # ai | author
drafted: <%DATE%>
promoted: <%DATE%>    # DD/MM/YYYY, set by promote-section
change_ratio:           # 0.00 to 1.00, computed at promotion; empty for author-drafted
learned: false          # true once promoted and mined; false again when its final is replaced
format: 2               # the revision record below; absent from an entry that predates it
---

<!-- WORKED EXAMPLE: the ledger entry for the example chapter's first section, opening, which
     the author drafted and promoted. It is shipped once by the template so that every section
     of the example has its entry, and the chapter can be practised all the way through review
     once the-turn is promoted too. An author-drafted section has no AI original and no change
     ratio; its Author final is the section exactly as it sits in
     manuscript/src/01-example-chapter/01-example-chapter.md under its marker. The entry also
     records how the section got there. Author original is the author's first draft. Revision 1
     is that draft after one improve-section pass at strength light: the author accepted row 1
     and rejected row 2, so only row 1 changed the text. The one difference left between
     revision 1 and the Author final is the author's own hand-edit before promotion. Run
     make compare UNIT=01-example-chapter to see the three stages side by side. The register,
     provenance.md, ships empty, so this section has no row there until you add one. It is not
     part of your book. Delete it with the rest of the example: the chapter folder, its brief in
     planning/src/units/<: if DOC_TYPE == 'theology' :>, its argument map in planning/src/arguments/<: endif :>
     and the-turn's entry beside this one, together with any provenance.md rows added while
     practising. It will not come back. -->

## AI original

<!-- Empty: the author drafted this section. -->

## Author original

<: if DOC_TYPE == 'theology' :>::: epigraph
'Everyone welcome to stay for tea after the service.'

— a notice by the church door
:::

The visitor came in out of the rain halfway through the first hymn and sat at the end of the back row.
Afterwards three people shook her hand, someone found her a cup of tea, and the minister asked where she had come from.
By any ordinary measure it was a good welcome.
The next Sunday she came back, sat in the same seat, and nobody remembered her name.

::: scene-break
:::

That second Sunday is where this chapter begins, because it is easy to give once and harder to keep giving.
A church can be friendly at the door and still forget the guest by the following week.
This chapter argues that a welcome is not finished at the door; it is finished when the guest is expected back.
<: else :>::: epigraph
'Count the stones, and the river lets you pass.'

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>— a saying of the [hebori]{.conlang lang=example-tongue}, the ford-keepers
<: else :>— a saying of the ford-keepers
<: endif :>:::

The last window in the village went dark.
Maren counted a hundred breaths, then lifted the latch and went out.

* * *

The river was louder in the dark.
Maren stood at the top of the bank with the lantern shuttered, listening for the stones.
Tam had told her the ford was safe at low water, and the water was low, and she did not believe him.
Behind her the road ran back to the village, every window already dark.
Ahead, somewhere past the noise, was the far bank and the only reason she had come.
She opened the lantern a fingers width, enough to see her own boots, and stepped down.
<: endif :>
## Revisions

<!-- revision 1 · ai · <%DATE%> · improve-section (light) · rows 1–2 -->

<: if DOC_TYPE == 'theology' :>::: epigraph
'Everyone welcome to stay for tea after the service.'

— a notice by the church door
:::

The visitor came in out of the rain halfway through the first hymn and sat at the end of the back row.
Afterwards three people shook her hand, someone found her a cup of tea, and the minister asked where she had come from.
By any ordinary measure it was a good welcome.
The next Sunday she came back, sat in the same seat, and nobody remembered her name.

::: scene-break
:::

That second Sunday is where this chapter begins, because a welcome is easy to give once and harder to keep giving.
A church can be friendly at the door and still forget the guest by the following week.
This chapter argues that a welcome is not finished at the door; it is finished when the guest is expected back.
<: else :>::: epigraph
'Count the stones, and the river lets you pass.'

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>— a saying of the [hebori]{.conlang lang=example-tongue}, the ford-keepers
<: else :>— a saying of the ford-keepers
<: endif :>:::

The last window in the village went dark.
Maren counted a hundred breaths, then lifted the latch and went out.

* * *

The river was louder in the dark.
Maren stood at the top of the bank with the lantern shuttered, listening for the stones.
Tam had told her the ford was safe at low water, and the water was low, and she did not believe him.
Behind her the road ran back to the village, every window already dark.
Ahead, somewhere past the noise, was the far bank and the only reason she had come.
She opened the lantern a finger's width, enough to see her own boots, and stepped down.
<: endif :>
## Author final

<: if DOC_TYPE == 'theology' :>::: epigraph
'Everyone welcome to stay for tea after the service.'

— a notice by the church door
:::

The visitor came in out of the rain halfway through the first hymn and sat at the end of the back row.
Afterwards three people shook her hand, someone found her a cup of tea, and the minister asked where she had come from.
By any ordinary measure it was a warm welcome.
The next Sunday she came back, sat in the same seat, and nobody remembered her name.

::: scene-break
:::

That second Sunday is where this chapter begins, because a welcome is easy to give once and harder to keep giving.
A church can be friendly at the door and still forget the guest by the following week.
This chapter argues that a welcome is not finished at the door; it is finished when the guest is expected back.
<: else :>::: epigraph
'Count the stones, and the river lets you pass.'

<: if DOC_TYPE == 'fiction' and INCLUDE_CONLANG :>— a saying of the [hebori]{.conlang lang=example-tongue}, the ford-keepers
<: else :>— a saying of the ford-keepers
<: endif :>:::

The last window in the village went dark.
Maren counted a hundred breaths, then lifted the latch and went out.

* * *

The river was louder in the dark.
Maren stood at the top of the bank with the lantern shuttered, listening for the stones.
Tam had told her the ford was safe at low water, and the water was low, and she did not believe him.
Behind her the road ran back to the village, every window already black.
Ahead, somewhere past the noise, was the far bank and the only reason she had come.
She opened the lantern a finger's width, enough to see her own boots, and stepped down.
<: endif :>
## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
<: if DOC_TYPE == 'theology' :>| 1 | 'because a welcome is easy to give once' for 'because it is easy to give once' | clarity: 'it' has no noun to point back to, so say what is easy to give | accepted | |
| 2 | split the last sentence at the semicolon: '… not finished at the door. It is finished when …' | clarity: one claim to a sentence | rejected | The semicolon is the argument: the two halves stand or fall together. |
<: else :>| 1 | 'a finger's width' for 'a fingers width' | typo: the possessive needs its apostrophe | accepted | |
| 2 | 'but she did not believe him' for 'and she did not believe him' | clarity: 'but' marks the turn against what Tam said | rejected | The flat 'and' is the point: she has every reason to believe him, and she does not. |
<: endif :>