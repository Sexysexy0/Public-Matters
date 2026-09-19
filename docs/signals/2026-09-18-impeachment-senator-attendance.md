# Impeachment — Senator-Judge Attendance

**Date observed:** 2026-09-18
**Source:** Retired CJ Artemio Panganiban on senator-judges
**Type:** news

## What we saw

Panganiban: absent senator-judges, regardless of reason, should not vote
if they cannot know the truth. 4 senators absent (Estrada, Marcoleta,
Dela Rosa, Legarda).

## Pattern

Attendance = participation in judgment. Absence without accountability
undermines legitimacy.

## Governance principle

Participation must be verifiable. Non-participation must be recorded and
affect outcome weighting.

## Alignment with existing stack

| Signal aspect | Existing contract/design | Notes |
|---|---|---|
| Attendance record | Not yet implemented | Potential new design |
| Voting eligibility | OperatorPrivileges pattern | Could adapt |
| Recusal tracking | None | Gap |

## Gap

No on-chain or repo-tracked attendance model for legislative/legal
proceedings that weights presence vs. absence.

## Proposed artifact

- [ ] File: attendance-quorum-schema.json
- [ ] Test: quorum-validation-cases.md
- [ ] Contract: LegislativeAttendanceRegistry (future)

## Status

- [x] Observed
- [x] Analyzed
- [ ] Encoded

## Notes

Direct policy relevance to ph-accountability-tracker.
