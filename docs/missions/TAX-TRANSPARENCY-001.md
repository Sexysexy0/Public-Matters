# Mission: TAX-TRANSPARENCY-001

**Filed:** 2026-10-11
**Status:** Deployed and source-verified on Sepolia testnet
**Registry:** `0xdc1ec6d8C78DF97fA09AAE37Dcb07C1F76639D5C`
  https://sepolia.etherscan.io/address/0xdc1ec6d8C78DF97fA09AAE37Dcb07C1F76639D5C
**Author:** Sovereign Operator
**Contracts:** `TaxTransparencyRegistry`, `OperatorPrivilegesV2`

---

## Summary

An append-only registry of tax assessment, reduction, and payment
claims. Records claims with attribution; does not claim truth.

The contract does not stop the cash handoff that happens in a BIR
examiner's office. It makes the *pattern* of reductions queryable at
RDO, examiner, and category level — a pattern that can be compared
across offices and against taxpayer-side accounts of the same events.

---

## The Problem

A former BIR examiner describes the "lagay" system as follows:
examiners demand under-the-table payments in addition to official
taxes, split between the examiner, supervisors, and the RDO. Small
businesses are targeted because they lack the connections or the
resources to hire professional consultants. Honest examiners are
pushed out because the bureaucracy makes it difficult to finalize
documents without participating.

The corruption happens in rooms. But it leaves fingerprints:

1. **Inflated assessments** — an examiner writes PHP 5M when the real
   number is PHP 500k.
2. **Reduction rates by RDO and examiner** — 80% of assessments get
   negotiated down; the honest 20% do not.
3. **MSMEs vs large entities** — small shops are hit harder; large
   companies do not get fixers.

None of these patterns are currently queryable. TaxTransparencyRegistry
makes them so.

---

## Design

### Two submission channels

| Submitter | Access | Purpose |
|---|---|---|
| BIR_OPERATOR | onlyOperator (OperatorPrivilegesV2) | Official BIR-side records |
| TAXPAYER | Permissionless | Taxpayer-side accounts |

Both sides can file records against the same assessment. Aggregates
are split by submitter. The gap is the signal.

### Why permissionless taxpayer-side records

If we gate both sides on operators, we recreate the trust problem we
are trying to dissolve. An open channel with permanent on-chain
attribution lets anyone file their side of the story. Records are
self-attested and permanently labeled as such. The contract does not
vouch for either side; it preserves both.

### Why salted hashes

taxpayerHash = keccak256(TIN + salt) where the salt is held only
by the taxpayer and BIR. Hashing plaintext TINs is brute-forceable
from 9 digits by anyone who knows the target. Salted hashes close
that channel while remaining verifiable by the two parties who
already know the salt.

### Reduction base semantics

Reduction rates are computed against the assessed amount, not against
the sum of assessments filed by each side. Both BIR and taxpayer
reductions are measured against the same base assessment amount, so
the two rates are directly comparable. An assessment contributes to
the base once per submitter, no matter how many reductions they file
against it.

---

## What Becomes Queryable

### Per-RDO

    getRDOReductionRate(rdoHash, Submitter.BIR_OPERATOR)
    getRDOReductionRate(rdoHash, Submitter.TAXPAYER)
    getRDOStats(rdoHash, Submitter.BIR_OPERATOR)

A journalist can call getRDOReductionRate("RDO-039", BIR_OPERATOR)
and see 1000 bps (10%), then getRDOReductionRate("RDO-001", BIR_OPERATOR)
and see 500 bps (5%). The 2x gap across RDOs is queryable for the
first time.

### Per-examiner

    getExaminerReductionRate(examinerHash, Submitter.BIR_OPERATOR)
    getExaminerStats(examinerHash, Submitter.BIR_OPERATOR)

Honest examiners get a defense. An examiner with a 5% reduction rate
can point to a colleague's 78% and ask why.

### Per-category

    getCategoryReductionRate(Category.MSME, Submitter.BIR_OPERATOR)
    getCategoryReductionRate(Category.LARGE, Submitter.BIR_OPERATOR)

The MSME-vs-LARGE split is the direct measurement of the "targeting"
pattern the former examiner describes.

### Two-sided comparison

    getRDOReductionRate(RDO-039, Submitter.BIR_OPERATOR)  -> 10%
    getRDOReductionRate(RDO-039, Submitter.TAXPAYER)      -> 80%

When BIR says 10% and 500 taxpayers say 80% against the same
assessments, the gap is on-chain, permanent, and queryable.

---

## What This Does Not Do

- Does not stop the cash handoff
- Does not force BIR to file records
- Does not fix examiner salaries
- Does not achieve BIR's political independence
- Does not verify that any individual record is truthful

Those are legislative and administrative. The Cadena Bill is the venue
for the first four. This contract is the venue for making the fifth
distinguishable at scale.

---

## Roadmap

### Phase 1 — Contract Development (DONE)

- TaxTransparencyRegistry.sol
- 13 tests, all passing
- Two-sided submission model
- Salted taxpayer hash

### Phase 2 — Testnet Deployment (NEXT)

- Deploy to Sepolia
- Source-verify on Etherscan
- Publish canonical address in this doc

### Phase 3 — Public Query Interface

- Dashboard rendering RDO / examiner / category rates
- Filter by category, RDO, submitter
- Export for journalists

### Phase 4 — Real Data Inflow

- Outreach to BIR reform advocates
- Onboarding for MSME associations
- Documentation for taxpayer-side submissions

### Phase 5 — Institutional Adoption

- Integration with Cadena Bill data feeds
- Standards alignment with COA audit format
- Legal framework for BIR-side on-chain attestation

---

## Principles Aligned

| Manifesto Principle | How This Serves It |
|---|---|
| Transparency | Every assessment, reduction, and payment is on-chain |
| Inclusive Governance | Taxpayers submit their side without a gatekeeper |
| Durable Stewardship | Records persist beyond administrations |
| Measured Impact | Reduction rates by RDO, examiner, category |
| Accountability | Both sides are permanently attributed |

---

## Why This Matters

The former BIR examiner who joined the agency to study corruption
from within describes a system that traps MSMEs in cycles of
extortion. The system works because the pattern is invisible.

It is invisible because nothing records it in a form that survives.

This contract is that form.

Every assessment, every reduction, every payment — permanent and
queryable. Both sides of the story, side by side.

---

*Mission ID: TAX-TRANSPARENCY-001*
