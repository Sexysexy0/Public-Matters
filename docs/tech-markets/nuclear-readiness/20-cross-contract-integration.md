# Cross-Contract Integration

## Intended chain

Evidence is registered and reviewed before it is attached to a decision gate. A gate checks evidence usability and reviewer conflict status before approval. Public audit entries record externally verifiable decision references.

## Required invariants

- Rejected evidence cannot satisfy a gate.
- Frozen evidence cannot be changed silently.
- Superseded evidence cannot remain usable as current evidence.
- Active reviewer conflicts block approval.
- Revoked or expired conflicts do not block approval.
- A gate cannot pass without required evidence and approvals.
- Audit entries preserve previous-entry linkage.
- No contract grants statutory licensing authority.

## Open review items

- Verify all cross-contract addresses are immutable or governed by an explicit reviewed process.
- Verify ownership transfer assumptions.
- Verify event indexing and off-chain reconstruction.
- Verify behavior if a referenced contract becomes unavailable.
- Verify gas behavior as evidence and approval lists grow.
