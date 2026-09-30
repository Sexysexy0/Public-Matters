# Implementation Guide — Project Continuity Framework

## For Government Agencies

### Step 1: Deploy Contracts

    forge script script/DeployProjectContinuity.s.sol \
      --rpc-url $RPC_URL \
      --broadcast

### Step 2: Register Projects

    registry.registerProject(
        "Metro Manila Subway",
        "NCR",
        500_000_000_000,  // PHP 500B
        20                 // 20 milestones
    );

### Step 3: Record Disbursements

    registry.recordDisbursement(
        projectId,
        amount,
        contractor,
        purposeHash
    );

### Step 4: Complete Milestones

    registry.completeMilestone(projectId);

### Step 5: Public Dashboard

Data is public. Citizens can query:
- Total budget per project
- Disbursed amount
- Milestone progress
- Cancellation attempts

## For Citizens / Researchers

### Query Project Status

    cast call $REGISTRY "getProject(uint256)" $PROJECT_ID

### Query Budget Utilization

    cast call $REGISTRY "getBudgetUtilization(uint256)" $PROJECT_ID

### Query Cancellation Attempts

    cast call $GUARD "getAttempt(uint256)" $ATTEMPT_ID

## For Investigators

### Register as Investigator

    shield.registerInvestigator(
        yourAddress,
        publicKeyHash,
        "Philippines"
    );

### Submit Evidence

    shield.submitEvidence(
        evidenceHash,
        targetInstitution,
        "government-fraud"
    );

### Track Suppression Laws

    shield.recordSuppressionLaw(
        lawId,
        jurisdiction,
        description
    );

## Legal Boundaries

- Framework only
- No authority to override existing law
- Requires legislative adoption for mandatory use
- Voluntary participation supported
