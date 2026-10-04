---
type: guide
skills: [fact-check, research]
model: opus
---

# Vetting evidence — whether a claim is fit to print, and the verdicts

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** The everyday judgement calls behind the fact-check gate: whether a figure, a date,
a study finding or a legal statement can go in the work, and what to do when it nearly can. The
rule underneath everything: **a claim the work cannot defend is worse than no claim.** Cut it
rather than hedge it.

## The five things a claim must carry

1. **What exactly is claimed:** one checkable sentence. If it will not reduce to one, that is the
   finding.
2. **The source that owns the fact:** the study, the statute, the register, the record; not a
   report of it.
3. **When it was established:** the date of the figure or the ruling, not the date it was quoted.
4. **How it was established:** measured, modelled, estimated or decided; by whom; on what
   assumptions.
5. **Its scope:** which population, place, period, jurisdiction or edition it covers.

Missing any of the five, the claim is decoration. 'Roughly' and 'some estimates suggest' do not
repair it.

## Where claims go wrong, in any field

- **A range rounded into a headline.** The range was the finding.
- **A projection quoted as a measurement**, or an estimate quoted as a count.
- **One group's figure quoted for everyone**, or one jurisdiction's law quoted as 'the law'.
- **An association quoted as a cause.**
- **An old figure quoted as current.** Beyond roughly twelve months, re-check before export.

The `fact-check` skill's mode file adds the failures peculiar to this project's field.

## Judging a study

Record, every time: population · time horizon · method · effect size · **and what it was not
about.** That last line is the most valuable in most entries. The gap between what was measured and
what the work wants to say is stated in the unit's body, not merely logged here.

## The verdicts

One vocabulary, used everywhere. The `fact-check` skill returns it, and every entry in
`research/src/evidence/` carries it:

| Verdict | Meaning | What the draft does |
|---|---|---|
| `verified` | Primary source, basis complete, current | Use it, with its citation |
| `verified-with-caveat` | True, but narrower than the draft implies | Use the narrower wording the entry gives |
| `contested` | Credible sources disagree | Report the disagreement; never average or resolve it |
| `thin` | One study, a small sample, or unreplicated | Use it only if the prose says so |
| `cannot-be-dated` | No establishable date or basis | Recommend cutting |
| `unsupported` | No primary source; the chain leads nowhere | Recommend cutting |

## How we apply it here

- **Don't stop where it's convenient.** When the evidence starts agreeing with the author, keep
  going, and record where pushing past that point changed the answer.
- **Legal claims carry jurisdiction and date**, and say where the matter is unsettled.
- **Correct against the work's interest, out loud.** A fact that tells against the argument is
  reported plainly in the verdict.
- **Claims about the author** are checked against `.claude/MEMORY.md` (Facts, mapped in
  `00-project.md` `## Memory headings`) and, where it is silent, put to the author; never inferred.

## Who implements it

- **Skill:** `fact-check`, with `research` for delegated search. **Workflow:**
  `research/workflows/02-verify-a-claim/`.

## Governing standard

`standards/verification/verification.md` owns the fact-check gate and when it must pass;
`.claude/rules/syntek-author/03-authorship.md` owns the `VERIFY` flag. The standard owns the
requirement; this guide owns the judgement calls in meeting it.
