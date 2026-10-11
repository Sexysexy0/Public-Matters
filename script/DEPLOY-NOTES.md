# Deployment notes

## forge 1.8.3 constructor-arg bug

`forge create` and `forge script` in forge 1.8.3 miscount constructor
arguments when passed via `--constructor-args`. The reported count is
wrong (reports N+2 for any N-arg constructor). Broadcast then reverts
after consuming the full gas limit, which looks like OOG but is
actually argument decoding.

Workaround: use `--constructor-args-path` with a JSON array.

    echo '["0xabc...", "0xdef..."]' > /tmp/args.json
    forge create src/My.sol:My \
      --rpc-url $RPC_URL \
      --private-key $PRIVATE_KEY \
      --constructor-args-path /tmp/args.json \
      --broadcast

Do not use `--constructor-args` on this forge version.

## Sepolia deployment (2026-10-11)

Registry:   0x948e9059c465980b5bE186212d09720F5D1D03f4
Integrator: 0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11

Constructor args:
- Registry:   OperatorPrivilegesV2 = 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
- Integrator: OperatorPrivilegesV2,
              AIDecisionAudit    = 0x9E93a6A3421AD0F8F029406aC3Ce3E21e8544074,
              Registry           = 0x948e9059c465980b5bE186212d09720F5D1D03f4

Deployer: 0x6bDf6D887038AB97957c2f57d05eDd0eb338589A
Owner of OperatorPrivilegesV2: 0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6

## Post-deploy step (pending)

The integrator must be registered as an operator before it can write
audit records. The call is:

    addOperator(0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11)

on OperatorPrivilegesV2 (0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98).

Requires the owner (0xE696...c7F6). Interface unknown as of this
writing; registration not performed.

Until executed, the registry functions standalone. Audit records do
not populate. This is a post-deploy step, not a blocker.

Verify registration after executing:

    cast call 0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98 \
      "isOperator(address)(bool)" \
      0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11 \
      --rpc-url $RPC_URL

## Multisig registration status

AIGovernanceMultisig (0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6)
owns OperatorPrivilegesV2 (0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98).
Threshold: 2-of-3.

Signers:
  0xF66b23603160dd880Ad1f77E459E014aFfcc6511
  0xF580403f2Fb2075984a36FF41504b6ADD151C721
  0x4b902973767F2315758CC051A78089f90981a820

Deployer (0x6bDf6D887038AB97957c2f57d05eDd0eb338589A) is NOT a signer.

## Register BudgetAuditIntegrator as operator (pending)

Through the multisig:

    MSIG=0xE696BaD9ee41affE5865344B1197C5A18dd7c7F6
    OPV2=0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98
    INTEGRATOR=0x7C332bbEfe2F96eFf7850482A8D25EFd2f0f7B11

    DATA=$(cast calldata "addOperator(address)" $INTEGRATOR)

    # From signer 1 wallet:
    cast send $MSIG "createProposal(address,uint256,bytes,string)" \
      $OPV2 0 $DATA "Register BudgetAuditIntegrator as operator"

    # From signer 1 and signer 2 wallets (each approves; auto-executes at 2/3):
    cast send $MSIG "approve(uint256)" <PROP_ID>

Verify:
    cast call $OPV2 "isOperator(address)(bool)" $INTEGRATOR

## First live proposal (Sepolia)

Proposal ID: 0xb0d8e5ac9542abc54f977947a0848ec1aae5926faf6b75cccdfd0c95cb56e27f
Registry:    0x948e9059c465980b5bE186212d09720F5D1D03f4
Title:       Universal Healthcare 2027
Category:    health
Amount:      1 ETH (test)
Tier:        OPERATOR
Tx:          0xf2f0264cad9eab5f5cb9c84ff51469b08536d34ea9b17299bfd4ce01763e22df

Query at:
  https://sepolia.etherscan.io/address/0x948e9059c465980b5bE186212d09720F5D1D03f4
