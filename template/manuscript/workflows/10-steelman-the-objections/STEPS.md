---
workflow: 10-steelman-the-objections
phase: review
skills: [steelman, tradition-check, category-check, argument-audit]
model: opus
---

# STEPS.md — steelman the objections

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for auditing a chapter against the book's honesty commitments. This is a
review: report, never rewrite. Each step names the skill and the guide it uses. Tick `CHECKLIST.md`
as you go.

> Read `standards/method/THEOLOGY.md` in full first: it holds the rules this procedure applies. The
> `steelman` skill is this procedure in skill form.

## 1. Find what the chapter is committed to

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

Read the chapter brief's claims-and-categories section and its argument map in
`planning/src/arguments/` (claim, supporting claims, evidence, objections, concessions). Read
`.claude/MEMORY.md` Decisions (mapped in `00-project.md` `## Memory headings`) for any objection
the book has chosen to leave standing. If none is designated, note it for the report: leaving one
standing is something the method allows, not something it requires. _Substantive._

## 2. List every objection the chapter raises

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

Extract them plainly, in the chapter's own words, with locations. Include objections raised
implicitly ('some will say…') and any the chapter answers without first stating. Compare the list
with the argument map's objections: one in the map but missing from the prose is noted. _Substantive._

## 3. Apply the three tests

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

For each objection:

- **Recognition** — would someone who holds this view read the paragraph and say 'yes, that is what
  I think'? Use `tradition-check` for how readers in other traditions would state it themselves.
- **Ease** — if the response came easily, the objection was too weak. Flag anything dispatched in
  a sentence.
- **Omission** — what is the strongest thing an opponent would say that the chapter does not
  mention at all? This is the commonest failure and the hardest to see.

_Substantive._

## 4. Check the objection aimed at the author

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

The strongest form of 'you would say that': the author's own tradition, role or interest. Where it
bears on the chapter, confirm it is stated at full strength and the author's stake is declared in
the body, not neutralised or dropped. Missing or softened here is blocking. _Substantive._

## 5. Check every concession by its position on the page

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

Concessionary words prove nothing. For each cost the chapter answers, confirm it is stated in the
body, not a footnote; in its own passage, before the response begins; in its holders' terms, not
the author's summary; and in units that do not flatter the answer. _Substantive._

## 6. Check the contested readings are in the body

> **Skill:** `tradition-check` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

For every passage the chapter leans on that serious Christians read differently, confirm a map
exists in `research/src/contested-readings/`, and that the main text names the dispute, says which
reading the chapter adopts, and says what would change if another were right. A footnote-only
treatment is the commonest way this rule is broken while appearing to be kept. _Substantive._

## 7. Check the categories hold under pressure

> **Skill:** `category-check` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

Where the chapter answers an objection, does it answer in the right category? Flag an exegetical
objection met with pastoral application, an interpretive inference presented as the text's plain
sense, or the author's conclusion presented as what the Church has always held. _Substantive._

## 8. Check anything left standing is still standing

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

If the book has designated an objection to leave unanswered, sweep the chapter for anything that
answers it, including partly, in a footnote, or by implication. If it has been answered, **report
and stop**: do not resolve it, do not re-designate it. The author decides whether the chapter or
the designation changes, and the decision is dated in `.claude/MEMORY.md` Decisions (mapped in
`00-project.md` `## Memory headings`). _Substantive._

## 9. Posture check

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

Flag any passage that would leave a reader who decides differently defensive rather than
thoughtful: sneering, knowing asides, pity, or a joke at the other view's expense. These are
defects however well turned. _Substantive._

## 10. Deliver the report and the three verdicts

> **Skill:** `steelman` · **Guide:** `manuscript/docs/reference/main-text-and-footnotes.md`

A prioritised list, blocking first: exact location, the check it fails, why, a suggested fix, and
the owner of the fix. Then state, explicitly, even where they pass:

- **Steelman:** pass or fail, naming the weakest objection.
- **Conceded before rebutted:** pass or fail, naming any inversion.
- **Left standing:** still standing, answered at a named location, or none designated.

When the audit runs as the review's steelman gate and passes, date it in the chapter brief's
`verified:` record. _Substantive._
