# Local Deployment Runbook

## Preconditions

- Working tree is clean or the intended batch is explicitly staged.
- Focused tests pass.
- Full Forge suite passes.
- No public-network RPC or private key is configured.
- Contract addresses are recorded only for the local run.

## Verification

- Confirm constructor addresses.
- Confirm authorized roles.
- Exercise evidence acceptance.
- Exercise conflict blocking and release.
- Exercise gate approval.
- Exercise audit logging, supersession, and freeze.
- Capture logs and commit hash.

## Prohibition

Do not broadcast transactions to testnet or mainnet from this runbook.
