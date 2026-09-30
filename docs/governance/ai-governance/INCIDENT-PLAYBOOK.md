# Incident Playbook

## Severity
- SEV-1: rogue agent, unauthorized action -> immediate
- SEV-2: anomaly, unauthorized comm -> less than 1 hour
- SEV-3: reputation drop, minor violation -> less than 24 hours
- SEV-4: suspicious pattern -> scheduled review

## SEV-1 Response
1. killAgent(agentId, "SEV-1 rogue behavior")
2. If widespread: triggerGlobalFreeze(keccak256("SEV-1"))
3. Record audit entry
4. Post: analyze trail, slash reputation, revoke training
5. Report

## SEV-2 Response
1. Check anomaly details
2. suspendAgent if confirmed
3. clearFlag after investigation

## Lift Freeze
Requires 2 operators:
- Operator 1: proposeLift()
- Operator 2: proposeLift() -> auto-lifts

## Pre-deploy Checklist
- Training recorded
- Deployment authorized
- Sandbox limits set
- Baseline set
- Resource cap set
- Reputation initialized
- Channels authorized
