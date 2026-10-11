# Mission: BUDGET-TRANSPARENCY-001

**Filed:** 2026-10-11
**Status:** Deployed and source-verified on Sepolia testnet
**Registry:** `0x8E4f12c712E9d995a6C226a2d7a79c8403E5De53`
  https://sepolia.etherscan.io/address/0x8E4f12c712E9d995a6C226a2d7a79c8403E5De53
**Integrator:** `0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11`
  https://sepolia.etherscan.io/address/0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11
**Author:** Sovereign Operator
**Contracts:** `BudgetDeliberationRegistry`, `BudgetAuditIntegrator`,
`TieredApproval`, `AIDecisionAudit`

---

## Summary

Every stage of a budget proposal is a state on-chain.
Every state transition is a transaction.
Every transaction is publicly queryable by anyone with an internet connection.

This document describes the contracts, the query interfaces, and the
authority-tier model that make Philippine budget decisions auditable
end-to-end.

---

## The Citizen Demand

A citizen asked: *"Bakit ganoon ang budget ng health? Saan napunta?"*

Before this system, the answer required navigating multiple agencies,
FOI requests, and often went unanswered. The citizen was expected to
trust.

The contracts in this mission make that trust unnecessary. Every peso
proposed, deliberated, approved, disbursed, and audited is queryable
by name, category, amount, and stage — in a permanent record that no
succeeding administration can rewrite.

---

## What the Contracts Provide

| Citizen Question | Contract Answer |
|---|---|
| Who proposed this? | `proposal.proposer` |
| How much and for what? | `proposal.amount`, `proposal.category`, `proposal.title` |
| How was it deliberated? | `proposal.votesFor`, `proposal.votesAgainst`, `proposal.deliberationHash` |
| Was it approved? | `proposal.stage` (`APPROVED` / `REJECTED`) |
| What authority did approval require? | `proposal.requiredTier` |
| Did one person alone approve it? | `getAction(id).soleActor` |
| How much has been released? | `proposal.disbursedAmount` |
| Where did each tranche go? | `getDisbursements(id)` — `purpose` + `evidenceHash` per tranche |
| Was it audited? | `proposal.auditHash`, `proposal.auditVerdict` |
| How much in the health sector total? | `getCategorySummary("health")` |

---

## The Authority-Tier Model

Every proposal declares the authority it requires **at the moment it is
filed**, not at the moment it is approved. The approver cannot lower the
bar.

| Tier | Board requirement | Stockholder requirement |
|---|---|---|
| `OPERATOR` | none | none |
| `MAJORITY` | strictly more than 50% | strictly more than 50% |
| `SUPERMAJORITY` | at least 2/3 | at least 2/3 |
| `UNANIMOUS` | 100% | 100% |

Both thresholds must be satisfied. `SUPERMAJORITY` is the standard
requirement under the Philippine Revised Corporation Code (RA 11232)
for constitutional corporate acts — charter amendment, capital increase,
merger, dissolution.

### Sole-actor flag

When a single address alone carries a supermajority-tier decision, the
contract records it as `soleActor` on the resolved action. The decision
is not blocked — it is recorded. This is deliberate:

- **Honest record:** the ledger says what actually happened, not what a
  hypothetical coalition might have looked like.
- **Persistent:** as more operators and stockholders are registered, the
  flag stops firing. No contract change is required for the coalition
  to grow.
- **Queryable:** any citizen can check whether a supermajority decision
  was carried by one person or by a coalition.

---

## Integration with AIDecisionAudit

Every budget stage transition is also written to `AIDecisionAudit` as a
decision record:

- `inputHash` — hash of proposal metadata
- `reasoningHash` — hash of the deliberation record
- `outputHash` — hash of the resulting state (approved / rejected /
  disbursed) **and the governing tier**
- `confidence` — `votesFor / totalVotes` ratio, scaled 0–100

Every budget decision therefore has:

1. A **public budget record** — `BudgetDeliberationRegistry`
2. A **decision audit trail** — `AIDecisionAudit`
3. A **supersede path** — if a decision is corrected, the original
   stays on-chain

The supersede pattern is critical: **walang pagtatago ng pagkakamali**.
If a budget is revised, the original proposal stays visible forever.

---

## Public Query Interfaces

Any citizen, journalist, auditor, or researcher can query:

### Direct on-chain (any block explorer)

- `getProposal(id)` — full proposal state
- `getDisbursements(id)` — all disbursement records
- `getAllProposalIds()` — full list of proposals
- `getCategorySummary(category)` — aggregate per sector
- `getProposalCount()` — total number of proposals
- `isTierSatisfied(id)` — whether the required tier has been met
- `getAction(id)` — authority tier details for a resolved decision
- `requiredBoard(tier)`, `requiredStockholder(tier)` — threshold math

### Via AIDecisionAudit

- `getDecisionsByAgent(budgetRegistryAddress)` — all budget decisions
  in the audit trail
- `verifyDecision(id, ...)` — cryptographic proof that a decision
  was recorded

### Via Indexer / Dashboard (future work)

- Public dashboard rendering all data in human-readable form
- Filter by category, proposer, stage, amount range, tier
- Alert system for new proposals or disbursements

---

## A Worked Example

A citizen asks: *"Bakit ganoon ang budget ng health? Saan napunta?"*

They can:

1. Query `getCategorySummary("health")` → total proposed, approved,
   disbursed for the health sector
2. Query `getAllProposalIds()` → list of all health proposals
3. For each ID, query `getProposal(id)` → see who proposed, how much,
   how the votes went, what tier was required
4. Query `getDisbursements(id)` → see each tranche released, when,
   by whom, with the evidence hash
5. Query `getProposal(id).auditVerdict` → see the independent audit
   result
6. Query `getAction(id).soleActor` → see whether the decision was
   carried by one person

All in one place. All verifiable. All permanent.

---

## Principles Aligned

| Manifesto Principle | How This Serves It |
|---|---|
| **Transparency** | Every state transition is on-chain, immutable |
| **Inclusive Governance** | Anyone can query, no gatekeeper |
| **Durable Stewardship** | Records persist beyond administrations |
| **Measured Impact** | `getCategorySummary` tracks actual vs proposed |
| **Accountability** | `soleActor` flag makes concentrated authority visible |

---

## Roadmap

### Phase 1 — Contract Development (DONE)

- `BudgetDeliberationRegistry.sol` with full lifecycle
- `TieredApproval` abstract base with fraction-based thresholds
- `BudgetAuditIntegrator.sol` writes every stage to `AIDecisionAudit`
- `FilipinnovationLedger.sol` for grant/commercialization/impact events
- Test coverage: 425 tests passing

### Phase 2 — Testnet Deployment (IN PROGRESS)

- Deploy registry, integrator, ledger to Sepolia
- Verify source on Etherscan
- Register integrator as operator post-deploy
- Publish contract addresses + verification URLs

### Phase 3 — Public Dashboard

- Web interface querying on-chain state
- Filter / search / export
- Mobile-friendly, English + Filipino

### Phase 4 — Data Feeds

- Integration with existing government budget databases
- Automatic proposal ingestion (with attestation)
- Historical budget data migration for archival transparency

### Phase 5 — Institutional Adoption

- Partnership with COA, DBM, or congressional oversight bodies
- Standard data format for budget deliberation records
- Legal framework for on-chain budget attestation

---

## Why This Matters

The citizen who wrote *"ABOLISH BIR, CUSTOMS AND CONGRESS"* was not
asking for chaos. They were asking for a system that **cannot hide**.

This contract does not abolish institutions. It makes them
**transparent by design**.

Every budget proposal, every vote, every disbursement, every audit —
visible forever.

That is the accountability the citizen is demanding. That is what this
mission delivers.

---

## Citizen FAQ (Filipino)

| Tanong | Sagot |
|---|---|
| Sino ang nag-propose? | `proposal.proposer` |
| Magkano at para saan? | `proposal.amount`, `proposal.category` |
| Paano ang deliberation? | `proposal.votesFor`, `proposal.votesAgainst` |
| Na-approve ba? | `proposal.stage` |
| Anong authority ang kailangan? | `proposal.requiredTier` |
| Isang tao lang ba ang nag-decide? | `getAction(id).soleActor` |
| Magkano na ang narelease? | `proposal.disbursedAmount` |
| Saan napunta ang bawat tranche? | `getDisbursements(id)` |
| May audit ba? | `proposal.auditVerdict` |
| Magkano sa health sector lahat? | `getCategorySummary("health")` |

---

*Mission ID: BUDGET-TRANSPARENCY-001*
