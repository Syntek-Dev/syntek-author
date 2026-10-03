# Submissions tracker

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides which route here point at something real from day one. Until the first agent is
> queried, the tracker below has no rows.

The single source of truth for which agents have been queried, what each asked for and was sent, and what came back.
Kept by `proposal/workflows/03-update-the-tracker/`; read before every query.

## Rules

- **Status:** `to query` · `queried` · `requested` · `passed` · `offer` · `withdrawn` · `lapsed`.
  - `to query` — on the list; nothing sent.
    A drafted query is not a query.
  - `queried` — the author has sent it; *Sent* is the date the author sent it.
  - `requested` — the agent asked for more; record what (a partial or the full manuscript) and when it went.
  - `passed` — the agent declined; any reason is recorded verbatim.
  - `offer` — an offer of representation; tell the author at once.
  - `withdrawn` — the author withdrew the submission, for example after accepting another offer.
  - `lapsed` — the agency's stated response time passed with no reply (where none is stated, the author sets one).
- A reply is recorded as it came and never upgraded.
- Every open row has a next action and its date.
- Dates are DD/MM/YYYY.
- Corrections are appended below with a date; history is never overwritten.

## Tracker

| Agent | Agency | Why them | Their guidelines | Sent | Status | Reply | Requested | Next action | Due |
|---|---|---|---|---|---|---|---|---|---|

## Corrections

_No entries yet._
