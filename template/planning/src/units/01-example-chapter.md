<: if DOC_TYPE == 'theology' :>---
title: "The Second Sunday"
slug: example-chapter
number: "01"
version: ""             # books leave it empty
status: draft           # idea | outlined | draft | structural-review | fact-check | line-edit | final
audience_note: ""
sources: []
verified: {V1: <%DATE%>}
sections:
  - {slug: opening, purpose: "Open on a visitor who is welcomed warmly once and forgotten by the next Sunday.", status: promoted}
  - {slug: the-turn, purpose: "Concede the strongest reason for keeping welcome light, set out the passage, and turn to the argument.", status: ai-draft}
---

# The Second Sunday

<!-- WORKED EXAMPLE: a seeded brief that shows the shape of a unit brief. It is not part of your book.
     The chapter and its thesis are invented for the example, every bracketed claim is a placeholder, nothing has been checked and no passage has been chosen.
     Once your first real chapter is planned, delete this file, the argument map beside it in planning/src/arguments/01-example-chapter.md, the example chapter in manuscript/src/01-example-chapter/ and its two ledger entries, standards/style/ledger/01-example-chapter--opening.md and standards/style/ledger/01-example-chapter--the-turn.md, with any provenance.md rows you added while practising.
     They will not come back. -->

## Scope

In: when a congregation's welcome is finished, and why a guest who comes back tests it more than a guest who arrives.
Out: how to organise a welcome team, which is practice for a later chapter, and the history of hospitality in the Church, which is a research note if the book needs one.

## What this unit does

A reader who serves on a welcome rota finishes the chapter able to say what their church does for a guest on the second Sunday, not only the first.

## Sections

1. `opening`: a visitor is welcomed warmly and forgotten by the following week; hands on the claim that a welcome is finished only when the guest is expected back.
2. `the-turn`: concedes the strongest reason for keeping welcome light, sets out Passage A, names its contested reading in the body, and turns to the argument.

## Claims and categories

| ID | Claim | Category |
|---|---|---|
| C1 | [Placeholder: the strongest reason for keeping welcome light, as its holders state it.] <!-- VERIFY: find it stated by someone who holds it --> | Historical interpretation |
| C2 | [Placeholder: what Passage A says, quoted from the default translation.] <!-- VERIFY: choose Passage A and quote it from the default translation (<%BIBLE_TRANSLATION%>), never from memory --> | Biblical text |
| C3 | [Placeholder: a feature of Passage A visible before interpretation.] <!-- VERIFY: check the feature in the text itself --> | Textual observation |
| C4 | [Placeholder: that more than one tradition reads Passage A differently, and who.] <!-- VERIFY: name the sources and pages in research/src/sources/ --> | Historical interpretation |
| C5 | [Placeholder: what Passage A implies about a guest who comes back, reasoned from C3.] | Interpretive inference |
| C6 | A welcome that forgets the guest by the following week has not yet become hospitality. | The author's theological conclusion |
| C7 | The test for a welcome rota is not who greets a visitor, but who knows her name the next Sunday. | Pastoral application |

The support behind these claims is mapped in `planning/src/arguments/01-example-chapter.md`, under the same IDs.

## Draws on

- [Placeholder: the contested-reading entry for Passage A in `research/src/contested-readings/`, once it is mapped.]
- [Placeholder: source notes in `research/src/sources/` for C1 and C4.]

## Draft notes

- <!-- AUTHOR TO CONFIRM: which of the two candidate objections (O1, O2 in the argument map) the-turn concedes, and whether the other is left standing. -->
- <!-- AUTHOR TO CONFIRM: which passage is Passage A. -->
- `opening` was drafted by the author and is promoted, with its ledger entry; `the-turn` is an AI draft waiting for the author's notes.
<: endif :><: if DOC_TYPE == 'fiction' :>---
title: "The Ford"
slug: example-chapter
number: "01"
version: ""             # books leave it empty
status: draft           # idea | outlined | draft | structural-review | fact-check | line-edit | final
audience_note: ""
sources: []
verified: {V1: <%DATE%>}
sections:
  - {slug: opening, purpose: "Maren reaches the ford at night and steps down, though she does not trust it.", status: promoted}
  - {slug: the-turn, purpose: "Midway across, something moving upstream turns the crossing from a risk into a threat.", status: ai-draft}
---

# The Ford

<!-- WORKED EXAMPLE: a seeded brief that shows the shape of a unit brief. It is not part of your novel.
     Every person and place in it is invented for the example.
     Once your first real chapter is planned, delete this file, the example chapter in manuscript/src/01-example-chapter/ and its two ledger entries, standards/style/ledger/01-example-chapter--opening.md and standards/style/ledger/01-example-chapter--the-turn.md, with any provenance.md rows you added while practising.
     They will not come back. -->

## Scope

In: one crossing of the ford at night, from the top of the near bank to the moment Maren sees what is in the water.
Out: what waits on the far bank, which is the next chapter's question, and what the thing in the water is.

## What this unit does

The reader finishes the chapter frightened for Maren and sure of one thing about her: she goes on when every sense tells her to turn back.

## Sections

1. `opening`: the goal is set and the doubt planted; Tam has said the ford is safe, Maren does not believe him, and she steps down anyway.
2. `the-turn`: goal, conflict, outcome; the counting holds as far as the willow, then something upstream turns, and the chapter hands its question to the next.

## Continuity facts

| Fact | Establishes or relies on | Section |
|---|---|---|
| Tam told Maren the ford was safe at low water. | establishes | `opening` |
| The water is low on the night of the crossing. | establishes | `opening` |
| Maren carries a shuttered lantern. | establishes | `opening` |
| The village behind her is dark when she sets out. | establishes | `opening` |
| The ford is crossed on stepping stones, counted three to the post and four to the willow. | establishes | `the-turn` |
| Tam taught Maren that count. | establishes | `the-turn` |

In a real chapter these facts would enter `planning/src/continuity.md` as each section is promoted; an example's facts never do, because the ledger records real work only.

## Draws on

- `planning/src/causality.md`: the beats behind the crossing, once charted.
- [Placeholder: entries for Maren and Tam in `world/src/characters/`, once created.]

## Draft notes

- <!-- AUTHOR TO CONFIRM: what waits on the far bank, and how much of it Maren knows. -->
- Keep the point of view with Maren throughout; the reader learns what is in the water when she does.
- `opening` was drafted by the author and is promoted, with its ledger entry; `the-turn` is an AI draft waiting for the author's notes.
<: endif :>