---
type: guide
skills: [draft-section, adapt-section, improve-section, tone]
model: opus
---

# Simplified Technical English — ASD-STE100 for technical text

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** ASD-STE100 Simplified Technical English (STE) is a controlled form of English for
technical text. A reader who follows steps must do the correct thing at the first reading, and
often that reader is a client in a second language. This guide gives the few rules that do the
most work, in the template's own words. The full standard (Issue 9) and its dictionary are free on
request from ASD at asd-ste100.org; they are ASD's copyright, so no project file copies them.

## What counts as technical text

- **Procedures:** steps, set-up, an SOP, a walkthrough, a runbook, the steps in a client guide, a
  change or recovery procedure, and instructions in a financial document (how to pay, how to claim).
- **Technical descriptions:** how a system, a service or a process works; a technical schedule
  (security measures, a service description); the technical part of an email (a fix, a set-up).
- **Not technical text:** persuasive copy, an email's greeting and relationship lines, operative
  clauses, policy rules, defined terms and figures. These keep their own register.

## The rules that matter

- **One instruction per sentence**, in the imperative: 'Open the portal.' Write two actions as two
  steps, unless the reader must do them at the same time.
- **Condition first:** 'If the light is red, restart the router.' A warning or caution comes
  before the step it applies to, and starts with a clear command.
- **Short sentences:** a procedural sentence has 20 words or fewer; a descriptive sentence has 25
  words or fewer. A descriptive paragraph has one topic and six sentences or fewer.
- **One word, one meaning.** Use the same word for the same thing every time. Use simple, common
  verbs ('use', not 'utilise'), and no phrasal verb where one verb does the work ('remove', not
  'take out').
- **Active voice; no noun clusters of more than three words.** Keep 'the' and 'a'. Use a vertical
  list for a sequence or a set of conditions.
- **Technical names are allowed:** product names, defined terms, menu labels, the reader's own
  words for their systems. Record each in `standards/style/terminology.md`.

## What keeps its register

- **STE never changes a modal, a defined term, a figure, a date or a commitment.** An instruction
  that carries a duty ('The Supplier shall…') is a clause, not a step.
- **STE never makes the text longer.** A rewrite that adds words is declined; the plain draft stays.
- **en_GB wins.** British spelling and the house locale apply where the dictionary differs.

> **Before:** 'Once you've logged in, you'll want to head over to settings and make sure that
> two-factor is switched on, which should only take a minute or so.'
>
> **After:** '1. Log in to the portal. 2. Open Settings. 3. Set two-factor authentication to On.'

## How we apply it here

- `draft-section` writes technical text in STE from the first draft; `adapt-section` and
  `improve-section` apply it only to the lines they are asked to change.
- `tone` reads technical text as its own register at line edit, gate V6.1.
- `make lint` reports list steps of more than 20 words in the library, outside legal documents.
  It is a hint, not a gate: a step can be correct at 21 words.
- The family standards say which of their document types hold technical text.

## Who implements it

- **Skills:** `draft-section`, `adapt-section`, `improve-section`, `tone`, `comprehension`.
- **Workflows:** `library/workflows/01-draft-a-section/`, `library/workflows/05-review-a-document/`.

## Governing standard

`standards/method/BUSINESS.md` rule 11 owns the requirement; rules 2, 4, 7 and 10 own what STE
must not touch. This guide owns how the rule is applied.
