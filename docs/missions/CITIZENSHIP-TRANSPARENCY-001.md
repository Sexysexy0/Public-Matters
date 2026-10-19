# Mission: CITIZENSHIP-TRANSPARENCY-001

**Filed:** 2026-10-15
**Status:** Deployed and source-verified on Sepolia testnet
**Registry:** `0x8c61C1Ae301c5Ee664EF15bEF959C7a459e02Df2`
  https://sepolia.etherscan.io/address/0x8c61C1Ae301c5Ee664EF15bEF959C7a459e02Df2
**Author:** Sovereign Operator
**Contract:** CitizenshipReviewRegistry

---

## Summary

Append-only record of citizenship review proceedings, with due process
enforced in code. The state machine will not allow a review to resolve
without notice, an appeal window, and an independent reviewer distinct
from the filer.

Neutral: grounds, subject identity, and outcome are hashed off-chain.
The contract enforces procedure, not substantive policy.

---

## The Problem

Citizenship review, when it exists, is opaque. A state can revoke or
deny citizenship without any citizen being able to inspect the process.
Even a legitimate review process lacks a public record.

---

## Design

### Due process enforced in code

State machine:

    NONE -> FILED
    FILED -> NOTICE_SERVED (opens appeal window)
    FILED -> CANCELLED (only before notice)
    APPEAL_WINDOW_OPEN -> APPEAL_FILED
    APPEAL_WINDOW_OPEN | APPEAL_FILED -> UNDER_REVIEW
    UNDER_REVIEW -> RESOLVED

Refuses to skip steps:
- Notice cannot be skipped.
- Reviewer must be an operator AND must not be the filer.
- Only the assigned reviewer may resolve.
- Cancel is only permitted before notice.

### Appeal window

Settable in [1 day, 365 days], default 30 days.

### Off-chain semantics

Grounds and subject identity are hashes. No name, no PII.

### Operator-gated filing, permissionless appeal

Filing, notice, reviewer assignment, and cancel require operator status.
Filing an appeal is permissionless - the appeal channel must be
reachable.

---

## What Becomes Queryable

- getReview(id) - full review record
- getReviewCount() - total reviews
- getTotals() - filed, resolved, appealed, cancelled

A citizen can inspect whether a review against them exists, whether
notice was served, whether the appeal window is open, and who the
independent reviewer is.

---

## What This Does Not Do

- Does not define citizenship criteria
- Does not verify grounds or outcomes
- Does not remove citizenship on-chain
- Does not store identities

The contract enforces procedure. Substantive justification is a
separate question for courts and review bodies.

---

## Principles Aligned

| Principle | How This Serves It |
|---|---|
| Transparency | Every review record is on-chain |
| Due Process | Notice, appeal, independence enforced in code |
| Neutrality | No policy encoded |
| Privacy | Hashed identities |

---

## Roadmap

### Phase 1 - Contract Development (DONE)
### Phase 2 - Testnet Deployment (NEXT)
### Phase 3 - Public Query Interface
### Phase 4 - Real Data Inflow
### Phase 5 - Institutional Adoption

---

*Mission ID: CITIZENSHIP-TRANSPARENCY-001*
