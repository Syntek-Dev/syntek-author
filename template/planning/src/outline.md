# outline.md — the order of <%PROJECT_NAME%>

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides and skills which route here point at something real from day one. Until the
> first unit is planned with `planning/workflows/01-plan-a-unit/`, it holds no entries.

The one place the order of the whole work lives: one row per <%UNIT_NOUN%>, in reading order.
The plan for each <%UNIT_NOUN%> is in its brief in `planning/src/units/`, and its status is in that brief's frontmatter, not here.

## Writing rules

1. **One row per unit, in reading order.**
   Moving a row changes the work; record the decision in `.claude/MEMORY.md` with its date.
2. **One line per unit.**
   Say what the unit does for the reader, not what it contains.
   A unit that needs two lines is not yet settled; plan it before adding more.
3. **No status column.**
   Status lives in the brief's frontmatter; a copy here would drift.
4. **The unit name matches the brief and the content layer.**
   Rename all three together, and never once a section of the unit has a ledger entry.
<: if DOC_TYPE == 'theology' :>5. **Name the claim each chapter lands.**
   Read down the last column alone and the book's case should move, step by step, from its first question to its close.
<: endif :><: if DOC_TYPE == 'fiction' :>5. **Name the turn each chapter carries.**
   Read down the last column alone and the story should move: each line names what changes, and nothing merely happens next.
<: endif :><: if DOC_TYPE == 'business' :>5. **Name the reader each document serves.**
   Read down the last column alone and the programme should make sense: which documents, in what order, and for whom.
<: endif :>6. **One sentence per line**, applied when a row is edited.

<: if DOC_TYPE != 'business' :>## Parts

| Part | Units | What the part does |
|---|---|---|

<: endif :>## Units

| # | Unit | Working title | What it does for the reader |
|---|---|---|---|
