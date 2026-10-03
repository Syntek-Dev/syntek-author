# voice-notes.md — how this work sounds

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the skills which route here point at something real from day one. Until `learn-voice` has
> mined the author's samples and edits, and the author has approved what it proposes, every
> section below reads 'No entries yet.'

The voice reference the drafting skills write **from** (`draft-section`, `adapt-section`,
`improve-section`) and that `learn-voice` grows. When a draft does not sound like
<%AUTHOR_FIRST_NAME%>, check it here, and if the answer is not here yet, that is the gap to fill.

> **Provenance note (<%DATE%>):** this file was seeded at generation, before any of this
> project's prose existed, so it holds no examples. Any example added before the author's own
> sentences exist is borrowed. **Replace borrowed examples with real sentences from the author's
> samples and promoted sections as soon as they exist** — a voice guide with borrowed examples
> is a hypothesis, not a standard.

---

## Voice in one breath

One paragraph: who is speaking, to whom, and across what kind of table. Written from the
author's samples, never invented.

_No entries yet._

## Registers

<: if DOC_TYPE == 'theology' -:>
The work carries two registers at once: accessible main text for every reader, and the
scholarly apparatus in the footnotes. Each register gets its own marks below.

### Main text

_No entries yet._

### Footnotes

_No entries yet._

<: endif -:>
<: if DOC_TYPE == 'fiction' -:>
The narrator's voice is recorded here. Each character's voice markers live in that character's
file under `world/src/characters/`; record here only how the narration itself shifts with the
point-of-view character.

### Narrator

_No entries yet._

### Shifts by point of view

_No entries yet._

<: endif -:>
<: if DOC_TYPE == 'business' -:>
Two registers: running copy (full sentences, room to explain, never room to pad) and microcopy
(labels, subject lines, short notices: terse and action-first). Legal instruments stay formal;
`standards/brand/brand-voice.md` sets how far the brand voice reaches into them.

<: if BUSINESS_VOICE_PERSON == 'singular' -:>
**Person.** First person singular: 'I', 'my'. The trading name is a label in headers, signatures
and structural text, never an actor in a sentence; 'we' implies a team that does not exist.

<: endif -:>
<: if BUSINESS_VOICE_PERSON == 'plural' -:>
**Person.** First person plural: 'we', 'our', speaking for the organisation. The trading name
is used where the organisation acts in a legal or structural sense.

<: endif -:>
### Running copy

_No entries yet._

### Microcopy

_No entries yet._

<: endif -:>
## Marks

Each mark is a bold one-line rule, then a real before and after pair from `samples/` or the
ledger. A mark without the author's own example waits in `## Learned` until it has one.

_No entries yet._

## Do and don't

_No entries yet._

## What a review preserves, and what it tidies

House default: proofreading is a report, not a rewrite. Preserve what is the voice (cadence,
candour, deliberate fragments<: if DOC_TYPE == 'theology' :>, the author's declared stake<: endif :>); tidy the
mechanics around it; never tidy away a hedge that is doing honest work.

_No entries yet._

## Learned

`learn-voice` appends here, and only after the author approves each addition. One bullet per
mark: `- **DD/MM/YYYY** — **<the mark>.** Before: '…' After: '…' (from the ledger entries named)`.
Rejected improvements are the clearest signal, so they are cited as often as accepted ones.

_No entries yet._

---

*Written by the author, or by `learn-voice` with the author's approval. Never edited silently;
record a voice call in `.claude/MEMORY.md` so earlier sections can be swept for consistency.*
