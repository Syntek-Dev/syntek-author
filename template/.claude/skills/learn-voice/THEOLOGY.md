# THEOLOGY.md — learn-voice, theology mode

The domain for learning the voice of a work of Christian theology: which entries are mined, the
two registers the voice is sorted into, and the changes that are method rather than voice.

## Paths and unit

- **Procedure:** `manuscript/workflows/07-learn-from-your-edits/`.
- **Entries mined (step 1):** every ledger entry with `learned: false`. One with a `promoted`
  date is mined whole; one whose section is not yet promoted lends only its
  `## Improvement decisions` and stays unlearned, because its author final is still to come.
- **Registers (step 4):** the main text, accessible to every reader; and the footnotes, the
  scholarly apparatus (`manuscript/docs/reference/main-text-and-footnotes.md`). The voice notes
  keep a section for each under `## Registers`.
- **Homes (steps 4 and 7):** a voice habit goes under `## Learned` in
  `standards/style/voice-notes.md`; a mechanical habit to `standards/style/style-sheet.md`; a
  preferred term (a translation of a technical word, say) to `standards/style/terminology.md`;
  each written there only as an approved, dated entry. A change to `standards/method/` is a
  proposal to the author only.
- **Method:** `standards/method/THEOLOGY.md`.

## Additions to the steps

- **Step 3 — also set aside changes of category and argument.** An edit that moved a sentence
  from one claim category to another, added a concession, or softened a conclusion into a
  consensus is a change to the argument, governed by `standards/method/THEOLOGY.md`, not a voice
  habit. A corrected Scripture quotation or reference is a correction of fact.
- **Step 4 — also keep the registers apart.** A habit seen in the footnotes is not evidence for
  the main text, and the reverse. Name the register on every pattern.
- **Step 6 — also flag a pattern that brushes the method.** Where a voice habit would make a
  category harder to hear (for example, cutting every 'on this reading'), say so beside the
  proposal: the method wins over the voice.

## Domain rules

- **The voice never overrides the method.** A habit that would collapse a claim category, or move
  a concession behind its response, is recorded as a conflict, never as a note
  (`standards/method/THEOLOGY.md` Sections 2 and 5).
- **The author's first person is part of the method**: 'I hold' marks the author's own
  conclusion (Section 1, the theological-conclusion category). A pattern of the author owning a
  conclusion is voice and method at once, and the note says so.

## Examples

An invented `## Learned` bullet, as written after approval:

```markdown
- **DD/MM/YYYY** — **Open a section with the reader's question, not the scholar's.** Before: 'Scholars have long debated the meaning of the verb here.' After: 'What does the verb mean for a reader who has only this translation?' (from `03-kebab-title--the-verb` and `04-kebab-title--opening`)
```

An invented conflict, listed for the author:

```text
Conflict: three rejections show you cutting 'on this reading', but the method needs it to signal
an interpretive inference. Keep the method and drop the pattern, or record a lighter signal?
```
