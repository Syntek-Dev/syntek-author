# THEOLOGY.md — theology sub-gates

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The gates a theology unit must pass in addition to `verification.md`, numbered under the gate they
belong to. V4 (`structural-review → fact-check`) passes only when V4.1 to V4.4 also pass. Each
sub-gate checks a rule of `standards/method/THEOLOGY.md`, cited by number, and is run by the
variant skill named with it.

Dates DD/MM/YYYY.

---

## 1. The sub-gates

**Requirement.**

| Gate | Within | Passes when | Run by |
|---|---|---|---|
| **V4.1** | V4 | The prose matches the unit's argument map in `planning/src/arguments/`: every claim on the map is argued, every supporting claim has its evidence, no conclusion is stated beyond its evidence, and no move in the prose is missing from the map (method rule 3). | `argument-audit` |
| **V4.2** | V4 | Every substantive sentence is labelled with one of the six claim categories, and no category is collapsed silently into another (method rules 1 and 2). | `category-check` |
| **V4.3** | V4 | Every contested reading the unit leans on is named in the main text, stated so that its holders would recognise it, with the reading adopted and what would change if another were right (method rule 4). | `tradition-check` |
| **V4.4** | V4 | Every objection passes the recognition, ease and omission tests; every concession is positioned ahead of its response; any objection designated as standing in `.claude/MEMORY.md` is still unanswered; the author's stake is declared where the argument first depends on it (method rules 5 to 8). | `steelman` |

**Why this rule exists.** A theology unit can be well written, accurate in every fact and still
argue dishonestly; these four gates are the structural checks that catch it before the facts are
checked and the lines polished.

---

## 2. Scripture is part of V5

**Requirement.** At V5, `fact-check` checks every Scripture quotation word for word against the
named translation, every reference to the verse, and every original-language claim against its
cited lexicon or grammar (method rule 9). A quotation not yet checked keeps its `VERIFY` flag,
and V5 cannot pass while it does.

**Why this rule exists.** These are the claims a theology reader checks first, and they are
checked last if nobody makes them part of a gate.

---

## 3. Order within V4

**Requirement.** Run V4.1 and V4.2 before V4.3 and V4.4: the argument and its categories are
settled before contested readings and objections are weighed against them.

**Why this rule exists.** Steelmanning an objection to an argument that is about to be
restructured wastes the work and may steelman the wrong objection.
