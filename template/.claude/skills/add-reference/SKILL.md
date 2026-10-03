---
name: add-reference
description: >-
  Add a work to the project's citation database, tooling/references.db, and give the author its
  key to cite: take the details from the work itself, choose the CSL type the schema allows, mint
  a lower-case authorYYYY key (a, b, c to tell same-year works apart), check the key and the work
  are not already there, insert the row with names and dates in the schema's forms, then run
  make dump and make refs. Use whenever a book, chapter, article, report, web page, statute or
  other work needs citing, or when the author says 'add this to the bibliography', 'cite this
  source', 'put this book in the database', 'key this article' or 'what is the key for …?'. Keys
  are never renamed, and no Harvard entry is ever typed by hand. Not deciding whether a claim is
  true or a source fit to cite (`fact-check`); not reading and noting a source (`research`); not
  building the reference list into a proof (`build`).
---

# Skill: Add a reference (<%PROJECT_NAME%>)

Locale: en_GB · <%TIMEZONE%> · dates DD/MM/YYYY.

The citation database is the single source of truth for every reference the work prints. This
skill puts one work into it, correctly, and hands back the key. It treats the row as content, not
clerical work: a wrong year or a guessed publisher prints confidently in every proof, and a renamed
key breaks every citation of it silently. Formatting belongs to `tooling/harvard.csl`; the skill
never writes a Harvard entry by hand. Dates in the database are ISO 8601 (`YYYY-MM-DD`), and
DD/MM/YYYY everywhere else.

## Governing procedures (route here — do not restate at length)

Route to the one that matches the task and follow its `STEPS.md` against its `CHECKLIST.md`.
These are the procedure of record — do not restate them at length here.

- `research/workflows/01-ingest-a-source/` — step 9 (key it, now, not later) is this skill; the
  steps before it read and note the source.
- `standards/referencing/harvard-referencing.md` — rules 2 to 5 (keys, names and dates, statutes
  and sacred texts, no invented sources) are the rules this skill enforces; rule 6 is the pipeline.
- `research/docs/reference/ingesting-sources.md` — routing a source, and keying it as it is noted.
- `tooling/schema.sql` — the `refs` table: its columns, the allowed types and their comments.

## How to add a reference

1. **Confirm the work is real and noted.** A key corresponds to a real work recorded in
   `research/src/` (rule 5): find its note in `research/src/sources/` (or the evidence entry or
   question-led note that cites it), or ingest it first through
   `research/workflows/01-ingest-a-source/`. A key does not launder a claim: if the work supports a
   checkable claim, that claim still needs its `fact-check` verdict. *Complete when:* the note's
   path is named, or the author has agreed to ingest the work first.

2. **Gather the details from the work itself.** From the title page, the journal's own page, the
   publisher's record or the DOI landing page, never from memory or a secondary list: authors,
   editors, year, title, container title (the journal, or the book for a chapter), publisher,
   place, volume, issue, pages, URL, DOI and, for anything online, the date accessed. Where a
   detail cannot be found, it stays empty; ask the author before treating it as unknowable.
   *Complete when:* every column the work has is filled from the work, and every gap is listed.

3. **Choose the type.** Exactly one of the types the schema's `CHECK` constraint allows: `book`,
   `chapter`, `article-journal`, `article-magazine`, `article-newspaper`, `webpage`, `report`,
   `paper-conference`, `thesis`, `entry-encyclopedia`, `legislation`, `legal_case`,
   `motion_picture`. A statute or regulation is one `legislation` row per instrument with no
   author; its sections are locators in the citation, never rows of their own (rule 4). A sacred
   text is cited in prose by its own reference system and keyed once, for the reference list.
   *Complete when:* the type is chosen and fits the work.

4. **Mint the key.** The first author's family name, lower-case, without spaces or accents, then
   the year: `marlowe2018`. A work with no personal author takes the first significant words of its
   corporate author or short title, run together. Two works by the same author in the same year
   take `a`, `b`, `c` in the order they were keyed (rule 2). *Complete when:* one candidate key is
   written down.

5. **Check the key and the work are free.** If `tooling/references.db` does not exist yet, run
   `make init` (it builds the database and refuses to overwrite one). Then list what is there:

   ```sh
   sqlite3 tooling/references.db \
     "SELECT citation_key, author, year, title FROM refs ORDER BY citation_key;"
   ```

   If **this work** is already present, stop and reuse its key; where its details are wrong,
   correct the row with an `UPDATE … WHERE citation_key = '…'` on the author's confirmation, never
   the key. If a **different** work holds the key, take the next free letter. A key already cited
   in the work is never renamed, reused or repurposed, even to correct it. *Complete when:* the
   key is confirmed free for this work, or the existing key is returned.

6. **Write the names and dates in the schema's forms.** Authors and editors as
   `Family, Given; Family, Given`; a corporate author as one part with no comma, so it prints as
   written; `year` as text, so `n.d.` is allowed; `accessed` as `YYYY-MM-DD`, mandatory for every
   online source (rule 3). Double every single quotation mark inside a value (`O''Neill`).
   *Complete when:* every value is in its column's form.

7. **Insert the row.** Insert only the columns the work has; leave the rest out, so they stay
   `NULL`. Record any gap, and why it is a gap, in `note`, which is never printed:

   ```sh
   sqlite3 tooling/references.db "
   INSERT INTO refs (citation_key, type, author, year, title, publisher, publisher_place)
   VALUES ('marlowe2018', 'book', 'Marlowe, Edith', '2018', 'An Invented Title',
           'Example Press', 'Exeter');"
   ```

   For an `article-journal`, add `container_title`, `volume`, `issue`, `page` and `doi`; for a
   `chapter`, `editor`, `container_title` and `page`; for a `webpage` or online `report`, `url`
   and `accessed`. *Complete when:* the `SELECT` from step 5 shows the new row with the values
   intended.

8. **Record the key where it is used.** Write the key into the source note's `key:` field. Where a
   detail is still missing, add `<!-- VERIFY: … -->` to the note's bibliographic details, so
   `make flags` lists it until it is found. Give the author the citation forms (`[@marlowe2018]`,
   `[@marlowe2018, p. 42]`); a citation enters a draft through the drafting skills, and a promoted
   unit changes only through the section loop. *Complete when:* the note carries the key, and every
   open gap is flagged.

9. **Dump and export.** Run `make dump` (the diffable text snapshot, `references.dump.sql`) and then
   `make refs` (the CSL-JSON the build reads), and confirm both exit cleanly. Tell the author to
   commit the database and its dump together. To see the entry printed, build a proof of a unit
   that cites it with `build`; a wrong rendering is fixed in the row, never in the output.
   *Complete when:* both targets succeeded and the author has a one-line confirmation:
   `Added [marlowe2018] (book); make dump and make refs run; cite as [@marlowe2018].`

## Anti-patterns

- **Renaming a key.** Keys are embedded throughout the work; a rename breaks every citation of the
  work and shows only as a missing reference in a proof.
- **Guessing a detail.** A guessed publisher or year prints as a confident wrong reference; an
  empty column prints as a visibly incomplete one, which is caught.
- **Typing a Harvard entry.** The reference list is generated from the database by Pandoc and
  `tooling/harvard.csl`; a hand-written entry drifts the first time either changes.
- **Editing the output.** `build/` is regenerated on every build and never hand-edited.
- **Keying from memory.** A work nobody has opened is not a source the work can cite.
- **Editing the seed file.** `tooling/seed-refs.sql` holds only works the project brought with it;
  every other work enters through this skill.

## Cross-references

- `standards/referencing/harvard-referencing.md` — the citation standard.
- `tooling/schema.sql` — the `refs` table; `tooling/seed-refs.sql` — works carried in at the start.
- `tooling/CONTEXT.md` — the reference pipeline: `make init`, `make refs`, `make dump`.
- `research/src/sources/CONTEXT.md` — the source note and its `key:` field.
- `.claude/skills/research/SKILL.md` — reads and notes a source before it is keyed.
- `.claude/skills/fact-check/SKILL.md` — whether the claim a source supports is true.
- `.claude/skills/build/SKILL.md` — runs `make refs` before every proof and reads the result.
