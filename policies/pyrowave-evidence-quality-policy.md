# Pyrowave Evidence Quality Policy

## Purpose

This policy defines how Pyrowave-related benchmark statements and records should be labeled, reviewed, and used.

## Core rule

A structured record is not proof by itself. Every performance claim must retain its evidence status, documented setup, method, limitations, and source reference.

## Evidence labels

| Label | Permitted use | Not permitted |
|---|---|---|
| `observed` | Describe a direct measurement in its documented setup | Generalize to all hardware, networks, or users |
| `reported` | Attribute a claim to a named external source | Present the report as independently reproduced |
| `reproduced` | Describe an independently repeated result with method details | Claim universal reproducibility |
| `fictional_example` | Demonstrate schema, tooling, documentation, or UI behavior | Use as a performance result |
| `unsupported` | Preserve a claim that lacks enough evidence for conclusion | Use for comparative or promotional claims |

## Minimum record quality

A benchmark record should include:

- Evidence status
- Test date
- Codec and release channel
- Host and client hardware/software summary
- Network type, path summary, and link speed
- Stream configuration and test duration
- Measurement method or explicit statement that it was not measured
- Evidence reference
- Limitations and relevant notes

## Claim language

Use qualified language:

- “Observed in the documented setup”
- “Reported by the cited source”
- “Not independently reproduced”
- “Illustrative example only”
- “Insufficient evidence for a conclusion”

Avoid unqualified language:

- “Pyrowave always has lower latency”
- “Gigabit Ethernet guarantees performance”
- “This result applies to all devices”
- “Beta behavior is production-ready”

## Review checklist

Before publishing or relying on a record:

1. Is the evidence label accurate?
2. Are the host, client, and network context documented?
3. Is the test method named?
4. Are unavailable measurements recorded as `null` rather than invented?
5. Is the evidence reference specific enough to locate?
6. Are claims limited to what the evidence supports?
7. Are privacy-sensitive details excluded?

## Handling incomplete records

Incomplete records may be retained for transparency but must be labeled `unsupported` or `fictional_example` as appropriate. They must not be aggregated into performance conclusions without a documented method for handling missing data.
