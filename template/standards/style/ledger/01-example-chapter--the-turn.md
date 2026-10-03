---
unit: 01-example-chapter
section: the-turn
origin: ai              # ai | author
drafted: <%DATE%>
promoted:               # DD/MM/YYYY, set by promote-section
change_ratio:           # 0.00 to 1.00, computed at promotion; empty for author-drafted
learned: false          # set true by learn-voice once promoted and mined
---

<!-- WORKED EXAMPLE: the ledger entry for the example chapter's AI draft,
     manuscript/src/01-example-chapter/drafts/02-the-turn.md, shipped once by the template so
     that the draft's ledger: key resolves and the loop can be practised on it from the first
     session. Its AI original is the draft's body exactly as shipped. It is not part of your
     book. Delete it with the rest of the example: the chapter folder, its brief in
     planning/src/units/<: if DOC_TYPE == 'theology' :>, its argument map in planning/src/arguments/<: endif :>
     and the opening's entry beside this one, together with any provenance.md rows added while
     practising. It will not come back. -->

## AI original

<!-- INTERNAL NOTE: example section draft shipped once by the template.
     It is shorter than words_target on purpose, so the shape is easy to see.
     Its flags must be resolved before it can be promoted. -->

<: if DOC_TYPE == 'theology' :>Before the argument goes further, the strongest reason for keeping welcome light deserves a hearing.
<!-- AUTHOR TO CONFIRM: which of the brief's two candidate objections does this chapter concede? -->
Those who hold it would put it like this: [state the objection in terms its holders would recognise].
That is not an unkind position, and a longer welcome rota does not answer it.

A passage often read on welcome is [Scripture reference to be supplied].
<!-- VERIFY: the reference, the translation and the exact wording before anything is quoted. -->
[Placeholder: one feature of the passage that a reader can see before interpreting it.]
Readers in more than one tradition take the passage differently, and this chapter will say which reading it adopts and what would change if another were right.
[Placeholder: what the adopted reading implies about a guest who comes back.]

Only then does the argument turn.
A welcome that forgets the guest by the following week has not yet become hospitality.
The test for a welcome rota is therefore not who greets a visitor, but who knows her name the next Sunday.

<!-- CLAIM CATEGORIES
1. 'Those who hold it would put it like this' — historical interpretation (placeholder; to be sourced).
2. 'A passage often read on welcome' — Biblical text (placeholder; see the VERIFY flag).
3. '[Placeholder: one feature of the passage …]' — textual observation (placeholder; to be checked in the text itself).
4. 'Readers in more than one tradition take the passage differently' — historical interpretation (depends on the VERIFY flag).
5. '[Placeholder: what the adopted reading implies …]' — interpretive inference (rests on 2 and 3, and on the reading adopted).
6. 'A welcome that forgets the guest' — the author's theological conclusion.
7. 'The test for a welcome rota' — pastoral application.
-->
<: else :>The first stones held.
Maren counted them under her breath, the way Tam had taught her: three to the post, four to the willow.
At the willow the water reached her knees, colder than it had any right to be.
<!-- AUTHOR TO CONFIRM: is this Maren's first crossing at night, which the brief does not say and which changes how frightened she should be? -->
She was reaching for the fifth stone when the lantern caught something moving upstream, low and fast against the current.
Not a branch.
Branches did not turn.
She froze with one foot lifted, and the river, which had been loud all night, went quiet around her.
<: endif :>
## Author final

## Improvement decisions

| # | Proposal | Reason | Decision | Author's note |
|---|---|---|---|---|
