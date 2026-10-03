---
name: approach-a-reader
description: >-
  Draft one tailored approach to one reader whose yes the book needs before publication (a
  prospective endorser, or a literary agent) and keep the tracker true: read the tracker first,
  name the specific reason it is this person, check what they ask for and what exists to send,
  tailor the master text, write the approach in its few moves, check nothing is invented, save the
  draft, and hand it to the author, who sends it. Use when the author says 'approach [name] for an
  endorsement', 'draft a query to [agent]', 'add an agent to the list', 'chase up [name]', 'who
  should I ask next?' or 'tailor the query letter for this agency'. Never sends anything and never
  claims an endorsement, interest or offer that does not exist. Not drafting the proposal or
  query package itself (`proposal/workflows/01-assemble-the-proposal/`, through `run-workflow`;
  `build` renders it); not checking a comparable title or a claim (`fact-check`); not
  proofreading (`spelling`, `grammar`).
---

# Skill: Approach a reader (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

An approach asks someone for a yes the book needs, so that saying yes is easy and declining is easy
too. The judgement about what to say to whom is the whole task: a generic approach reads as a
mail-merge, and an invented detail ends the relationship. This skill drafts one approach to one
person from the master text, tailored to them, saves it beside the tracker and hands it to
<%AUTHOR_FIRST_NAME%>. **The author sends it**; the tracker records an approach only once it has
gone.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `proposal/workflows/02-approach-a-reader/` — this skill in procedure form, step for step.
- `proposal/workflows/03-update-the-tracker/` — logging what was sent, and every reply.
- `proposal/docs/reference/approaching-readers.md` — reach, not prestige; the moves of a good
  approach; before and after the draft.
- `proposal/src/CONTEXT.md` — the tracker's path, the drafts folder and where received items are
  kept in this project.
- `standards/style/voice-notes.md` — how the approach sounds: the book's voice, honest before
  persuasive.
- `.claude/rules/syntek-author/03-authorship.md` — Section 4: never fabricate.

> **Mode.** Before step 1, read the doc-type mode file beside this one — exactly one of
> `THEOLOGY.md`, `FICTION.md`, `BUSINESS.md` ships in this folder. The mode owns the domain
> (paths, unit, extra reads, domain rules, examples); this file owns the procedure. Where they
> disagree, the procedure wins and the disagreement is reported to the author.

## How to approach a reader

1. **Read the tracker first.** Open the tracker the mode names, before anything else. If this
   person already has a row, you are revising or chasing, not approaching: never draft a second
   first approach. *Complete when:* the person's row is quoted, or their absence is confirmed.

2. **Confirm why this reader.** Ask whose yes unlocks which audience, and which objection it
   answers. Then name the specific reason it is this person: their work, or the books on their
   list, that bear on this one, checked on their own published pages. **If you cannot name it,
   stop** and tell the author why. *Complete when:* the reason is one sentence the person would
   recognise as true of themselves, or the approach is stopped with a reason.

3. **Check what they ask for, and what exists to send.** Read the person's own published
   requirements, where they have them, and record them in their tracker row (adding the row at its
   first status if it is new). Check `manuscript/src/` and `proposal/src/sample/sample-index.md`:
   offer only what is promoted, give a realistic date, or wait. *Complete when:* the requirements
   are in the row, and everything the approach will offer exists or has a date the author agreed.

4. **Start from the master, then tailor.** Begin from the master text the mode names, then tailor
   it to this person: the reason from step 2, their requirements from step 3, the ask that fits
   them. **A master sent untailored is the failure this procedure exists to prevent.**
   *Complete when:* every paragraph that came from the master has been read against this person
   and changed where it does not fit them.

5. **Write the approach.** The moves, in order: why them, specifically · the book briefly, leading
   with the hook · the author's position, plainly, in one clause where it matters · the ask, with
   its effort and its date, or exactly what their requirements ask for · an easy, sincere exit
   where the form allows · nothing else. Keep to the length the mode sets, in the book's voice.
   *Complete when:* the draft makes every move the form allows and is within the length.

6. **Check for anything invented.** No claimed endorsement, no implied interest from anyone, no
   publisher or agent implied where none is attached, no manufactured deadline, no sample that does
   not exist, no figure or comparable title unchecked (`fact-check`). Anything unverified carries
   `<!-- AUTHOR TO CONFIRM: … -->` or `<!-- VERIFY: … -->` in the draft. *Complete when:* every
   factual statement in the draft is checked or flagged.

7. **Proofread.** Run `spelling` and `grammar` as a supportive report, and check the person's
   name, title and affiliation against their own published page: this carries the author's name to
   someone they respect. *Complete when:* the reports are resolved with the author and the name,
   title and affiliation match their source.

8. **Save the draft.** Save it as `<reader-slug>.md` in the drafts folder beside the tracker, as
   the mode names it. **Never overwrite an existing draft** without the author's confirmation; a
   revision of a sent approach is a new, dated file. *Complete when:* the draft exists at its path
   and nothing was overwritten unasked.

9. **Hand it to the author; do not send.** Report the draft's path, why this reader, the ask, what
   is offered and by when, and anything waiting on the author's confirmation. *Complete when:* the
   author has the report and the row still shows its first status.

10. **Log it once it has gone.** Only when the author confirms the approach was sent, run
    `proposal/workflows/03-update-the-tracker/` with the date the author sent it, the ask and what
    was sent. Until then the row stays at its first status. *Complete when:* the row shows the
    author's send date, or is unchanged because nothing has been sent.

11. **When the reply does not come, or does.** Follow the chase rule the mode sets, and no more:
    a second chase costs more goodwill than the yes is worth. A reply is recorded in the row as it
    came, never upgraded, through `proposal/workflows/03-update-the-tracker/`, with the next action
    and its date. *Complete when:* the row carries the reply verbatim, or the chase the mode allows,
    and a dated next action.

## Anti-patterns

- **Sending, or implying it was sent.** The draft is the author's to send; a drafted approach is
  not an approach, and the tracker never says it is.
- **Generic praise.** Flattery with no specific reason reads as a mail-merge and is the commonest
  reason a good reader declines.
- **Burying or performing the author's stake.** One plain clause; neither hidden nor made a
  credential.
- **Offering what does not exist.** A sample not yet promoted is offered with a realistic date, or
  not at all.
- **Upgrading a reply.** 'Interested, will read later' is not a yes; record it as it came.
- **A second first approach, or a second chase.** Read the tracker first; follow the chase rule and
  stop.
- **Writing to a department.** Where a named person exists, the approach goes to them.

## Cross-references

- `proposal/docs/reference/approaching-readers.md` — the craft of the approach.
- `proposal/src/CONTEXT.md` — every part of this project's package and where it lives.
- `proposal/src/sample/sample-index.md` — what is promoted and may be offered.
- `proposal/workflows/03-update-the-tracker/` — the only route by which the tracker changes after
  sending.
- `.claude/skills/fact-check/SKILL.md` — checks a comparable title, a figure or a claim about the
  reader.
- `.claude/skills/spelling/SKILL.md` · `.claude/skills/grammar/SKILL.md` — the supportive
  proofread.
- `.claude/skills/build/SKILL.md` — builds the files an approach sends.
