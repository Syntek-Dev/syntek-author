---
workflow: 03-map-a-contested-reading
phase: research
skills: [tradition-check, category-check, research]
model: opus
---

# STEPS.md — map a contested reading

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for mapping a passage serious Christians read more than one way, before a
chapter leans on it. Each step names the skill and guide it uses, and any `make` command. **Run in
order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then
> `research/docs/reference/contested-readings.md` and `standards/method/THEOLOGY.md`. The
> `tradition-check` skill is the review this procedure ends with.

## 1. Check whether the map already exists

> **Skill:** `research` · **Guide:** `research/docs/reference/contested-readings.md`

Look in `research/src/contested-readings/` for the passage. If a map exists, read it and extend it
rather than re-deriving it: duplicated exegesis drifts between chapters. _Mechanical._

## 2. Set out the passage

> **Skill:** `research` · **Guide:** `research/src/contested-readings/CONTEXT.md`

Quote it in the default translation named in `standards/style/style-sheet.md`, from the
translation itself and never from memory, with enough surrounding context that the dispute is
visible rather than asserted. Where another translation makes the disputed point clearer, quote it
too and name it. _Substantive._

## 3. Identify the readings

> **Skill:** `tradition-check` · **Guide:** `research/docs/reference/contested-readings.md`

Usually two, sometimes three. Name each as its holders name it, and avoid any label one side uses
about the other. _Substantive._

## 4. State each reading in its holders' own terms

> **Skill:** `tradition-check` · **Guide:** `research/docs/reference/contested-readings.md`

**The recognition test:** would someone who holds this reading say 'yes, that is what I think'? A
fair summary by someone who disagrees still fails. If you cannot meet it, read someone who holds the
reading before writing it. _Substantive._

## 5. Record who holds each reading, and where

> **Skill:** `research` · **Guide:** `research/docs/reference/ingesting-sources.md`

Traditions, confessional documents and scholars, each with a source you have read. **Never
attribute a position to a named scholar or tradition without a source.** Key every commentary as
you go where the project keeps the citation database. _Substantive._

## 6. Say what each reading does to the book's argument

> **Skill:** `category-check` · **Guide:** `research/docs/reference/contested-readings.md`

For each reading: if this is right, what happens to the chapter, and to the claim in
`planning/src/arguments/` that rests on it? 'The argument survives either way' and 'this conclusion
depends on it' are both findings; record whichever is true. _Substantive._

## 7. Record where the readings agree

> **Skill:** `tradition-check` · **Guide:** `research/docs/reference/contested-readings.md`

Usually more than the dispute suggests. It is what lets a chapter be generous without being vague,
and often where the book's argument can stand untouched by the dispute. _Substantive._

## 8. Read the passage whole

> **Skill:** `category-check` · **Guide:** `research/docs/reference/contested-readings.md`

Check the map has not taken half of the passage, or a verse without its paragraph. A map recording
one half looks like diligence and is worse than none. _Substantive._

## 9. Gloss the original languages

> **Skill:** `research` · **Guide:** `research/docs/reference/contested-readings.md`

Gloss every Hebrew or Greek term plainly, from a lexicon or commentary you have read, with the
philology kept **separable** so the chapter can move it to a footnote and keep the gloss in the
body. A gloss you cannot source carries a `VERIFY` flag. _Substantive._

## 10. Recommend the reading to adopt

> **Skill:** `category-check` · **Guide:** `research/docs/reference/contested-readings.md`

The book is allowed a position, and **false balance is its own dishonesty.** Recommend a reading
with a reason someone could argue with, label it as interpretation rather than text, and say what
would change if another were right. The decision is the author's: leave `adopted:` empty and add an
`AUTHOR TO CONFIRM` flag until they make it. _Substantive._

## 11. Run the tradition check

> **Skill:** `tradition-check` · **Guide:** `research/docs/reference/contested-readings.md`

Ask how readers from the other relevant traditions would push back on the map as written, and
revise wherever a reading fails the recognition test. _Substantive._

## 12. Write the map and key the sources

> **Skill:** add-reference, where present · **Guide:** `research/src/contested-readings/CONTEXT.md`

Write `research/src/contested-readings/<passage>.md`, named for the passage. **Never overwrite an
existing map;** supersede it with a dated addition. Where the citation database exists, run:

```sh
make dump    # snapshot the database to text; commit it
make refs    # regenerate the citation data the build reads
```

Writing the map is judgement; the `make` runs are mechanical. _Substantive._

## 13. Hand back

> **Skill:** `tradition-check` · **Guide:** `research/docs/reference/contested-readings.md`

Report the map's location, the chapters it serves, the recommended reading and its reason, what is
waiting on the author's decision, and, most usefully, **what turns on the choice**. _Substantive._
