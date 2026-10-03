<!-- EXAMPLE CHAPTER, shipped once by the template to show the shape of a chapter file.
     Its plan is planning/src/units/01-example-chapter.md<: if DOC_TYPE == 'theology' :>, and its argument map is planning/src/arguments/01-example-chapter.md<: endif :>.
     The first section was drafted by the author and has been promoted; the second is still an AI draft in drafts/.
     Each section has its ledger entry: standards/style/ledger/01-example-chapter--opening.md and standards/style/ledger/01-example-chapter--the-turn.md.
     The prose is invented placeholder text.
     The epigraph and the scene break are semantic Markdown, which every build and the printed book read: see typeset/docs/reference/semantic-markdown.md.
     Delete this folder, its plan<: if DOC_TYPE == 'theology' :>, its argument map<: endif :> and both ledger entries when you no longer need them, with any provenance.md rows you added while practising, and copier update will not bring them back. -->

<: if DOC_TYPE == 'theology' :># The Second Sunday

<!-- section: opening -->

::: epigraph
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
<: else :># The Ford

<!-- section: opening -->

::: epigraph
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
<!-- section: the-turn -->
