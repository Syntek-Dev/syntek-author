# CONTEXT.md — research/src/evidence/

The project's checked claims: one entry per figure, date, study finding or legal statement the work
will make, each written with enough provenance that a hostile reader could check it and a future
reader could re-check it. Empty at generation. Every entry arrives through
`research/workflows/02-verify-a-claim/` and carries one of the six verdicts; reading notes on whole
works live in `research/src/sources/`, and answers to wider questions in `research/src/notes/`.

## Directory Tree

```text
research/src/evidence/
├── CONTEXT.md            ← this file: the entry format
├── CLAUDE.md             ← operating rules
└── <topic>.md            ← one entry per claim, named for the claim's subject
```

## What's here

**Each entry carries:** the claim as checked, in one sentence · the source, with its URL or
locator · the date the fact was established · the date it was checked · the basis (what was
measured or decided, by whom, at what scale, by what method, over what scope) · for a study, its
population, time horizon, method and effect size, and **what it was not about** · for a legal
claim, the jurisdiction and the date · where pushing past the first agreeable source changed the
answer · the verdict · the narrower usable wording, where there is one · the units it serves · the
citation key, where the project keeps the citation database.

```markdown
---
claim: "One checkable sentence, exactly as checked."
verdict: verified        # verified | verified-with-caveat | contested | thin | cannot-be-dated | unsupported
established: DD/MM/YYYY  # when the fact was established, not when it was quoted
checked: DD/MM/YYYY      # when it was checked; re-check beyond about twelve months
serves: []               # unit slugs, e.g. [03-the-ford]
key: ""                  # citation key, where the project keeps the citation database
---

# <The claim's subject, in a few words>

## Source
## Basis
## Limits
## Verdict and usable wording
## History
```

`## Limits` holds what a study was not about and the gap to what the work wants to say.
`## History` holds dated additions: an entry is superseded, never rewritten.

## Cross-references

- `research/docs/reference/vetting-evidence.md` — the five things a claim carries; the verdicts.
- `research/workflows/02-verify-a-claim/` — the only way in.
- `standards/verification/verification.md` — the fact-check gate these entries satisfy.
- `.claude/rules/syntek-author/03-authorship.md` — the `VERIFY` flag a verdict clears or keeps.
