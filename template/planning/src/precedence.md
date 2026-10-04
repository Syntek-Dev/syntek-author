# precedence.md — which instrument prevails

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

> **This file is a seeded stub, and it is deliberately unfinished.** It ships with the project so
> that the guides and skills which route here point at something real from day one. Until the
> first instrument that states an order of precedence is registered, it holds no entries.

When two related documents say different things, which one wins.
This file mirrors what the instruments themselves state; it never decides an order they leave open.
The `clause-consistency` skill checks every instrument against it.

## Writing rules

1. **Mirror, never decide.**
   Every row cites the clause that states the order (`Stated in`).
   An order no instrument states is not a row: it is an `AUTHOR TO CONFIRM` flag in the instrument that should state it.
2. **Rank 1 prevails** over every lower rank in the same table.
3. **One table per document family**, under its heading; add a heading for any other family whose documents can conflict, or for an engagement whose order differs from the family's.
   An order that runs across families (a proposal in one, the contract that follows it in another) sits under the family of the document that prevails.
4. **Name document types, not files**, so a new version does not need a new row.
   Where one engagement differs, name it in `Notes` by its register ID.
5. **Update `Last Updated` above on every edit.**

## Business

| Rank | Document type | Prevails over | Stated in | Notes |
|---|---|---|---|---|
<: if DOC_TYPE == 'business' and 'legal' in BUSINESS_FAMILIES :>
## Legal

| Rank | Document type | Prevails over | Stated in | Notes |
|---|---|---|---|---|
<: endif :><: if DOC_TYPE == 'business' and 'msp-scp' in BUSINESS_FAMILIES :>
## MSP-SCP

| Rank | Document type | Prevails over | Stated in | Notes |
|---|---|---|---|---|
<: endif -:>
