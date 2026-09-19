# AI Water Footprint

**Date observed:** 2026-09-18
**Source:** ECO TALES infographic
**Type:** post

## What we saw

Data centers consumed ~560B liters of water in 2023 (~1.53B liters/day).
Projected ~1.2 trillion liters/year by 2030. AI workloads drive cooling
demand. Not all water use is equal (evaporative vs. reclaimed vs. air).

## Pattern

Digital growth has physical resource cost. Environmental externalities
are not captured in compute price.

## Governance principle

Resource accounting should include environmental externalities. On-chain
attestation of resource use makes impact visible.

## Alignment with existing stack

| Signal aspect | Existing repo | Notes |
|---|---|---|
| Environmental audit | ph-environmental-justice | Direct fit |
| Resource transparency | TransparencyLedger | Extendable |
| Attestation pattern | EvidenceRegistry | Pattern reuse |

## Gap

No environmental-externality schema in the transparency stack.

## Proposed artifact

- [ ] File: resource-externality-schema.json
- [ ] Test: n/a
- [ ] Contract: none (schema layer)

## Status

- [x] Observed
- [x] Analyzed

## Notes

Strong fit for ph-environmental-justice.
