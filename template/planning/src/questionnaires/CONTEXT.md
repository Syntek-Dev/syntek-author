# CONTEXT.md — planning/src/questionnaires/

Questionnaires: a decision the author cannot settle alone, written as a document someone outside
the session can answer (an expert reader, a beta reader, an adviser, a stakeholder). Each file
carries one question per open point, with its context, and an answer stub under each. Written by
the `to-questionnaire` skill; the author sends every one. A questionnaire is the evidence for a
decision, never the record of it: the decision goes to its real home when the answers return.

## Directory Tree

```text
planning/src/questionnaires/
├── CONTEXT.md                                  ← this file
├── CLAUDE.md                                   ← operating rules
├── QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md          ← one per recipient and subject, as written
└── QUESTIONNAIRE-<SLUG>-DD-MM-YYYY-RETURNED.md ← the copy that came back, kept as received
```

## What's here

- `QUESTIONNAIRE-<SLUG>-DD-MM-YYYY.md` — a questionnaire, its `Status` line moving from `draft`
  to `sent` and `returned`, each with its date and only on the author's word.
- `…-RETURNED.md` — the recipient's answers, saved beside the original and never edited.
- The block a questionnaire leaves open is recorded under `Open questions` in
  `.claude/MEMORY.md`, which names the questionnaire's path; this folder holds no index.

## Cross-references

- `.claude/skills/to-questionnaire/SKILL.md` — the procedure and the document shape.
- `.claude/rules/syntek-author/08-naming-and-memory.md` — the filename form.
- `.claude/MEMORY.md` — `Open questions`, where each block is recorded until the answers return.
