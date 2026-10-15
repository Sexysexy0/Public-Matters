# Mission: IMMIGRATION-TRANSPARENCY-001

**Filed:** 2026-10-15
**Status:** Contract complete (14 tests). Sepolia deployment next.
**Author:** Sovereign Operator
**Contract:** ImmigrationProcessingRegistry

---

## Summary

Append-only record of immigration application processing. Neutral:
does not encode policy. Records filing, decisions, and appeals so
citizens can query backlog, timelines, and decision rates per office
and category.

The contract does not know which countries, categories, or policies
are involved. Office, category, applicant, and policy are hashes.

---

## The Problem

Immigration processing is a black box. Applicants wait months without
knowing backlog. Journalists cannot verify official processing time
claims. Appeals disappear into unmeasured channels.

Citizens cannot answer: How long is the average wait? What is the
approval rate per office? Do certain categories get decided faster?

---

## Design

### Outcome lifecycle

FILED -> APPROVED | DENIED | WITHDRAWN
DENIED -> APPEALED -> GRANTED_ON_APPEAL | DENIED (final)

State machine refuses impossible transitions. A filed application must
reach a decision before appeal. An appeal must attach to a denied
application.

### Privacy

applicantHash is a salted hash. No PII on-chain. Applicants retain
the ability to prove their own case to the two parties who hold the
salt (themselves and the filing office).

### Operator-gated writes

Filing and decisions require operator status. Reading is permissionless.

---

## What Becomes Queryable

- getOfficeApprovalRate(officeHash) - approval share in bps
- getOfficeStats(officeHash) - filed, approved, denied, appealed
- getCategoryCount(officeHash, categoryHash) - filed per category
- getApplication(id) - full record
- getTotals() - global filed/approved/denied/appealed/granted

A journalist can query backlog and approval rates without FOI requests.

---

## What This Does Not Do

- Does not set immigration policy
- Does not verify that any record is truthful
- Does not process applications on-chain
- Does not store names or PII
- Does not enforce quotas or bans

---

## Principles Aligned

| Principle | How This Serves It |
|---|---|
| Transparency | Every application record is on-chain |
| Neutrality | No policy encoded |
| Privacy | Salted hashes; no PII |
| Measured Impact | Backlog, timeline, rate by office |

---

## Roadmap

### Phase 1 - Contract Development (DONE)
### Phase 2 - Testnet Deployment (NEXT)
### Phase 3 - Public Query Interface
### Phase 4 - Real Data Inflow
### Phase 5 - Institutional Adoption

---

*Mission ID: IMMIGRATION-TRANSPARENCY-001*
