# method.md — how the work handles what it claims

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The governing standard for every checkable claim the work makes: a quotation, a figure, a date,
a historical or legal statement, a description of a real person, place or study. The
`fact-check` skill enforces it, calling `research` for delegated search; `draft-section` writes
to it; `structure-review` checks it as a structural matter, not a stylistic one. The method
particular to this kind of work is in the mode file beside this one (exactly one of
`THEOLOGY.md`, `FICTION.md` or `BUSINESS.md` ships here).

Dates DD/MM/YYYY in prose; ISO 8601 (`YYYY-MM-DD`) only in database columns.

---

## 1. Evidence before prose

**Requirement.** A section that rests on a checkable claim is drafted after the claim's
evidence exists in `research/src/evidence/`, or with the claim flagged `VERIFY` in the draft
(`<!-- VERIFY: … -->`, saying what would verify it). Never from memory, however confident.

**Why this rule exists.** A section drafted ahead of its evidence keeps its unverified claims:
the sentence reads well, nobody returns to it, and it ships. A flag costs nothing and is listed
by `make flags`; an unflagged guess is invisible.

---

## 2. Every claim carries its basis

**Requirement.** A checkable claim is publishable only with its basis recorded: **what exactly
is claimed** (the narrowest true wording); **the source** (primary where one exists); **when**
the fact was established, not when it was quoted; **how** it was established (measured,
reported, estimated, interpreted, and by whom); and **its scope** (one study, one place, one
period, one edition).

> **Right:** a figure in the body with its measurement, date and scope in the note or the
> evidence entry.
>
> **Wrong:** 'Most people now believe…' with no survey, no date and no population.

**A claim that cannot carry its basis is cut, not hedged.** 'Roughly', 'some say' and 'it is
often claimed' do not repair a claim with no source; they decorate it.

**Why this rule exists.** The reader who checks one claim decides from it whether to trust the
rest. A memorable, widely repeated, unsourced claim is the one most likely to be checked.

---

## 3. Two dates, and currency

**Requirement.** Every evidence entry records two dates: when the fact was established and when
it was checked. Anything that changes with time (figures, laws, prices, practices, online
pages) and was checked more than roughly twelve months before export is checked again before
export. An online source carries its accessed date; a page that can change without notice is
never cited without one.

**Why this rule exists.** A stale figure does not merely mislead; it dates the whole work, and
a reader who spots one assumes the rest is as old.

---

## 4. Record what a study was not about

**Requirement.** For every study cited, the evidence entry records its population, its time
span, what it measured, its effect size where it has one, and **the gap between what it measured
and what the work wants to say**. Where the work reaches beyond a study, the body says so in
plain words.

> **Right:** 'The study measured recall over a week, not habits over a lifetime; what follows is
> an argument, not a finding.'

**Why this rule exists.** Stretching a narrow finding to a broad claim is the move a hostile
reviewer is waiting for, and stating the gap costs one sentence.

---

## 5. Contested evidence stays contested

**Requirement.** Where credible sources disagree, the work reports the disagreement; it does
not pick the side that suits it or average the two. Where the evidence is thin, the work says
it is thin. **Keep going past the point where the evidence started agreeing with you**, and
correct against the work's own interest when that is where the evidence leads.

**Why this rule exists.** A flagged weak claim is worth more than a confident one that will not
survive scrutiny, and a work that stops searching where it is comfortable has stopped being
honest without noticing.

---

## 6. Legal and regulatory claims carry jurisdiction and date

**Requirement.** Any claim about law, regulation or a ruling names its jurisdiction and the date
the position was checked, and says plainly where the matter is unsettled. A statute is cited by
its short title and the section relied on; a section number is never guessed.

> **Right:** 'Unsettled in [jurisdiction] as of [DD/MM/YYYY], with [the case] pending.'

**Why this rule exists.** Law moves and differs by place; a confident legal sentence without
both is wrong somewhere already, and soon wrong everywhere.

---

## 7. One verdict vocabulary

**Requirement.** `fact-check` returns exactly one of these verdicts for each claim, and every
skill, checklist and evidence entry uses the same words:

| Verdict | Meaning | What the work does |
|---|---|---|
| `verified` | The source says this, and it is current | State it, citing the source |
| `verified-with-caveat` | True, but narrower than the draft implies | Use the narrower wording recorded with the verdict |
| `contested` | Credible sources disagree | Report the disagreement (rule 5) |
| `thin` | One source, or an unreplicated finding | State it as thin, or cut it |
| `cannot-be-dated` | No date can be fixed for it | Cut it, or replace it with a dated claim |
| `unsupported` | No adequate source was found | Cut it |

Each verdict is recorded in `research/src/evidence/` with the claim as checked, the source,
the date established, the date checked, the basis (rule 2) and, where relevant, the narrower
wording the work may safely use. **Nothing is marked `verified` without a real source.**

**Why this rule exists.** Several vocabularies for the same judgement drift apart until 'solid'
in one file and 'verified' in another mean different things, and a gate that counts verdicts
cannot be trusted.

---

## 8. Never fabricate; flag instead

**Requirement.** No skill invents a quotation, a page number, a citation, a source, an
original-language definition, a reference to a text, a statute or section number, a price, a
date or a historical claim. Where one is needed and not yet found, the draft carries a `VERIFY`
flag; where a decision only the author can make is needed, it carries an `AUTHOR TO CONFIRM`
flag (`.claude/rules/syntek-author/03-authorship.md` owns both).

**Why this rule exists.** A plausible invention is undetectable downstream. A flag is visible,
listed by `make flags`, and blocks the `final` gate until someone resolves it.

---

## 9. The doc-type method

**Requirement.** The mode file beside this one adds the method particular to this kind of work.
Its rules bind with the same force as this file's; where the two appear to disagree, report the
disagreement to the author rather than choosing.

**Why this rule exists.** Every kind of work shares the duty to be honest about its claims, but
each meets it differently: an argument by its categories, a story by its causes, an instrument
by its obligations.
