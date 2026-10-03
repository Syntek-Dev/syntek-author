---
type: guide
skills: [draft-section, adapt-section, improve-section, promote-section, learn-voice]
model: opus
---

# Drafting with AI — the loop, who decides, and the record it leaves

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

**What it is.** Documents here are written in a loop between the author and the AI, one section
at a time. Either side may write the first version. Only the author decides what reaches the
document, and every step leaves a record that can be shown to a client who asks how a document
was written.

## The loop

| Step | Who writes | Skill | Section status afterwards |
|---|---|---|---|
| Draft | the AI, from the unit brief | `draft-section` | `ai-draft` |
| …or draft | the author | — | `author-draft` |
| Adapt | the AI, from the author's notes or edits | `adapt-section` | `adapted` |
| Improve | the AI proposes; the author accepts or rejects | `improve-section` | `improved` |
| Revise by hand | the author | — | `author-revised` |
| Promote | the AI, on the author's word | `promote-section` | `promoted` |
| Learn | the AI proposes; the author approves | `learn-voice` | — |

Adapt, improve and hand revision repeat in any order until the author is satisfied. Promotion
happens only when the author says so, in words.

## Who decides what

- **The author decides** every fact the document will be held to: prices, dates, service levels,
  scope boundaries, the counterparty's legal name, which document wins when two conflict, and
  whether a section is ready.
- **The AI proposes** wording, structure, alternatives for contested lines, and the questions the
  brief has not answered. It never settles an obligation by drafting one.
- **Neither guesses.** A gap is flagged: `AUTHOR TO CONFIRM` for a decision, `VERIFY` for a
  checkable claim. `make flags` lists both, and no document becomes `final` while either remains.

## The five questions every document answers first

Before a document's first section is drafted, its unit brief answers five questions. They are the
floor, not the process: the `grill-with-docs` skill sharpens them, in chat.

1. **The counterparty's full legal name**, as the public register shows it, never its website.
2. **The jurisdiction** the document is written for.
3. **The audience:** internal or external, and exactly who will read it.
4. **The existing material:** earlier versions, related documents, the template it starts from.
5. **The tone:** the formal register of an instrument, or the plain voice of running copy.

## The record

Each section has a ledger entry at `standards/style/ledger/<unit-slug>--<section-slug>.md`: the
AI original verbatim (when the AI drafted), the author's final text at promotion, and every
improvement accepted or rejected with the author's note. `tooling/provenance.py` measures how much
the author changed; `standards/style/ledger/provenance.md` lists every promoted section; and
`make provenance` prints the disclosure table for anyone who asks. Rejected improvements are the
clearest evidence of the author's voice, which is why `learn-voice` reads them first.

## How we apply it here

- One section per request. A document drafted in one pass has no useful record and no real
  approval.
- Prefer suggested changes to rewrites: a numbered diff, a reason per change, applied only where
  accepted.
- No improvement alters a figure, a date, a price, a scope boundary or a commitment; that is the
  author's work, raised as a question.
- Never overwrite a draft or a promoted section without the author's confirmation.

## Who implements it

- **Skills:** as in the loop table; `run-workflow` routes a request to the procedure.
- **Workflows:** `library/workflows/01-draft-a-section/` to
  `library/workflows/04-promote-a-section/`, and `library/workflows/07-learn-from-your-edits/`.

## Governing standard

`.claude/rules/syntek-author/03-authorship.md` is the authoring constitution: who decides, the two
flags, never fabricate, provenance. It owns the rules; this guide owns how the loop runs for a
business document.
