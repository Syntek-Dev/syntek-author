---
workflow: 02-verify-a-claim
phase: research
skills: [fact-check, research]
model: opus
---

# STEPS.md — verify a claim

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The ordered procedure for establishing whether a claim is true, on what basis and as of when,
**before** it reaches the page. It is the only route by which a claim gets a verdict, and it feeds
V5 (fact-check → line-edit). Each step names the skill and guide it uses, and any `make` command.
**Run in order** — the ordering is load-bearing — and tick `CHECKLIST.md` as you go.

> Read the read-order files first (this folder's `CONTEXT.md` and `CLAUDE.md`), then
> `research/docs/reference/vetting-evidence.md`. The `fact-check` skill is this procedure in skill
> form.

## 1. Isolate the claim as one checkable sentence

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Strip the rhetoric. 'Crossings were dangerous' is not checkable; 'in the decade to 1850, the
county coroner recorded N drownings at the ford, per the surviving inquest returns' is. **If the
claim will not reduce to one checkable sentence, that is the finding:** report it and stop. An
unfalsifiable claim does not become true by being sourced. _Substantive._

## 2. Check whether it is already verified

> **Skill:** `fact-check` · **Guide:** `research/src/evidence/CONTEXT.md`

Search `research/src/evidence/` for an entry on the same claim. If one exists and its `checked`
date is within roughly twelve months, use it and skip to step 13; if it is older, re-check from
step 4 and supersede it with a dated addition. Never start a second entry on the same claim.
_Mechanical._

## 3. Identify the basis the claim needs

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Before searching, know what a complete answer looks like: what exactly is claimed · the source
that owns the fact · when it was established · how it was established · its scope. _Substantive._

## 4. Go to the primary source

> **Skill:** `research` · **Guide:** `research/docs/reference/vetting-evidence.md`

Locate, then read, at the origin: the study, the official statistics, the statute and its
commencement, the official register, the archive record. **Follow the chain back;** never accept a
figure from an outlet reporting on a study when the study is available. For a claim about the
author, the source is `.claude/MEMORY.md` (Facts, mapped in `00-project.md` `## Memory headings`)
and then the author. _Substantive._

## 5. Record two dates

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

The date the fact was **established**, and the date you **checked** it. Anything older than roughly
twelve months is flagged for re-checking before export; for any web page, record the accessed date
as well. _Substantive._

## 6. For a study, record what it was not about

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Population · time horizon · method · effect size · **and the gap between what it measured and
what the work wants to say.** That gap is stated in the unit's body, not merely logged here.
_Substantive._

## 7. Check the conflations

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Check that the source has not itself confused, and that your entry does not repeat: a range rounded
into a headline · a projection quoted as a measurement · one group's figure quoted for everyone ·
an association quoted as a cause · an old figure quoted as current · plus the field-specific
conflations in the `fact-check` skill's mode file. _Substantive._

## 8. Don't stop where it's convenient

> **Skill:** `research` · **Guide:** `research/docs/reference/vetting-evidence.md`

When you find the source that agrees with the author's interest, **keep going.** Where pushing past
that point changed the answer, write that into the entry: the author wants it on the page.
_Substantive._

## 9. For a legal claim, name the jurisdiction and the date

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Say which jurisdiction, as at which date, and say plainly where the matter is unsettled. Never pick
the ruling that suits the argument, and never cite a section number you have not read in the
statute itself. _Substantive._

## 10. Assign the verdict

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Exactly one of: `verified` (give the citation) · `verified-with-caveat` (**state the narrower
wording the work may use**) · `contested` (summarise the disagreement; do not resolve or average
it) · `thin` (usable only if the prose says so) · `cannot-be-dated` (recommend cutting) ·
`unsupported` (recommend cutting). Never `verified` without a real source in hand. _Substantive._

## 11. Write the entry

> **Skill:** `fact-check` · **Guide:** `research/src/evidence/CONTEXT.md`

`research/src/evidence/<topic>.md`, named for the claim's subject, in the entry format: the claim
as checked, the source, both dates, the basis, the limits, the verdict and usable wording, the
units it serves. Never overwrite an earlier entry; supersede it under `## History`. _Substantive._

## 12. Key the source and snapshot

> **Skill:** add-reference, where present · **Guide:** `research/docs/reference/ingesting-sources.md`

Where the project keeps the citation database, key the source with the add-reference skill and record the
key in the entry, then:

```sh
make dump    # snapshot the database to text; commit it
make refs    # regenerate the citation data the build reads
```

Minting the key is judgement; the `make` runs are mechanical. _Substantive._

## 13. Report the flags

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

List the `VERIFY` flags this verdict clears and those it keeps. A flag leaves the prose only when
the prose matches the usable wording; a `cannot-be-dated` or `unsupported` claim keeps its flag
until the author cuts or replaces it. The `final` gate needs zero. _Substantive._

## 14. Hand back

> **Skill:** `fact-check` · **Guide:** `research/docs/reference/vetting-evidence.md`

Return the verdict, the key, the entry's location and, where the claim narrowed, the exact wording
the unit may use. **Say plainly where a fact tells against the work's convenience.** _Substantive._
