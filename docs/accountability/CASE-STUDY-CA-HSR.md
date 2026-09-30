# Case Study: California High-Speed Rail

## Overview

The California High-Speed Rail project is one of the largest
infrastructure failures in modern American history.

## Timeline

| Year | Event |
|---|---|
| 2008 | Voters approve $10B bond |
| 2009-2015 | Planning + land acquisition begins |
| 2015 | Cost estimate: $68B |
| 2019 | Cost estimate: $77B (Governor Newsom scales back) |
| 2022 | Cost estimate: $113B |
| 2025 | Cost estimate: $236B |
| 2026 | No operating trains. Investigation by Nick Shirley |

## Key Metrics

- Spent: $15B+
- Output: No operating trains
- Cost overrun: ~15x original estimate
- Administration changes: 4 (Schwarzenegger → Brown → Newsom → next)
- Federal funding: partially withdrawn by Trump admin (2019)

## The Pattern

    Public funds → Political promise → Administration change
        |
        v
    Project stalls → No output → Citizen asks
        |
        v
    Investigator exposes → Legal hurdle created (AB2624)
        |
        v
    Silence → Waste continues

## The Investigation

Independent journalist Nick Shirley:
- Documented stalled construction
- Exposed cost overruns
- Challenged AB2624 in court
- Triggered public debate

## Legal Hurdle — AB2624

California Assembly Bill 2624:
- Limits recording at government-funded immigration facilities
- Nick Shirley dubs it "Stop Nick Shirley Act"
- Currently challenged in court

## On-Chain Response — Our Framework

| Contract | Purpose |
|---|---|
| ProjectContinuityRegistry | Track projects, disbursements, milestones |
| ContinuityGuard | 2/3 supermajority + 30-day public notice |
| InvestigatorShield | Protect whistleblowers, track suppression laws |

## Universal Application

This pattern is NOT unique to California. It applies to:
- Philippine DPWH ghost projects
- Philippine barangay project cancellations
- Any jurisdiction with institutional discontinuity

## Reference

- Source video: Nick Shirley interview
- Related case: ph-reform CASE-006
- Contracts: Public-Matters src/ProjectContinuityRegistry.sol
