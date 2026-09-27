# Pyrowave Benchmark Protocol

## Purpose

This protocol defines a repeatable method for recording local game-streaming benchmark observations. It is designed to make results more comparable across devices, codecs, and networks.

A record created under this protocol does not automatically prove a universal performance claim. Results apply only to the documented setup and method.

## Scope

- Local game streaming between a documented host and client
- Pyrowave where available, plus comparison codecs where appropriate
- Latency, packet loss, jitter, GPU utilization, visual quality, and stability observations
- Evidence-quality and reproducibility requirements

## Out of scope

- Internet/WAN streaming performance
- Steam product certification
- Security testing
- Investment, purchasing, or network-administration advice
- VR performance claims unless a supported VR path is explicitly tested

## Evidence-status labels

| Label | Meaning |
|---|---|
| `observed` | Directly measured in a documented setup |
| `reported` | Quoted from a named external source |
| `reproduced` | Independently repeated under documented conditions |
| `fictional_example` | Demonstration data only; not a real measurement |
| `unsupported` | Insufficient evidence; do not use for conclusions |

## Required environment record

Record the following for every run:

- Host operating system, CPU, GPU, and available memory
- Client operating system, CPU, GPU, and available memory
- Network connection type and path summary
- Reported link speed in Mbps
- Codec name, release channel, and build/version where available
- Resolution, refresh rate, bitrate, HDR setting, and test duration
- Any competing traffic, special routing, adapters, switches, mesh nodes, or powerline equipment

## Controlled variables

Keep these stable within a comparison set:

1. Use the same host, client, game or workload, display mode, and test scene.
2. Use the same resolution and refresh-rate target where supported.
3. Use the same physical network path where possible.
4. Avoid downloads, backups, uploads, and unrelated heavy LAN traffic.
5. Record all configuration changes rather than assuming settings stayed constant.
6. Test one codec/configuration at a time.

## Suggested test matrix

| Run | Codec | Network condition | Goal |
|---|---|---|---|
| A | H.264 | Baseline local network | Establish baseline |
| B | HEVC | Same controlled network | Compare efficient compression |
| C | AV1 | Same controlled network | Compare modern compression |
| D | Pyrowave | Stable wired high-bandwidth LAN | Evaluate latency-first approach |

Do not treat missing codec support as a failure. Record it as a compatibility limitation.

## Required measurements

| Measurement | Unit | Notes |
|---|---|---|
| Average latency | milliseconds | Record the method used |
| p95 latency | milliseconds | Capture latency consistency where available |
| Packet loss | percent | Record the measurement source |
| Jitter | milliseconds | Record the measurement source |
| Host GPU utilization | percent | Record tool and sampling method |
| Client GPU utilization | percent | Record tool and sampling method |
| Visual quality | narrative | Note artifacts, text clarity, banding, and HDR behavior |
| Stability | narrative | Note disconnects, stutter, sustained performance, or crashes |

Use `null` in structured records when a measurement is unavailable. Do not invent a value.

## Test duration

Use a duration long enough to expose instability. A short smoke test may establish compatibility but should not support strong performance claims. Record the duration exactly.

## Reporting rules

- Distinguish observed measurements from reported claims.
- Do not generalize one setup to all hardware or networks.
- Include an evidence reference for every record.
- Preserve failed, incomplete, and unsupported results rather than deleting them.
- Record limitations, fallback codecs, and conditions that prevented testing.
- Use the JSON Schema and CSV template in this repository for structured records.

## Privacy and safety boundaries

- Do not publish private IP addresses, household network names, account identifiers, device serial numbers, or credentials.
- Do not modify network, Steam, operating-system, router, or device settings without the operator's authorization.
- Do not present beta behavior as stable-product behavior.
