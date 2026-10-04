# REQUIRED-SECTIONS-POLICIES.md — msp-scp-documents

The required sections of each **policy** in the msp-scp family. Read with `SKILL.md` beside this
file: its parts every document carries (title block, Document Control, version history,
disclaimer slot, review-date notice) come first and are not repeated in these lists, and its
conventions and checklist apply to every policy here. Each numbered item is one section of the
body, in order, and one section of the unit brief.

Figures in these lists (lengths, protocol versions, periods) are recommended defaults to offer the
client with the reason, checked against current NCSC guidance at the date of drafting; the client
decides. Every legal basis is verified with `fact-check` before it is cited.

## Information security policy

1. Purpose and scope
2. Policy statement
3. Information security objectives
4. Roles and responsibilities (the policy owner, management, all staff), by role
5. Information classification (by reference to the data classification policy)
6. Asset management
7. Access control
8. Cryptography
9. Physical and environmental security
10. Operational security
11. Communications security
12. Supplier relationships
13. Incident management (by reference to the incident response plan)
14. Business continuity (by reference to the business continuity plan)
15. Compliance: legal, regulatory and contractual obligations
16. Policy review and update
17. Related documents
18. Approval and sign-off

## Password and authentication policy

1. Purpose and scope
2. Policy statement
3. Password requirements: minimum length (recommended at least 12 characters for standard
   accounts and 14 for privileged ones), what makes a password weak (dictionary words, usernames,
   sequences), and expiry (current NCSC guidance advises against routine forced expiry)
4. Multi-factor authentication: which systems require it; acceptable methods (authenticator app,
   hardware key, push notification); SMS one-time codes named as the weakest method
5. Password managers
6. Shared and service accounts
7. Reset and recovery
8. Privileged account management
9. Monitoring and auditing
10. Enforcement and non-compliance
11. Related documents
12. Approval and sign-off

## Acceptable use policy

1. Purpose and scope
2. Policy statement
3. Who is bound: employees, contractors, third parties, users of their own devices
4. Acceptable use: internet and web, email and messaging, company systems and cloud platforms,
   mobile and remote devices
5. Prohibited activities, as concrete examples: on the internet, in email, on devices, and data
   misuse or exfiltration
6. Personal use: what is permitted, and its limits
7. Monitoring and privacy: what is monitored, the lawful basis under UK GDPR, and the user's
   rights
8. Email
9. Internet and web browsing
10. Mobile devices and remote access
11. Social media
12. Disciplinary procedure and enforcement
13. Related documents
14. Approval and sign-off

## Network security policy

1. Purpose and scope
2. Policy statement
3. Network architecture in outline: the segments and what each is for, in words
4. Network access control: firewall rules and their management, segmentation, network access
   control and zero-trust principles where they apply
5. Encryption: data in transit (recommended TLS 1.2 at least, 1.3 preferred); wireless
   (recommended WPA3 for new deployments, WPA2-Enterprise for existing); approved VPN protocols
6. Wireless: corporate and guest networks separated, rogue access point detection
7. Remote access: approved methods, VPN and multi-factor requirements, split tunnelling
8. Monitoring and logging: the log sources required (firewall, DNS, DHCP, authentication), the
   minimum retention, and intrusion detection or event management where they apply
9. Denial-of-service mitigation
10. Network change management: request and approval, testing, rollback, emergency changes
11. Third-party and supplier network access
12. Incident response for network compromise (by reference to the incident response plan)
13. Related documents
14. Approval and sign-off

## Data classification policy

1. Purpose and scope
2. Policy statement
3. The classification framework
4. Classification levels, three or four, each with its criteria and examples: for instance
   Public (approved for release), Internal (not for release, not sensitive), Confidential
   (sensitive business or personal information, restricted access) and Restricted (highest
   sensitivity, with regulatory, legal or reputational impact if disclosed)
5. Classification criteria and a decision path, in words, that leads a reader to the right level
6. Common data types and their level (Data type · Level · Reason)
7. Handling by level (Level · Storage · Transmission · Encryption · Access · Printing and physical)
8. Data owners' responsibilities
9. Retention and destruction by level (by reference to the retention policy)
10. Breach notification by level (by reference to the incident response plan)
11. Staff responsibilities and training
12. Compliance and audit
13. Related documents
14. Approval and sign-off

## Data retention and disposal policy

1. Purpose and scope: the systems, locations, formats and kinds of data covered
2. Policy statement
3. Legal and regulatory basis (Law or regulation · Relevance · Jurisdiction), each verified
4. Data categories and retention periods (Category · Period · Basis · Disposal method), each
   period from a verified basis or the client's decision, never from memory
5. Exceptions: litigation hold, regulatory investigation, statutory extension
6. Disposal and destruction: digital (secure overwrite, cryptographic erasure, with reference to
   NIST SP 800-88), physical (cross-cut shredding, certified destruction), and certificates of
   destruction
7. Backups and archives: their retention and disposal
8. Third parties and sub-processors: the retention duties passed to them
9. Roles and responsibilities: data owners, IT, all staff
10. Compliance, audit and the annual review
11. Related documents
12. Approval and sign-off

## Change management policy

1. Purpose and scope: the systems and infrastructure covered
2. Policy statement
3. Change classes, each with examples: standard (pre-approved, low risk, well understood), normal
   (submitted, assessed and approved by the change advisory board) and emergency (urgent, approved
   by an emergency route, reviewed afterwards without exception)
4. The change request process: what a request must record, how risk and impact are assessed, who
   approves each class, implementation (checks before, the window, checks after) and rollback
   (triggers, owner, window)
5. The change advisory board: members by role, frequency, quorum, authority
6. The emergency change procedure, step by step, and its retrospective review
7. Post-implementation review: who, when, and how outcomes and lessons are recorded
8. Change freeze periods
9. Related documents (the information security policy, the incident response plan, the network
   security policy)
10. Approval and sign-off
