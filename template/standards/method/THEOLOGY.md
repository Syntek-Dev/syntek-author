# THEOLOGY.md — how a theology project argues

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The method particular to a theology project, read with `method.md`. `category-check` enforces
rules 1 and 2; `argument-audit` enforces rule 3; `tradition-check` enforces rule 4; `steelman`
enforces rules 5 to 8; `draft-section` writes to all of them and labels each move it drafts with
its category. The examples below use bracketed placeholders on purpose: an example quotation in
a standard would be a fabricated one.

Dates DD/MM/YYYY; Scripture by book, chapter and verse, with the translation named.

---

## 1. Six claim categories

**Requirement.** Every substantive sentence makes one of six kinds of claim, and the reader can
always tell which:

| Category | What it is | How the prose signals it | How it is checked |
|---|---|---|---|
| **Biblical text** | The words of the passage, quoted | Quotation marks, reference, translation named | Against the named translation |
| **Textual observation** | What anyone can see in the text: a repeated word, a verb's form, the order of clauses | 'The text says…', 'Notice that…' | Against the text and, for original-language claims, a cited lexicon or grammar |
| **Interpretive inference** | What an observation implies; argued, and could be otherwise | 'This suggests…', 'It follows that…' | Against the argument map: premises stated, alternatives named |
| **Historical interpretation** | How a tradition, writer or period has read the passage | '[Tradition] has read this as…' | Against a cited source |
| **Theological conclusion** | The author's own claim, built from several passages and inferences | 'I conclude…', 'This work holds…' | Against the inferences it rests on |
| **Pastoral application** | What a reader or a church might do in the light of it | 'For a church today, this might mean…' | Against the conclusion it applies; the most contestable move |

**Why this rule exists.** A theological argument is only as honest as its seams. A reader who
cannot tell an observation from an inference cannot disagree at the right place, and so either
swallows the whole or rejects the whole.

---

## 2. Never collapse a category silently

**Requirement.** No sentence presents one category as another. The common collapses:

- **inference presented as text** ('Scripture teaches…' introducing what is in fact a reading);
- **conclusion presented as history** ('The Church has always held…' for the author's view);
- **application presented as exegesis** (a practice for today stated as the passage's meaning);
- **an unsignalled move from one passage to systematic theology** (a conclusion drawn from a
  single verse as though the whole canon had been consulted).

> **Wrong:** 'The text commands every church to [practice].'
>
> **Right:** '[Book chapter:verse] tells its first readers to [action]. The verb is [form],
> which suggests [inference]. [Tradition] has read it as [other reading]. I conclude [conclusion],
> and for a church today that might mean [practice].'

**Why this rule exists.** A silent collapse borrows the authority of the text for a claim the
text does not make. It is the commonest way a sincere argument becomes a misleading one.

---

## 3. Argue from a map

**Requirement.** Before a unit is drafted, its argument is mapped in
`planning/src/arguments/<unit>.md`, named as its brief: the claim → the supporting claims → the
evidence for each → the objections → the concessions. Prose is drafted from the map; where
drafting reveals a better argument, the map changes first, with the author.

**Why this rule exists.** An argument drafted straight into prose hides its missing premises in
good sentences. A map shows the gap while it is cheap to fill.

---

## 4. Name the contested reading in the body

**Requirement.** Where the work leans on a passage the Church reads in more than one way, the
main text says which reading is adopted, who holds the others, and what would change if another
were right. Each reading is stated so that its holders would recognise it. The map of readings
lives in `research/src/contested-readings/`; a contested passage is never drafted from memory.

**Why this rule exists.** A contested reading tucked into a footnote, or not mentioned, tells
the readers who hold it that they were not considered, and they stop reading in good faith.

---

## 5. Concede before rebutting

**Requirement.** Where the work answers an objection or a cost, the concession is a passage of
the body, at full strength and in its holders' terms, **positioned ahead of** the response. A
concession does not count if it is in the same sentence as its rebuttal, in a footnote, stated
in the author's summary rather than its holders' words, or framed only in the terms that make it
look small.

**Why this rule exists.** Check the order on the page, not the presence of concessionary words:
a reader who catches one rigged concession stops trusting every answer after it.

---

## 6. Steelman, or do not bother

**Requirement.** An objection is stated so that someone who holds it would say 'yes, that is
what I think'. Three tests: **recognition** (would its holder recognise it?), **ease** (if the
answer came easily, the objection was too weak) and **omission** (what is the strongest thing an
opponent would say that the draft does not mention at all?). A steelman is the best version of a
view someone actually holds, never an invented difficulty.

**Why this rule exists.** Answering a weak version of an objection persuades only the readers
who already agree, and omission is the commonest way a steelman fails.

---

## 7. An objection may be left standing

**Requirement.** An objection the work cannot answer is named as unanswered when it is raised,
never quietly dropped and never answered by implication later. Which objections stand is the
author's decision, recorded in `.claude/MEMORY.md` `## Decisions` (mapped in `00-project.md`
`## Memory headings`). A later unit that quietly answers a designated standing objection is a
defect in that unit, reported to the author.

**Why this rule exists.** A work that resolves every objection it raises tells the reader it was
never at risk. One honest 'I do not have an answer to this' makes the other answers credible.

---

## 8. Bias declared, not neutralised

**Requirement.** Where the author has a stake in the question (a vocation, a tradition, an
income, a history), the work states it once, plainly, where the argument first depends on it,
and briefly again wherever a later unit leans on the same stake. Two failures: **hedging**
('naturally I have tried to stay balanced'), which turns a disclosure into a claim of
objectivity; and **over-performing**, a confession working so hard to be admired that it
becomes a credential. The reader should feel told, not reassured.

**Why this rule exists.** Where the argument runs in the author's favour and the evidence is
thin, the disclosure is what lets the reader weigh it; a disclosure that claims to have cured
the bias has become a licence for it.

---

## 9. Scripture and original languages are checked, never recalled

**Requirement.** Every quotation of Scripture is checked against the named translation, word for
word, before promotion; every reference is checked to the verse. Every claim about a Hebrew,
Aramaic or Greek word (its meaning, form or range) cites a lexicon or grammar, and stays flagged
`VERIFY` until it does. The default translation's key is in `00-project.md` `## Brief`.

**Why this rule exists.** A misquoted verse or an invented word-meaning is the error a careful
reader spots first, and in a theology work it discredits the argument that rests on it.
