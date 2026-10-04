# review-schedule.md — when each document is next reviewed

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides and skills which route here point at something real from day one. Until the
> first document with a review cycle is registered, it holds no entries.

When each registered document is next due for review, and whether that review has happened.
`planning/workflows/06-run-a-review-cycle/` works from this file; `planning/docs/reference/the-document-register.md` gives the accepted values.

## Writing rules

1. **One row per registered document that has a review cycle**, keyed by its `DOC-NNN`.
   The `Document Name` and `Category` match the register exactly.
2. **`Review Cycle` is** `Quarterly`, `Bi-Annual` (every six months), `Annual` or `As-Required`.
3. **`Status` is** `Scheduled`, `In Progress`, `Completed` or `Overdue`, or `N/A` for a retired document (rule 5).
   A row is `Overdue` when its `Next Review Date` has passed and it is not `Completed`; report every `Overdue` row to the author before doing anything else with this file.
4. **Rows sit under their family's heading**, as in the register, grouped by cycle, most frequent first.
5. **A retired document's row** is marked `N/A` in `Status` or removed, as the author decides, and the register keeps its history either way.
6. **Update `Last Updated` above on every edit.**

## Business

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>
## Legal

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: endif :><: if DOC_TYPE == 'business' and 'email' in BUSINESS_FAMILIES :>
## Email

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: endif :><: if DOC_TYPE == 'business' and 'accounting' in BUSINESS_FAMILIES :>
## Accounting

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: endif :><: if DOC_TYPE == 'business' and 'social-media' in BUSINESS_FAMILIES :>
## Social Media

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>
## MSP-SCP

| Document ID | Document Name | Category | Review Cycle | Last Review Date | Next Review Date | Reviewer | Status |
|---|---|---|---|---|---|---|---|
<: endif -:>
