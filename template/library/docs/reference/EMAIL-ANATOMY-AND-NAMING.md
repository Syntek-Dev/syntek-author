# EMAIL-ANATOMY-AND-NAMING.md — the authored email's parts, its name and its checks

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

A sub-document of `library/docs/reference/email-standards.md`, which is its index. Read that
guide first; this file holds the detail it routes here.

## The four parts, in order

1. **The title:** `# Email: <purpose>, <recipient>, <DD/MM/YYYY>`.
2. **The metadata block:** four lines, each ending in two spaces so it does not run together.
3. **The internal note:** a blockquote opening 'Internal note, not to be sent.'
4. **A horizontal rule,** then the `**Subject:**` line, then the body between its section markers,
   `<!-- section: body -->` and `<!-- end section: body -->`, where the loop promotes it.

Above the title sits the loop's frontmatter (`unit:`, `status:`, `last_updated:`), kept in step
with the email's brief. Nothing above the rule is ever sent; a paste copy strips it.

```markdown
**To:** [Name], [Title], [Organisation]. [email]
**From:** [Sender], [trading name]. [email]
**Attachment:** `[filename].pdf` (or: None)
**Status:** Draft, not yet sent
```

`**Status:**` moves from Draft to sent only on the author's word.

**The internal note** is the working record and the most valuable part of the file. It carries:
the drafting decisions and why; every source checked, with the date checked; every authorised
departure from a house rule, stated as one, so a later pass does not 'correct' it; and everything
to resolve before sending (an unconfirmed name, a pending permission, a contradiction with another
unsent email). Be blunt in it: it is never sent.

## Naming

- An authored email is named from its subject line: `<subject-line>-<DD-MM-YYYY>.md`.
- Lower case, punctuation dropped, spaces to hyphens; no `email-` prefix, since the folder already
  says what it is.
- The stem is exactly as long as the subject and changes only when the subject does: settle the
  subject, then name the file. A renamed email has every reference to it updated, the register
  row's path included.
- An archived thread keeps its export name, and is never renamed to this pattern.
- A derived paste copy (HTML or rich text) takes the same stem and is regenerated, never edited.

## Markdown that survives a paste

- A line break inside a block needs two trailing spaces, or the lines run together.
- A link is written `<https://…>`, or it does not become a link.

## Before an authored email is complete

- [ ] The four parts present, in order, and the `**Status:**` line accurate and untouched.
- [ ] The internal note records decisions, dated sources, departures and anything unresolved.
- [ ] The subject is 50 characters or fewer (60 at most), the matter first.
- [ ] It leads with the decision or the ask; nothing cut that was an ask, a caveat, a figure or a
      commitment.
- [ ] A follow-up recites no undertaking, counts no time and denies no chasing.
- [ ] Named from its subject line and dated; no em dashes; the business's person throughout.
- [ ] Line breaks and links survive a paste; no placeholder left unflagged.
- [ ] Read beside every other unsent email to the same correspondent.
- [ ] Listed in its folder's `CONTEXT.md` and registered in `planning/src/document-register.md`.
