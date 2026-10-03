---
type: guide
skills: [sensitivity-pass]
model: opus
---

# Handling testimony — first-person material, with consent and care

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **Safeguarding-critical.** Read `standards/risk/sensitive-content.md` before opening anything in
> `research/src/testimony/`.

**What it is.** How to work with testimony: the author's own story, or an account someone has
entrusted to the author, held as raw first-person notes. It is often the material that makes the
book worth reading, and the material its owner is least free, or least ready, to publish. Both are
true at once; this guide is about holding them together.

## The four rules

1. **Consent is load-bearing.** Nothing reaches the manuscript, verbatim or paraphrased, without an
   explicit, considered decision by the person whose story it is. Consent is specific (this passage,
   this use) and is never inferred from silence, from an earlier yes, or from the material being in
   the repository.
2. **Shape, never paste.** These are notes to work from with the author, not a draft. Capture,
   order and clarify; never rewrite into publishable prose here.
3. **Flag, never decide.** Anything identifying, legally sensitive or touching a third party goes
   to the author with the risk stated plainly. An unflagged risk is a decision made on someone
   else's behalf.
4. **Testimony is not evidence.** It carries no statistics and no claims about others; the
   argument's evidence lives in `research/src/evidence/`.

## Protecting other people

Anonymise or generalise third parties by default (family, colleagues, members of a congregation,
anyone) unless the author has explicitly cleared a detail. A person can be identifiable without
being named: by role, by place, by timing. Where a story needs a person in it, ask whether it needs
*that* person. No child is ever identifiable.

## The author's wellbeing

Pace hard material gently. Confirm the author is willing to work on it now; stop when asked, and
offer to stop when it is clearly costing them. Nothing is pushed through to meet a schedule. The
work is never done alone, and it never pretends to be the author's support.

## Signpost what stirs

A passage that could surface something painful, for a reader or for the author, is flagged so the
unit ends near a route to support, in the form `standards/risk/sensitive-content.md` sets. Never
name a source of help from memory; any one named in print is checked first.

## How we apply it here

- **The voice is preserved.** Keep the author's cadence and actual words; smoothing them into
  generic prose destroys what the material is for.
- **Private by default.** This folder is committed to git, and history keeps what a later edit
  removes. Write nothing here the author would not want in the repository's history; what they
  want kept out of it stays outside the repository.
- **Never overwrite a note;** supersede it with a dated addition.
- **Proofreading is supportive:** a report, never a rewrite, and never of the voice.

## Who implements it

- **Skill:** `sensitivity-pass`, a reviewer that reports and never silently rewrites testimony.
  **Workflow:** `research/workflows/05-handle-testimony-safely/`.

## Governing standard

`standards/risk/sensitive-content.md` owns the rules: careful handling, rigorous sourcing,
signposting, safeguarding and wellbeing. The standard owns the rules; this guide owns working with
testimony day to day.
