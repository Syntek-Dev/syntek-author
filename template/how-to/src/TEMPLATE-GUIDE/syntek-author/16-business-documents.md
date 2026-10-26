# Business documents — families, the register and issuing

A business library holds documents that other people rely on: proposals, contracts, policies, letters and reports.
Every document belongs to a family, every finished one has a row in a register, and a document is issued only when it is ready.
This chapter shows how a business project keeps each of those true, and the checks that guard the words a client reads; the glossary, `how-to/src/TEMPLATE-GUIDE/syntek-author/17-glossary.md`, explains any word you do not know.

## Document families

A document family is a kind of document with its own folder, standard, skill and procedure for creating one.
Every business project has the business family, whose skill is `business-documents`.
It covers proposals, statements of work, business plans, onboarding packs, client guides, intake questionnaires, meeting notes and company documents.
Its folder is `library/src/business/`, and each client's folder and facts start there, in `library/src/business/client-docs/`.
`library/workflows/10-create-a-business-document/` creates a new one, and `library/docs/reference/business-standards.md` holds the family's standard.
The other families are chosen in the `BUSINESS_FAMILIES` answer.
They are legal documents, email, accounting, social media, and a managed-service family for IT policies and reports.
Each chosen family brings its own folder, standard, skill and create procedure, which `.claude/rules/syntek-author/02-skills.md` lists for this project.
To add or drop a family, update with the whole list of families you want, as `how-to/src/TEMPLATE-GUIDE/syntek-author/04-the-answers.md` explains.
Dropping a family deletes its template files, but keeps every document you wrote in its folder.

## The register and approvals

The document register, `planning/src/document-register.md`, holds one row for every registered document, for life.
Each row has an ID such as `DOC-001`, which never changes and is never reused, even when the document is retired.
A document is registered at the end of its line edit, before its issue proof, by `planning/workflows/08-update-the-register/`.
The same procedure records a new version, a change of status or a retirement, and never deletes a row.
When an agreement is signed, a policy approved or a notice issued, `planning/workflows/07-record-an-approval/` records what happened.
It confirms every detail with you, writes the record in `planning/src/approvals/`, and moves the document's register row on.
It records an approval, and never decides that something was approved.
Documents due a review are listed in `planning/src/review-schedule.md`, and `planning/workflows/06-run-a-review-cycle/` reviews them.
Where two documents could conflict, `planning/src/precedence.md` says which one wins.

## Issuing a document

A proof of a document is free: `make pdf FILE=…` builds one into `build/` at any status, and changes nothing.
Issuing makes the copy you send, the record of what the client received.
To issue, add `ISSUE=1` to the same command.
It issues only at a status you allow, `final` unless your build settings in `tooling/project.mk` say otherwise.
It refuses while the document holds an open item, and nothing overrides that.
It also refuses to replace a copy already issued, unless you add `FORCE=1` as well.
Where your binary files stay in the repository, the issued copy is written beside its source, for you to commit.
Where they live under the data root, it is filed there and listed, and `FORCE=1` keeps the old copy, marked as superseded.
An open item is a flag, `AUTHOR TO CONFIRM` or `VERIFY`, or a field still waiting for an answer.
An unfilled field reads `[AWAITING USER INPUT]` in a Markdown document and `\fillme` in a LaTeX one, and is never filled with a guess.
This command lists every open item in the project:

```bash
make flags
```

Each one is listed with its file and line, and the document's own count must reach zero before it can be issued.

## Words that are checked

A client reads every sentence as a promise, so a business project checks its words more closely than a book.
`clause-consistency` checks that each defined term is defined once and used the same way throughout, and that every cross-reference resolves.
`obligation-check` checks that 'shall', 'may' and 'must' are each chosen on purpose, that no 'will' is left open, and that every commitment traces to a clause.
`tone` holds the house voice and plain English, and never changes a figure, a date, a scope or a commitment.
Technical text, such as a procedure or a client guide's steps, is written in Simplified Technical English where it fits.
`library/docs/reference/simplified-technical-english.md` explains it, in the template's own words.
Client-facing copy uses no em dashes, and this command reports any, with lines that hold more than one sentence and American spellings:

```bash
make lint
```

It also reports list steps of more than twenty words in technical text, as a hint rather than a rule.
Where a section is promoted into a LaTeX document, `make section-check` proves the LaTeX carries exactly the words you approved.
`library/workflows/05-review-a-document/` runs every check in order, ending with the issue-readiness check.
`standards/verification/BUSINESS.md` numbers these checks.

## Google Drive

Some businesses keep a copy of their issued documents in Google Drive.
Where you chose Google Drive as your provider and keep your binary files in the repository, the project ships Drive workflows.
These push and pull workflows run on GitHub's servers, not on your machine.
They sit in the project's `.github` folder, and use your own Google credentials, stored as secrets on the repository.
The push uploads only issued, final copies, never a draft.
The pull brings Drive's changes back, and never overwrites a file that differs: it saves a dated copy beside it and reports it.
Any other provider, or keeping your binary files under the data root, removes the workflows, your edits to them included, on the next update.
Under the data root, keep a copy with the service you named instead, as `how-to/src/TEMPLATE-GUIDE/the-data-root.md` explains.

## Where the rules live

- `.claude/rules/syntek-author/03-authorship.md` Section 7 holds the business rules: obligations are never invented, and an unfilled field is never guessed.
- `.claude/rules/syntek-author/04-build-pipeline.md` says how issuing works and what it refuses.
- `standards/method/BUSINESS.md` holds the business method, `standards/verification/BUSINESS.md` its gates, and `standards/brand/` your brand voice and disclaimers.
- `.claude/rules/syntek-author/02-skills.md` Section 5 lists the business skills and this project's families.

## Next

- The loop every section goes through → `how-to/src/TEMPLATE-GUIDE/syntek-author/07-the-writing-loop.md`
- Proofs, flags and checks → `how-to/src/TEMPLATE-GUIDE/syntek-author/08-building-proofs.md`
- Where issued copies and scans live → `how-to/src/TEMPLATE-GUIDE/the-data-root.md`
