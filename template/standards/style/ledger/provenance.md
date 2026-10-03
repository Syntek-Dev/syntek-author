# provenance.md — the disclosure register

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the skills which route here point at something real from day one. Until `promote-section`
> promotes the first section, the table below has no rows.

One row per promoted section, added by `promote-section` on the author's word. The ledger
entries beside this file are the source of truth; this register is the readable summary, and
`python3 tooling/provenance.py check` reports any row that disagrees with its entry.
`make provenance` prints the per-unit disclosure table a publisher asks for.

**Columns.** `Unit` is the unit's name: its brief's filename without `.md`, number included,
which is also the ledger entry's `unit:` (for example `03-the-ford`, never the brief's shorter
`slug:`). `Section` is the section's slug from the brief's `sections:` list. `Origin` is `ai` or
`author`. `Change ratio` is computed by `tooling/provenance.py` (0.00 means the AI draft was
promoted unchanged, 1.00 that it was entirely rewritten); an author-drafted section shows `—`.
`Promoted` is the date of promotion, DD/MM/YYYY.

## Register

| Unit | Section | Origin | Change ratio | Promoted |
|---|---|---|---|---|

_No entries yet._
