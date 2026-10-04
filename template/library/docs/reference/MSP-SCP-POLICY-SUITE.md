# MSP-SCP-POLICY-SUITE.md — the suite's order, the policy structure and the operational parts

**Last Updated**: <%DATE%> **Version**: 0.1.0 **Maintained By**: <%AUTHOR_NAME%>
**Language**: British English (en_GB)

A sub-document of `library/docs/reference/msp-scp-standards.md`, which is its index. Read that
guide first; this file holds the detail it routes here.

## The suite, in reading order

| NN | Document | Review cycle |
|---|---|---|
| 01 | Data processing agreement | yearly, or on a change in the law |
| 02 | Information security policy | every six months |
| 03 | Password and authentication policy | every six months |
| 04 | Acceptable use policy | yearly |
| 05 | Incident response plan | every six months |
| 06 | Data retention and disposal policy | yearly |
| 07 | Sub-processor register | yearly, and on any change of processor |
| 08 | Service level agreement | per engagement; the template yearly |
| 09 | Privacy notice | yearly, or on a change in the law |
| 10 | Change management policy | yearly |

The numbers keep a suite in one order everywhere. A suite written for a client keeps the same
numbers for the same documents and leaves a gap where a document is not needed. A document added
to the suite takes the next free number; numbers are never reused.

**Unscheduled review** of any policy, whatever its Next review date, follows: a change in the law
or the regulator's guidance; a security incident touching the policy's scope; a material change to
the business's infrastructure or services; a new client needing a framework the suite does not
yet meet; a gap found in an audit.

## The structure every policy follows

1. **Purpose and scope** — what the policy governs and whom it binds.
2. **The policy** — numbered sections, one rule area each, every rule a must or shall statement.
3. **Roles and responsibilities** — a table: who owns, who approves, who must follow.
4. **Compliance and enforcement** — what follows a breach, stated plainly.
5. **Review and approval** — the cycle, the approver, how a change is made.
6. **Version history** — Version · Date · Author · Change description · Approved by.

Where a section maps to a control in a recognised framework, an alignment note closes it:
`\textbf{Alignment:}` followed by the framework and the control, each verified against the
framework's current edition before it is written.

## The operational documents

- **Client runbook:** the client and its contacts by role (cited from its `## Facts`); the systems
  in scope; routine tasks and their schedule; how to escalate; where each credential is kept (never
  the credential); recovery steps.
- **Network topology:** the sites, the devices by role, the connections and the security
  boundaries; a diagram with a legend; what changed since the last version.
- **Monthly service report:** the period; tickets by severity against the service levels; uptime;
  changes made; security events; recommendations; next period's planned work.
- **Incident report:** the timeline (detected, contained, resolved); the severity; the impact and
  the data affected; the cause; the actions taken; whether a regulator or data subject must be
  told (the author decides, `VERIFY` the deadline); the lessons and the follow-up actions.
- **Change request:** the change; the reason; the risk and the rollback; the window; who approves;
  the outcome, filled in afterwards.
