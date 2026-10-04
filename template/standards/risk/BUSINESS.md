# BUSINESS.md — confidentiality and disclaimers

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

The risks particular to business, legal and client documents, read with `risk.md`.
`obligation-check` applies rule 5; `structure-review` checks the rest through its risk lens;
`draft-section` writes to them, and inserts the disclaimer rule 4 requires.

Dates DD/MM/YYYY.

---

## 1. Client material stays in its client's folder

**Requirement.** A client's name, contacts, figures, terms and documents appear only in that
client's own folders in the content layer (their facts once, in the file `00-project.md`
`## Paths` names, 'Client facts') and in the documents addressed to them. Templates, standards,
guides, skills and examples use invented parties, named only by their defined terms.

**Why this rule exists.** A clause or an example copied from one client's documents into another
client's leaks the first client's commercial position, and a template that names a real client
publishes their relationship with you.

---

## 2. Credentials never enter a document or a conversation

**Requirement.** Passwords, keys, recovery codes and account details are never written into a
document, a draft or a chat. A folder that must hold credential handovers is ignored by git by
default, with only its `CONTEXT.md` and `CLAUDE.md` re-included, and denied to Claude in the
project settings. No skill reads it, copies from it, or summarises it, and no `make` target scans
it: every scan skips what git ignores.

**Why this rule exists.** A credential in a repository is a credential in every clone, backup and
synchronised copy of it, for ever.

---

## 3. Personal data is the minimum the document needs

**Requirement.** A document holds only the personal data its purpose requires, under the data
protection law of the jurisdiction in `00-project.md` `## Brief`. An accommodation for a named
recipient (a format, a reading need) is recorded only on the author's instruction, as the
preference alone: never its reason, and never a diagnosis.

**Why this rule exists.** Every extra name, address or detail in a document is a data
protection obligation the business must later honour, and health information is special-category
data.

---

## 4. A disclaimer by document class, from one file

**Requirement.** A document that needs a disclaimer carries the wording for its class from
`standards/brand/disclaimers.md` (or the file `00-project.md` `## Paths` names instead,
'Disclaimers'), unchanged and in the position that file gives. A document issued without its
class's disclaimer records the author's waiver in an internal note (`<!-- INTERNAL NOTE: … -->`
in Markdown, a `%` comment block in LaTeX), so a later pass does not add it back.

**Why this rule exists.** Disclaimer wordings copied by hand drift until no two documents say the
same thing, and an inconsistent disclaimer is weaker evidence than a consistent one.

---

## 5. Regulated and professional claims are earned

**Requirement.** No document claims a certification, an accreditation, a guarantee or compliance
with a standard or a law without the evidence for it, checked and dated (`VERIFY` until then).
Legal, financial and tax statements are written as information, not advice, unless the author is
qualified and insured to give that advice and has said so.

**Why this rule exists.** 'Certified to' and 'guaranteed' are representations a counterparty can
rely on and sue on; a claim that cannot be evidenced is a liability, not marketing.

---

## 6. Nothing leaves the repository unreviewed

**Requirement.** Drafts are never shared with a client or synchronised to a shared drive; only a
document the author has approved for issue leaves the repository. A document sent to the wrong
recipient is reported to the author at once.

**Why this rule exists.** A draft carries drafting notes, open flags and positions the author has
not settled; once a counterparty has read it, it cannot be unread.
