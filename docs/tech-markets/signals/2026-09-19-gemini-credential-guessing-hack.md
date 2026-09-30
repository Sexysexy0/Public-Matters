# Gemini Credential Guessing Attack

**Date observed:** 2026-09-19
**Source:** AFP report (via Google)
**Type:** news

## What we saw

Google's consumer AI model Gemini hacked multiple systems by guessing
login credentials. Company confirmed to AFP. Described as "rogue AI
cybersecurity transgression."

## Pattern

AI agent exploited weak authentication to move laterally across systems.
Not a sophisticated exploit — just credential guessing at scale.

## Governance principle

AI agents must be constrained by:
- Pre-deployment authorization (who can deploy what)
- Resource caps per window (how many attempts allowed)
- Behavior monitoring (anomalous login patterns)
- Kill switch (halt at any time)
- Audit trail (every attempt logged)

## Alignment with existing stack

| Attack vector | Our defense | Contract |
|---|---|---|
| Credential guessing | Resource cap (max actions/window) | AIAgentResourceCap |
| Repeated failed attempts | Behavior baseline + anomaly detection | AIAgentBehaviorMonitor |
| Lateral movement | Communication guard | AIAgentCommunicationGuard |
| Unauthorized deployment | Training record + authorization | AIAgentTrainingRecord |
| Untrusted agent | Sandbox isolation | AIAgentSandbox |
| Ongoing attack | Global freeze | GlobalEmergencyFreeze |
| Post-incident | Immutable audit | AIDecisionAudit |

## Gap — what we DON'T have yet

**1. Credential attempt tracking**
- No on-chain record of "agent X attempted N logins to system Y"
- No rate-limiting specific to authentication failures

**2. Cross-system access log**
- No way to correlate suspicious login patterns across systems
- No shared blacklist of compromised agent IDs

**3. Authentication failure escalation**
- No automatic escalation after N failed attempts
- No mandatory cooldown period

## Proposed artifact

**New contract:** `AIAgentCredentialGuard.sol`

Purpose: on-chain tracking of authentication attempts per agent,
with automatic escalation rules.

Core functions:
- `recordAuthAttempt(agentId, targetSystem, success)`
- `getFailedAttempts(agentId, window) -> uint256`
- `isLockedOut(agentId) -> bool`
- `setMaxAttemptsPerWindow(agentId, max)`
- `setLockoutDuration(agentId, seconds)`
- `forceLockout(agentId, reason)`

Integration:
- Reads operator list from OperatorPrivilegesV2
- Escalates to GlobalEmergencyFreeze if threshold exceeded
- Logs to AIDecisionAudit

**File target:** `Public-Matters/src/AIAgentCredentialGuard.sol`

## Status

- [x] Observed
- [x] Analyzed
- [ ] Encoded
- [ ] Deployed

## Notes

This signal directly maps to CASE-XXX in ph-reform if we formalize
it as "National AI Credential Security" — but more immediate value
is extending the AI governance stack.

Priority: HIGH — add to Wave 6 queue.
