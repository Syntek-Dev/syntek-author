---
workflow: 02-verify-a-claim
phase: research
skills: [fact-check, research]
model: opus
---

# CHECKLIST.md — verify a claim

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **See** `research/docs/reference/vetting-evidence.md` and the `fact-check` skill. The fact-check
> gate is set by `standards/verification/verification.md`; this list never restates it.

## Pre-Conditions

- [ ] Read `.claude/CLAUDE.md` and `.claude/MEMORY.md`, then this folder's `CONTEXT.md` and `CLAUDE.md`. · _sonnet_
- [ ] Read `research/docs/reference/vetting-evidence.md`. · _opus_
- [ ] Know which unit the claim is for, and whether this is a check before drafting or a re-check before export. · _sonnet_

## Execution Checklist

**Framing**

- [ ] **Claim isolated as one checkable sentence**; if it could not be, that was reported as the finding and the procedure stopped. · _opus_
- [ ] `research/src/evidence/` searched for an existing entry; a current one reused, an old one re-checked and superseded. · _sonnet_
- [ ] The basis identified before searching: what is claimed · source · when · how · scope. · _opus_

**Checking**

- [ ] **Primary source reached** at its origin; the chain followed back past every secondary report. · _opus_
- [ ] **Two dates recorded:** established, and checked; the accessed date for any web page. · _opus_
- [ ] For a study: population, horizon, method, effect size, **and what it was not about**, with the gap to the work's claim stated. · _opus_
- [ ] Conflations checked, including the field-specific ones in the `fact-check` mode file. · _opus_
- [ ] **Kept going past the first agreeable source;** where that changed the answer, it is in the entry. · _opus_
- [ ] For a legal claim: jurisdiction and date named, unsettled parts said plainly, no section number cited unread. · _opus_
- [ ] Claims about the author checked against `.claude/MEMORY.md` (Facts) and, where silent, put to the author. · _opus_

**Recording**

- [ ] Verdict is exactly one of `verified` · `verified-with-caveat` · `contested` · `thin` · `cannot-be-dated` · `unsupported`. · _opus_
- [ ] Where `verified-with-caveat`: **the narrower usable wording supplied**. · _opus_
- [ ] Where `contested`: the disagreement summarised, **not averaged or resolved**. · _opus_
- [ ] Entry written to `research/src/evidence/<topic>.md`; no earlier entry overwritten. · _sonnet_
- [ ] Source keyed with the add-reference skill, and `make dump` and `make refs` run, where the citation database exists. · _sonnet_
- [ ] `VERIFY` flags reported: those cleared, and those kept. · _opus_

## Done When

- [ ] **Every claim checked has a verdict, a primary source, a complete basis and two dates.** · _opus_
- [ ] Nothing lacking a basis was hedged into the work; it was recommended for cutting. · _opus_
- [ ] The gap between what a study measured and what the work wants to say is explicit, and the unit has been told to state it. · _opus_
- [ ] The drafting side has the verdict, the key and the exact wording it may use. · _opus_
