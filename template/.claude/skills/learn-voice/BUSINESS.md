# BUSINESS.md — learn-voice, business mode

The domain for learning the voice of a business's documents: which entries are mined, the
registers that never mix, and the homes a lesson may go to once the author approves it.

## Paths and unit

- **Procedure:** `library/workflows/07-learn-from-your-edits/`.
- **Entries mined (step 1):** every ledger entry with `learned: false`, grouped by document and
  by family: one with a `promoted` date whole, one not yet promoted for its
  `## Improvement decisions` only (it stays unlearned). A new project is seeded from three or more
  of the author's own pieces in `standards/style/samples/` instead.
- **Registers (step 4):** running copy (proposals, letters, emails, social media posts);
  instruments and policies; and short functional copy (labels, subject lines, notices). The voice
  notes keep running copy and microcopy under `## Registers`; a lesson about instruments is a
  drafting rule, not a voice note.
- **Homes (steps 4 and 7):** a voice habit goes under `## Learned` in
  `standards/style/voice-notes.md`; a preferred term to `standards/style/terminology.md`; a
  mechanical rule to `standards/style/style-sheet.md`; each written there only as an approved,
  dated bullet. A change to `standards/method/` or to the brand folder named in `00-project.md`
  `## Paths` is a proposal to the author only; a lesson about one document stays in that
  document's brief or internal note.
- **Further reading (step 2):** the brand voice, in the brand folder (by default
  `standards/brand/brand-voice.md`).

## Additions to the steps

- **Step 3 — also set aside changes to the substance.** A changed figure, date, price, scope
  boundary or commitment is about the document, not the voice; so is a correction to a defined
  term.
- **Step 4 — also keep the registers apart.** A lesson from editing a contract or a policy is
  never applied to proposals and emails, and the reverse.
- **Step 6 — also check against the brand.** Read each candidate against the brand voice; a
  pattern that contradicts it is listed as a conflict, quoting both, and the brand wins until the
  author says otherwise.
- **Step 7 — also write to each approved home.** An approved term or mechanical rule is written
  to `standards/style/terminology.md` or `standards/style/style-sheet.md` as a dated bullet, in the
  author's words, with its example. A rejected pattern is noted in the hand-back so it is not
  proposed again.

## Domain rules

- **The business's person is recorded, not learned.** Whether the documents speak as 'I' or 'we'
  is set by the voice person in `00-project.md` `## Brief` and the voice notes' `**Person.**`
  line; a pattern that seems to change it is raised with the author, never written as a note.
- **Never change a standard by learning** (`.claude/rules/syntek-author/06-global-rules.md`
  Section 3): method and brand changes are proposals only.
- **Rejections first**: a refused tone change says more about the house voice than an accepted
  one.

## Examples

An invented `## Learned` bullet, as written after approval:

```markdown
- **DD/MM/YYYY** — **Open a reply with the answer, not with thanks.** Before: 'Thank you for your email about the timeline.' After: 'The review starts on the agreed start date.' (from `example-reply--body` and `handbook-proposal--next-steps`)
```

An invented proposal with its home:

```text
3. Running copy · home: terminology.md
   You replaced 'deliverables' with 'what you receive' in four sections and rejected it back
   twice. Record 'what you receive' as the preferred term in running copy?
```
