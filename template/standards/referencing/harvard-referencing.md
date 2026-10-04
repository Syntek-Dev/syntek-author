# harvard-referencing.md — how the work cites

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The governing standard for citations and the reference list. `add-reference` enforces rules 2 to
5 when a source becomes a row; `build` enforces rule 6 by running `make refs` before every proof;
`promote-section` enforces rule 7; `fact-check` decides, under `standards/method/method.md`,
whether a source may be cited at all.
The style is Harvard as set out in Cite Them Right, implemented by `tooling/harvard.csl`. The
keys in the examples are invented.

Dates DD/MM/YYYY in prose; ISO 8601 (`YYYY-MM-DD`) in the database's `accessed` column.

---

## 1. Citations are generated, never typed

**Requirement.** A citation is written inline as a key, and Pandoc `--citeproc` renders both the
in-text citation and the reference list from `tooling/harvard.csl`:

| You write | For |
|---|---|
| `[@ashdown2019]` | A plain citation |
| `[@ashdown2019, p. 42]` | A page |
| `[@ashdown2019, pp. 16–17; @okafor2021a, ch. 3]` | Several works at once |
| `@ashdown2019 argues…` | The author named in the sentence |

The one exception, a business LaTeX deliverable where no key can resolve, is rule 7.

**Why this rule exists.** A hand-typed reference drifts from the database the first time either
changes, and a reference list nobody typed cannot be mistyped.

---

## 2. Keys are lower-case `authorYYYY`, and never renamed

**Requirement.** A key is the first author's family name, lower-case and without spaces or
accents, followed by the year: `ashdown2019`. Two works by the same author in the same year take
`a`, `b`, `c` in the order they were keyed: `okafor2021a`, `okafor2021b`. A work with no personal
author (a report, a statute) uses the first significant words of its corporate author or short
title, run together: `someact2024`. **Once a key appears in
the work, it never changes**, even to correct it.

**Why this rule exists.** Keys are embedded throughout the work; renaming one breaks every
citation of it silently, and the break shows only as a missing reference in a proof.

---

## 3. Names and dates go in the columns, in one form

**Requirement.** Authors and editors are written `Family, Given; Family, Given`. A corporate
author is one part with no comma, so it prints as written. `year` holds the year as text, so
`n.d.` and `2015a` are allowed. `accessed` holds an ISO 8601 date and is **mandatory for every
online source**, and non-negotiable for any page that can change without notice.

**Why this rule exists.** The export script turns these forms into CSL-JSON mechanically; a name
written any other way prints wrongly in every reference that uses it.

---

## 4. Statutes and sacred texts

**Requirement.** A statute or regulation is one row per instrument, typed `legislation`, with no
author, its short title as the title and its year in `year`; sections are locators in the
citation (`[@someact2024, s. 4]`), never separate rows. A sacred or canonical text
(for example, Scripture in a theology project) is cited in prose by its own reference system,
with the translation or edition named, not as a key at every quotation. A theology project's
default translation is named in `00-project.md` `## Brief` by its key. `make refs` writes the key
from the Copier answer to `build/nocite.yaml`, which `tooling/defaults.yaml` loads, so it is in
every reference list without a citation in the text. A change of translation is therefore made
with `uvx copier update --trust -a .copier-answers.syntek-author.yml --data BIBLE_TRANSLATION=…`
(`README.md`, 'Updating from the template'), then by hand in `## Brief`. The key still needs its
row in the database, added with `add-reference`; until it has one the build leaves it out
without a warning, so check the reference list in the proof for it.

**Why this rule exists.** These sources have reference systems older and more precise than any
author-date style; forcing them into one helps no reader.

---

## 5. No invented sources, and no guessed details

**Requirement.** A key corresponds to a real source recorded in `research/src/`. A detail that is
not known (a publisher, a place, a page range) is left empty and the row is preceded in any seed
file by a comment beginning `VERIFY:`; it is never guessed. A citation key does not launder an
unverified claim: the claim still needs its `fact-check` verdict.

**Why this rule exists.** An incomplete row prints a visibly incomplete reference, which is
caught in proof; a plausible invented detail prints a confident wrong one, which is not.

---

## 6. The pipeline, and scope by selection

**Requirement.** `tooling/references.db` is the master and the only thing edited.
`make refs` exports it to `build/references.json`; every proof target runs `make refs` first.
The reference list scopes itself: Pandoc prints only the works cited in the files it is given, so
a single unit's proof lists that unit's sources and the whole-work build lists them all. Never
curate a list by hand. Run `make dump` after every change to the database, and commit the
database and its text dump, `references.dump.sql`, together.

**Why this rule exists.** One master, one export and one style file leave only one place for a
reference to be wrong. The text dump exists because a binary database that was never committed is
lost the first time its folder is moved.

---

## 7. Keys work only in Markdown documents

**Requirement.** A citation key is resolved by Pandoc, so it works only in a document built from
Markdown: every unit of a book, and a business document kept and issued as Markdown. In this
version of the template a business document issued as a LaTeX deliverable (`.tex`) cannot
resolve a key: a section bound for a `.tex` writes each in-text citation and reference out in
full, in the form `tooling/harvard.csl` prints it, and `promote-section` stops on a draft bound
for a `.tex` that still contains `[@`. This is the one place a reference is typed by hand, and
it is copied from the source's database row, never written from memory. Citations generated
inside LaTeX deliverables are deferred to a later release.

**Why this rule exists.** In a `.tex` deliverable an unresolved key prints as raw text while the
build still succeeds, so nothing but the promotion check stops it reaching the client.
