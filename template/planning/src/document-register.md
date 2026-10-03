# document-register.md — every registered document

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides and skills which route here point at something real from day one. Until the
> first document is registered with `planning/workflows/08-update-the-register/`, it holds no
> entries.

The publication record of every document in the library: what it is, where it lives, which version is current and where it stands.
The writing status of a document lives in its unit brief.
A document is registered at the end of its line edit, before the issue proof, and its `Status` here starts at `Draft`.
`planning/docs/reference/the-document-register.md` gives the accepted values for every column.

> **Scope.**
> Registered: instruments, policies, proposals, plans, reports, procedures, notices, templates and correspondence.
> Not registered: individual invoices, receipts, bank statements and raw data exports, which are financial records.

## Writing rules

1. **IDs are `DOC-NNN`**, the next in sequence across the whole register, permanent and never reused.
2. **One row per document, for life.**
   A new version keeps its ID; the row's `Version`, `File Path` and dates move to the new file.
   Never delete a row: a retired document is set to `Archived`, `Superseded` or `Terminated`, and its `Notes` name what replaced it.
3. **Columns stay in this order**, with the values the guide gives.
   `File Path` is relative to `library/src/`; `Version` is `vMAJOR.MINOR`, or `—` for a living document; dates are DD/MM/YYYY, or `—`.
4. **Rows sit under their family's heading**, in ID order.
5. **Update `Last Updated` above on every edit.**

## Proposals

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Contracts

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Policies

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Correspondence

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Finance

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|

## Marketing

| ID | Document Name | Category | Type | File Path | Version | Status | Owner | Created Date | Last Reviewed | Next Review Date | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|
