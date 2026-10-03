---
type: guide
skills: [category-check, argument-audit, tradition-check, steelman]
model: opus
---

# Argument maps — the structure behind a chapter's claims

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** An argument map lays out what a chapter claims and why a reader should believe
it: the thesis, the claims that carry it, what supports each claim, the objections it must face,
and where it concedes. It lives at `planning/src/arguments/<unit>.md`, beside the chapter's
brief, and is written before the chapter is drafted, so the prose argues a structure that has
already been checked rather than discovering its gaps at structural review.

## Six categories, one per claim

| Category | The question it answers |
|---|---|
| Biblical text | What does the passage say, in the default translation? |
| Textual observation | What can be seen in the text before it is interpreted? |
| Interpretive inference | What does the passage mean, reasoned from what is seen? |
| Historical interpretation | How has the Church read it, and who reads it that way? |
| The author's theological conclusion | What does the author conclude, across texts? |
| Pastoral application | What should the reader do or believe now? |

The commonest failure is a silent collapse: an inference presented as the text, a conclusion
presented as history, an application presented as exegesis.

## The shape of a map

```text
---
unit: <unit>
last_updated: DD/MM/YYYY
---
# <Chapter title> — argument map
## Thesis              one sentence: what the chapter lands
## Claims              C1 …: claim · category · supported by · flags
## Contested readings  passages read more than one way, each linked to its research entry
## Objections          O1 …: in its holders' words · who holds it · answered where, or left standing
## Concessions         K1 …: the cost conceded · where it is stated · where it is answered, later
## Open moves          missing premises, unsupported steps, conclusions beyond their evidence
```

## Support runs down, concession runs ahead

- Every claim names what supports it: other claims, an evidence entry, a passage. A claim
  supported by nothing is an open move, not a claim.
- No reference or quotation is written from memory. Until checked against the default
  translation or the source, it carries `<!-- VERIFY: … -->`.
- A concession is placed by position: the cost is stated in full before the response begins,
  in an earlier section or earlier in the same one, and never in the same sentence.

## How we apply it here

- The brief's `## Claims and categories` holds the claims the author has agreed, with their IDs;
  the map holds their support under the same IDs. The wording lives in the brief.
- A contested reading is mapped in `research/src/contested-readings/` before the chapter leans
  on it, and named in the body of the chapter, never only in a footnote.
- At least one objection may be left standing. Mark it; the author decides which.
- Re-audit the map whenever the chapter's structure changes, not only before drafting.

## Who implements it

- **Workflow:** `planning/workflows/02-map-the-argument/`.
- **Skills:** `category-check` labels the claims; `argument-audit` checks the support and, later,
  the prose against the map; `tradition-check` and `steelman` test the readings and objections.

## Governing standard

`standards/method/THEOLOGY.md` owns the six categories, concede-before-rebut and the steelman
tests. The standard owns the requirement; this guide owns how a chapter's argument is laid out
before it is written.
