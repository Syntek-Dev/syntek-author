# REQUIRED-SECTIONS-PLANS-AND-REPORTS.md — msp-scp-documents

The required sections of each **plan, report, register and agreement** in the msp-scp family.
Read with `SKILL.md` beside this file: its parts every document carries (title block, Document
Control, version history, disclaimer slot, review-date notice) come first and are not repeated in
these lists, and its conventions and checklist apply to every document here. Each numbered item is
one section of the body, in order: one section of the unit brief for a plan, register or
agreement, and one part of the template a report is filled from. Every column named here is a
`tabularx` (or `longtable`) column.

Response times, recovery targets, credits and periods come from the agreement or the client,
never from this file; every legal duty is verified with `fact-check` before it is cited.

## Incident response plan

1. Purpose and scope
2. Objectives
3. Definitions: what counts as an incident, and the severity levels
4. Severity classification (Severity · Definition · Initial response · Resolution target), from
   P1 critical to P4 low, the times taken from the agreement
5. Roles and responsibilities: the incident response team and on-call cover, by role
6. The phases: identification and triage; containment, short and long term; eradication;
   recovery; post-incident review with lessons learnt and a report
7. Communication: internal escalation, and external notification, including the duty under UK
   GDPR Article 33 to notify the Information Commissioner's Office of a personal data breach
   without undue delay and, where feasible, within 72 hours of becoming aware of it (unless it is
   unlikely to result in a risk to people), and Article 34 on telling the people affected
8. Evidence preservation
9. Contacts by role: the internal team, and external ones (the National Cyber Security Centre,
   legal advisers, communications, the cyber insurer)
10. The incident log template
11. The post-incident report template
12. Testing and exercises: tabletop and simulation, and their schedule
13. Related documents
14. Approval and sign-off

## Business continuity plan

1. Purpose and scope
2. Objectives
3. Critical processes (Process · Owner by role · Priority · Recovery time objective · Recovery
   point objective)
4. Recovery time and recovery point objectives: what each means, and the targets
5. Business impact analysis: the impact of losing each critical process
6. Recovery strategies in outline
7. IT disaster recovery: backup and restore, failover, cloud and off-site recovery
8. Recovery runbooks: one per critical system, numbered steps
9. Suppliers and service providers the plan depends on, and what their failure means
10. Communication: the internal escalation chain, and who tells customers, regulators and
    insurers
11. Alternative working arrangements
12. Testing and maintenance schedule
13. Training and awareness
14. Related documents
15. Approval and sign-off

## Security incident report

1. Summary: what happened, when, and the severity
2. Timeline (Date and time · Event · Source), in 24-hour time
3. Detection: how and when the incident was found
4. Impact: the systems, data and people affected
5. Containment, eradication and recovery: what was done, and when
6. Notifications made: the client, the Information Commissioner's Office where the breach duty
   applied, the people affected, and others, each with its date and time; whether a regulator or
   the people affected must be told is the author's decision, taken with advice, and its deadline
   carries `VERIFY` until checked
7. Root cause
8. Lessons and actions (Action · Owner by role · Due date)
9. Sign-off

A report records what happened and is never revised to read better; a correction is a dated
addendum.

## Vendor assessment report

1. Header: the vendor, its type, the risk level, the assessment date and the assessor by role
2. Scope and purpose
3. The vendor: registered name, number and address, checked on the public register
4. Data handling: the categories of data accessed, where they are stored and under which
   jurisdiction, retention and deletion
5. Security controls: access and identity, encryption at rest and in transit, network and
   perimeter, vulnerability management and patching
6. Incident response: detection, notification and response times
7. Certifications (for example ISO/IEC 27001, SOC 2, Cyber Essentials, PCI DSS), each with its
   scope and expiry, and the evidence seen
8. Regulatory compliance as relevant (for example UK GDPR, FCA rules, the NHS Data Security and
   Protection Toolkit)
9. Audit and penetration testing
10. Sub-processors and supply chain
11. Business continuity and disaster recovery
12. Risk summary (Category · Score 1 to 5 · Risk level · Notes)
13. Recommendations
14. Sign-off

## Sub-processor register

1. Header: the organisation, the data processing agreement it serves, the register owner by role
2. Why the register exists: the processor's duty under UK GDPR Article 28(2) to engage another
   processor only with the controller's prior written authorisation, specific or general, and,
   under a general authorisation, to tell the controller of any intended addition or replacement
   so that the controller can object
3. Controller notification: how and how far in advance controllers are told of an addition, a
   change or a removal, as the data processing agreement states it
4. The register (Sub-processor · Registered country · Processing activity · Data categories ·
   Lawful basis · Transfer safeguard · Date added · Date removed)
5. Risk summary: Low, Medium or High for each sub-processor, with the reason
6. Change log (Date · Change: add, amend or remove · Sub-processor · Reason · Controllers told on)
7. Review and maintenance schedule
8. Approval and sign-off

Each transfer safeguard names the mechanism in force on the date (for example UK adequacy
regulations, the ICO's International Data Transfer Agreement, or the UK Addendum to the EU
standard contractual clauses), checked with `fact-check`.

## Service level agreement

1. Header: the provider, the client, the service tier, the effective date, the agreement version
2. Purpose and scope, and the agreement it sits under, with precedence
3. The services: what each includes, and what is excluded
4. Performance targets (Measure · Target · How measured · Reporting frequency)
5. Severity and response (Severity · Definition · Initial response · Resolution target), P1 to P4
6. Escalation: tiers, contacts by role, methods and timings
7. Service credits (Target missed · Credit as a share of the monthly fee · Cap), and that credits
   are the sole remedy only where the agreement says so
8. Reporting and service reviews: frequency, format, attendees by role
9. Planned maintenance: windows, notice, and exclusion from the measures
10. The client's responsibilities, without which the targets do not apply
11. Exclusions and force majeure
12. Review and amendment
13. Approval and sign-off
