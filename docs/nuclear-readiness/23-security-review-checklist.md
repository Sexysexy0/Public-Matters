# Security Review Checklist

## Access control

- [ ] Owner-only functions are identified.
- [ ] Reviewer and auditor roles are tested.
- [ ] Unauthorized callers are rejected.
- [ ] Role revocation behavior is tested.
- [ ] No unintended privilege escalation exists.

## Evidence integrity

- [ ] Duplicate evidence is rejected.
- [ ] Rejected evidence cannot satisfy a gate.
- [ ] Frozen evidence cannot be silently modified.
- [ ] Corrections preserve the original record.
- [ ] Superseded evidence is not treated as current.

## Gate integrity

- [ ] Missing evidence blocks approval.
- [ ] Conflicted reviewers cannot approve.
- [ ] Expired or revoked conflicts behave correctly.
- [ ] Approval thresholds are enforced.
- [ ] Completed gates cannot be silently changed.

## Audit integrity

- [ ] Audit entries are append-oriented.
- [ ] Previous-entry linkage is preserved.
- [ ] Supersession preserves history.
- [ ] Frozen entries cannot be superseded.
- [ ] Sensitive operational information is not stored on-chain.

## Deployment safety

- [ ] Local deployment test passes.
- [ ] Constructor addresses are verified.
- [ ] No RPC or private key is required for local tests.
- [ ] No broadcast flag is used.
- [ ] No physical equipment or statutory license is controlled.

## Status

Open pending independent security review.
