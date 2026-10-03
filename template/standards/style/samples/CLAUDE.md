@./CONTEXT.md

# CLAUDE.md — standards/style/samples/

Read order: `.claude/CLAUDE.md` → `.claude/MEMORY.md` → `standards/CONTEXT.md` →
`standards/CLAUDE.md` → `standards/style/CONTEXT.md` → `standards/style/CLAUDE.md` → this
folder's `CONTEXT.md` (imported above) → this file.

## Purpose (one line)

Keep the author's own writing, untouched, as the evidence every voice decision is tested
against.

## How to work here

- **Routing:** `learn-voice` reads the samples to propose voice marks; `draft-section` reads
  them beside `voice-notes.md`. Neither writes here.
- **Model:** **Opus** for reading a sample for voice; nothing here is mechanical work.
- **Concrete steps (when the author offers a sample):**
  1. Save it verbatim as `NN-kebab-description.md`, numbered after the last sample.
  2. Add the frontmatter (`source`, `written`, `register`, `notes`) from what the author says,
     asking rather than guessing.
  3. Tell the author how many samples exist per register, and whether `learn-voice` now has the
     three it needs for that register.
- **Definition of done:** the sample is saved exactly as the author gave it, with frontmatter the
  author confirmed.

## Guardrails

- **Only the author's own writing.** A passage by someone else, however admired, is a model,
  not a sample: it does not belong here, because the voice notes would then describe someone
  else.
- **Never edit a sample.** Not a typo, not a spelling, not a line break. A corrected sample is
  evidence of the corrector.
- **Never AI text.** Not even a draft the author later approved; that belongs in the ledger,
  where its provenance is recorded.
- **Never quote a sample in the work.** Samples may hold private writing; they are read, not
  reused.
- **Privacy.** If a sample names real people or private matters, tell the author and suggest a
  redacted copy they make themselves.

## Output & naming

- **Added by the author:** `NN-kebab-description.md`, two-digit numbering in the order added.
- **Generated:** nothing.
