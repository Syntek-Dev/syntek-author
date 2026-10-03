---
type: guide
skills: [tradition-check, category-check]
model: opus
---

# Contested readings — mapping a passage read more than one way

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** How to map a passage that serious Christians read more than one way, before a
chapter leans on it: set it out, state each reading so its holders would recognise it, say what
each does to the argument, and say which the book adopts and why. The map is where the scholarship
goes, so the chapter can stay light: a few sentences in the body and a footnote, drawn from a
document that did the work properly.

## What a map carries

One file per passage in `research/src/contested-readings/`, named for the passage and never for the
chapter, because maps are shared:

- the passage in the default translation named in `standards/style/style-sheet.md`, with enough
  context that the dispute is visible rather than asserted;
- each reading, named as its holders name it, and who holds it and where it is argued;
- **what each reading does to the book's argument**;
- where the readings agree;
- the reading the book adopts, why, and what would change if another were right;
- original-language terms glossed, with the philology kept separable for a footnote.

## The recognition test

Would someone who holds this reading read your paragraph and say 'yes, that is what I think'? A
fair-minded summary written by someone who disagrees still fails. If you cannot state a reading in
terms its holders would accept, you are not ready to write it: read someone who holds it first.
Avoid any label one side uses about the other.

## Name what turns on it

The section most often skipped, and the one that earns the map its keep. 'The argument survives
either way' is a valuable finding: the chapter can be brief. 'This chapter's conclusion depends on
it' is valuable too: the chapter must say so, and the reader will know how much weight to place on
what follows.

## A position, not false balance

The book is allowed a position. Presenting two readings as equally strong when the author finds one
much stronger is its own dishonesty. Give the reason in terms someone could argue with; an unargued
preference dressed as a conclusion is the failure a careful reader is trained to spot. Read the
passage whole: a map built on half a passage looks like diligence and is worse than none.

## How we apply it here

- **Named in the body, not buried in a footnote.** The chapter states the dispute in its main text;
  the footnote carries the depth.
- **The adopted reading is the author's call.** Recommend, with reasons; until the author decides,
  the map carries an `AUTHOR TO CONFIRM` flag.
- **Write each map once.** A passage that serves several chapters gets one map, read by all of
  them; duplicated exegesis drifts.
- **Never attribute a position to a named scholar or tradition without a source,** never quote a
  commentary from memory, and never define an original-language term from memory: anything
  unchecked carries a `VERIFY` flag.
- **Keep the claim categories apart.** A reading is interpretive inference or historical
  interpretation, never the text itself (`category-check`).

## Who implements it

- **Skills:** `tradition-check` (how readers from other traditions would push back), with
  `category-check` keeping text, inference and conclusion apart. **Workflow:**
  `research/workflows/03-map-a-contested-reading/`.

## Governing standard

`standards/method/THEOLOGY.md` owns the requirements that contested readings are named in the body
and that the six claim categories are never silently collapsed. The standard owns the rule; this
guide owns the map.
