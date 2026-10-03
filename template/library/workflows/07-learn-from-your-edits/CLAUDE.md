@./CONTEXT.md

# CLAUDE.md — library/workflows/07-learn-from-your-edits/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `library/CONTEXT.md` →
`library/CLAUDE.md` → `library/workflows/CONTEXT.md` → `library/workflows/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file → `STEPS.md` (with `CHECKLIST.md` open).

## Purpose (one line)

Turn the author's real edits and rejections into voice notes the author has approved, so the next
draft starts closer to their voice.

## How to work here

- **Routing:** the `learn-voice` skill (with its `BUSINESS.md` mode file) is this procedure in skill
  form; `grill-with-docs` decides whether a lesson belongs in `.claude/MEMORY.md` as well. Guide:
  `library/docs/reference/drafting-with-ai.md`.
- **Model:** follow the checklist tags: **Opus** for reading edits, finding patterns and writing
  proposals; the mechanical tier for gathering entries and marking them learned.
- **Concrete steps:** follow `STEPS.md` in order and tick `CHECKLIST.md` as you go.
- **Definition of done:** every unlearned ledger entry has been read; each pattern proposed has at
  least two real examples; only approved additions are written; promoted entries that were mined
  are marked learned, and no unpromoted one.

## Guardrails

- **Evidence, not taste.** A pattern needs at least two instances from the ledger or the samples;
  one edit is a preference about one sentence.
- **Rejections first.** A rejected improvement says more about the author's voice than an accepted
  one.
- **Registers stay apart.** A lesson from editing a contract or a policy is a drafting rule for
  instruments, not a voice note for proposals and emails, and the reverse.
- **Write only what the author approves**, in the author's words where they gave any.
- **Never change a standard by learning.** A lesson that would change `standards/method/` or
  `standards/brand/` is put to the author as a proposal; a standards change is author-confirmed,
  always.
- **Never rewrite an earlier lesson.** If a new lesson contradicts an old one, append the new one
  and mark the old one superseded, with the date.

## Output & naming

- **Writes, on approval only:** `standards/style/voice-notes.md` `## Learned`;
  `standards/style/terminology.md`; `standards/style/style-sheet.md`.
- **Also writes:** `learned: true` in each mined, promoted ledger entry; a dated line in
  `.claude/MEMORY.md` `## Decisions` when the author makes a voice call.
- **Does not touch:** any document, any draft, any standard outside `standards/style/`.
