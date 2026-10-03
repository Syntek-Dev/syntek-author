---
name: tradition-check
description: >-
  Test a passage's readings, a contested-reading map or a theology chapter against the readers who
  hold other views: how readers from other traditions (Reformed, Catholic, Orthodox, Wesleyan,
  Pentecostal, Anabaptist, as relevant) would push back; whether each reading is stated so its own
  holders would recognise it; whether the chapter names the dispute in the main text, not a
  footnote, with the reading it adopts and what would change if another were right. Maps into
  research/src/contested-readings/ through research workflow 03; gate V4.3 at structural review.
  Use when the author says 'how would a Catholic read this?', 'is this fair to the Reformed
  view?', 'who would object to this reading?' or 'have I named the other readings?'. Reports; the
  reading adopted is the author's. Not the argument's logic (`argument-audit`); not whether
  objections are steelmanned (`steelman`); not text against inference (`category-check`); not
  finding sources (`research`).
---

# Skill: Tradition check (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

A contested reading tucked into a footnote, or stated in its critics' words, tells the readers who
hold it that they were not considered. This skill reads a passage's readings, or a chapter that
leans on them, through the eyes of the traditions that actually hold them: is each reading stated
so its holders would say 'yes, that is what I think', where would each tradition push back, and is
the dispute named in the body? It **reports**; which reading the book adopts is the author's
decision, and every claim about what a tradition holds rests on a source, never on memory.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `research/workflows/03-map-a-contested-reading/` — mapping a passage: this skill runs its steps
  3, 4, 7 and 11, and hands back at step 13.
- `manuscript/workflows/10-steelman-the-objections/` — step 6: the readings named in the body.
- `manuscript/workflows/05-review-a-chapter/` — the structural stage, where this skill is gate
  V4.3 (`standards/verification/THEOLOGY.md`).
- `standards/method/THEOLOGY.md` — rule 4 (name the contested reading in the body) is the rule
  this skill enforces.
- `standards/risk/THEOLOGY.md` — rule 2: a tradition is described as its holders would recognise
  it, from sources its own members would accept.
- `research/docs/reference/contested-readings.md` — the recognition test, what turns on it, a
  position without false balance.

## How to run the tradition check

1. **Fix the scope and the use.** Agree with <%AUTHOR_FIRST_NAME%> what is being checked: a
   passage being mapped (`research/workflows/03-map-a-contested-reading/`), an existing map in
   `research/src/contested-readings/`, or a chapter (gate V4.3, or step 6 of the steelman audit).
   Read `standards/method/THEOLOGY.md` rule 4, `standards/risk/THEOLOGY.md` rules 1 and 2, the
   relevant maps, and `.claude/MEMORY.md` for decisions about readings already adopted.
   *Complete when:* the scope and use are stated and every map in play has been read.

2. **Find the passages in play.** For a chapter, list every passage it leans on that Christians
   read in more than one way, with its location in the prose and its `R` ID on the argument map in
   `planning/src/arguments/`. Each needs a map; where none exists, stop and say so: the route is
   `research/workflows/03-map-a-contested-reading/`, and readings are never reconstructed from
   memory to fill the gap. *Complete when:* every contested passage is listed with its map, or
   with a finding that its map is missing.

3. **Choose the traditions that matter here.** For each passage, name the traditions that actually
   read it differently, from the sources the map cites, and say why each is relevant. The six named
   in the description are a starting list, not a roster to run through every time; a tradition
   with no distinct reading of this passage adds noise. A claim about what a tradition holds that
   no source supports goes to `research`, and carries `<!-- VERIFY: … -->` until it has one.
   *Complete when:* each passage has its relevant traditions, each with a reason and a source or a
   flag.

4. **Apply the recognition test to each reading.** Would someone who holds this reading say 'yes,
   that is what I think'? Check that it is named as its holders name it, never by a label the other
   side uses; stated in their own terms and emphases; at its strongest, not its most vulnerable;
   and never characterised by its worst representative. A fair summary by someone who disagrees
   still fails. *Complete when:* every reading has a pass or a fail, and every fail names the words
   its holders would not accept.

5. **Push back as each tradition would.** For the reading the book adopts, or recommends, and for
   each move the chapter makes on it, set out what a careful reader from each relevant tradition
   would say, in that tradition's terms, and where that reader would stop reading in good faith.
   Mark every such pushback as a reconstruction to be checked against the tradition's own sources
   before it is relied on. *Complete when:* each relevant tradition has its strongest pushback
   stated, sourced or flagged.

6. **Record where the readings agree.** Usually more than the dispute suggests, and it is what lets
   a chapter be generous without being vague (`research/workflows/03-map-a-contested-reading/`
   step 7). *Complete when:* the common ground for each passage is stated in a sentence or two, or
   recorded as none.

7. **Chapter use: check the dispute is in the body.** For each contested passage, the main text
   names the dispute, says which reading the chapter adopts, who holds the others, and what would
   change if another were right. A footnote-only treatment fails, however full the footnote. So
   does false balance: two readings presented as equally strong when the map recommends one.
   *Complete when:* each passage is marked in the body, footnote only, or absent, with locations.

8. **Report and hand back.** Deliver the report below. In a mapping session, revise the map's text
   only with the author's agreement, never set its `adopted:` field, and leave the recommendation
   flagged `AUTHOR TO CONFIRM` until the author decides; writing the map is step 12 of the research
   workflow. Change nothing in a chapter. Run as gate V4.3, hand the verdict to the review
   workflow, which dates the gate in the brief's `verified:` map once every blocking finding is
   resolved. *Complete when:* the report is delivered, the author knows what turns on each choice,
   and, for a gate run, the review workflow has the verdict.

## The report

Per passage, blocking findings first:

- **Readings** — each reading by its holders' name, with **recognition: pass or fail** and, on a
  fail, the words to change and why its holders would reject them.
- **Pushback** — per relevant tradition, the strongest objection it would raise, marked sourced or
  to be checked.
- **Common ground** — where the readings agree.
- **Placement** (chapter use) — in the body, footnote only or absent, with locations.
- **What turns on it** — whether the chapter's argument survives either way, or depends on the
  reading adopted; the most useful line in the report.

Close with a verdict: **V4.3 pass or fail**, naming the reading least recognisable to its holders.

## Anti-patterns

- **A reading from memory.** Never attribute a position to a tradition or a scholar without a
  source; a remembered summary is how caricature enters a careful book.
- **Running the roster.** Six traditions listed against every passage, most with nothing distinct
  to say, buries the one reading that matters.
- **The opponent's label.** A reading named in its critics' terms has already failed the test.
- **Deciding the reading.** Recommending with reasons is allowed; adopting is the author's, and
  the map's `adopted:` stays empty until they decide.
- **False balance.** Presenting a weaker reading as equal to a stronger one is its own dishonesty.
- **Rewriting the chapter.** A footnote-only dispute is reported with its location; moving it into
  the body is the author's change, through the section loop.

## Cross-references

- `standards/method/THEOLOGY.md` — rule 4; `standards/risk/THEOLOGY.md` — rules 1 and 2.
- `standards/verification/THEOLOGY.md` — gate V4.3, run after V4.1 and V4.2.
- `research/docs/reference/contested-readings.md` — the guide; `research/src/contested-readings/`
  and its `CONTEXT.md` — the map format.
- `manuscript/docs/reference/main-text-and-footnotes.md` — the dispute in the body, the depth below.
- `.claude/skills/research/SKILL.md` — finds and notes the sources a reading rests on.
- `.claude/skills/category-check/SKILL.md` — keeps a reading labelled as interpretation.
- `.claude/skills/steelman/SKILL.md` — the good-faith audit this check feeds.
