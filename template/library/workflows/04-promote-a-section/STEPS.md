---
workflow: 04-promote-a-section
phase: produce
skills: [promote-section, build]
model: opus
---

# STEPS.md — promote a section into its document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for moving one approved section from its drafts folder into its document, on
the author's word, and recording what was approved. Each step names the skill and guide it uses.
**Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`). The
> `promote-section` skill is this procedure in skill form; read its `BUSINESS.md` mode file too.

## 1. Hear the author's word

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Confirm the author has said, in words, that this named section is ready to go into the document.
'Looks good' about another section, approval of an earlier version, or silence is not promotion.
If the word is ambiguous, ask once. _Substantive._

## 2. Check the section's gates

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/the-status-ladders.md`

The draft holds no `AUTHOR TO CONFIRM`, no `VERIFY` and no `[AWAITING USER INPUT]`
(`make flags` lists the two flags); its frontmatter is complete; and any section gate in
`standards/verification/verification.md` and its `BUSINESS.md` has passed. A draft bound for a
`.tex` holds no citation key (`[@`): keys resolve only in a Markdown document, so the author writes
the reference out in full first (`library/docs/reference/latex-deliverables.md`). Anything
outstanding goes back to the author; promotion waits. _Mechanical._

## 3. Find the document, and confirm you will not clobber it

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/versioning-and-the-register.md`

Find the deliverable: the newest `.tex` in the unit's family whose first line is
`% unit: <unit-slug>`. If its register row or Document Control block shows it has been circulated,
stop: a new version is opened first. If the document's `.tex` does not exist yet, create it from the
house skeleton `00-project.md ## Paths` names (by default `tooling/latex/skeleton.tex`), or from the
family template the brief names, at its versioned path, with the leading status block matching the
brief and one marker pair per planned section, in the brief's order. A Markdown deliverable (web
copy) is found by its frontmatter `unit:` instead and, when new, opens with frontmatter `unit:`,
`status:` and `last_updated:` matching the brief (`library/docs/reference/the-status-ladders.md`).
If the section's markers already hold text, this is a re-promotion: show the author what will be
replaced and get their confirmation. _Mechanical._

## 4. Convert the draft into LaTeX

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/latex-deliverables.md`

Convert the draft's body using the guide's table: headings, emphasis, lists (numbered clauses into
the house `clause` list, with `\label{cl:<slug>}` where other clauses refer to them), tables,
escaped specials. Every approved word arrives and nothing is added; one sentence per line
survives. The frontmatter stays behind; an internal note that concerns the document moves into the
`.tex` internal note block. For a Markdown deliverable, no conversion is needed. _Substantive._

## 5. Insert between the markers

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/latex-deliverables.md`

Replace whatever lies between `% section: <slug>` and `% end section: <slug>` with the converted
text, and nothing outside them. Never delete, rename or reorder a marker. _Mechanical._

## 6. Check every word arrived

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/latex-deliverables.md`

Run the section word-check, `make section-check FILE=<path>.tex SECTION=<slug> DRAFT=<draft>.md`,
where `<draft>.md` is the section's draft. It compares the words between the section's marker
pair with the words of the approved draft (through `tooling/texcheck.py`) and fails on any
difference. A difference is fixed in the conversion, never by editing the draft's
text, and the check is run again until it passes. Nothing is recorded until it does. A Markdown
deliverable takes the draft's text as it stands and skips this step. _Mechanical._

## 7. Prove it still renders

> **Skill:** `build` · **Guide:** `library/docs/reference/latex-deliverables.md`

Run `make pdf FILE=<path>.tex` and read the promoted section in the proof: no LaTeX error, no
`??` for a reference this section makes, no raw Markdown, no missing word. A failure is fixed in
the conversion, never by editing the draft's text. _Substantive._

## 8. Record what was approved

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

In the ledger entry, write the approved Markdown text into `## Author final`, set the `promoted`
date, and set `change_ratio`, computed by `tooling/provenance.py` from the AI original and the
author final (an author-drafted section has no AI original, and the skill records that). On a
re-promotion, set the entry's `learned: false`, so `learn-voice` mines the new edits. Add or
update the section's row in `standards/style/ledger/provenance.md`. _Mechanical._

## 9. Update the draft, the brief and memory

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/the-status-ladders.md`

Set the draft's `status: promoted` and `last_updated`; the draft stays in its drafts folder as the
record of the section. Mirror `promoted` in the brief's `sections:` list. Add one dated line to
`.claude/MEMORY.md` `## Status`. **Do not move the document's status:** if every planned section is
now promoted, say the document is ready for `library/workflows/05-review-a-document/`. _Mechanical._

## 10. Hand back

> **Skill:** `promote-section` · **Guide:** `library/docs/reference/drafting-with-ai.md`

Report the section promoted, the document and proof paths, the change ratio, the sections still to
promote, and whether the document is ready for review. _Substantive._
