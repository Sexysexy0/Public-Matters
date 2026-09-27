# Pyrowave: Latency–Bandwidth Trade-off Review

**Review date:** 2026-09-27  
**Status:** Observation and research note  
**Scope:** Experimental Steam Remote Play codec for local game streaming

## Summary

Pyrowave is an experimental Steam Remote Play video codec designed for high-bandwidth, low-latency local streaming. Its design prioritizes responsiveness over bandwidth efficiency: it uses substantially more local-network capacity than conventional internet-focused codecs in order to reduce compression and frame-dependency work.

This note records a systems-design pattern rather than a deployment recommendation.

## What changed

Valve added Pyrowave to Steam Client Beta / Steam Remote Play as an experimental codec. Public reporting describes a high-bandwidth local-streaming approach, with support and performance behavior still evolving through beta updates.

## Core design trade-off

| Resource or property | Direction under the Pyrowave approach |
|---|---|
| Local-network bandwidth | Higher consumption |
| Compression efficiency | Lower priority |
| Inter-frame dependency work | Reduced through intra-only handling |
| Encode/decode delay | Intended to be reduced |
| GPU compute demand | May increase or contend with rendering work |
| End-to-end local-streaming latency | May decrease under suitable conditions |

## Preconditions

- Stable wired local network, preferably gigabit Ethernet or better
- Compatible Steam Remote Play host and client
- Sufficient host and client GPU headroom
- Limited competing traffic on the local network
- A conventional codec fallback for unsuitable networks or devices

## Limitations and failure modes

- Wi-Fi instability, congestion, or packet loss
- Ethernet links negotiated below expected speed
- Shared switches, routers, mesh nodes, or powerline links becoming bottlenecks
- GPU contention with game rendering, compositing, or other compute workloads
- Incomplete platform, mobile, and VR compatibility
- Treating best-case benchmark results as universal outcomes

## Codec-selection lens

| Environment | Initial direction | Reason |
|---|---|---|
| Stable wired, high-bandwidth LAN | Evaluate Pyrowave | Responsiveness may justify higher network use |
| Wired but shared or constrained LAN | HEVC or AV1 | Lower bitrate may improve overall reliability |
| Typical home Wi-Fi | H.264, HEVC, or AV1 | Compression efficiency and resilience are more important |
| Remote internet streaming | HEVC or AV1 | WAN bandwidth is normally the limiting resource |
| VR streaming | Supported VR-specific path | Pyrowave support should not be assumed |

## Reusable systems lesson

Optimization should follow the actual bottleneck. When local bandwidth is abundant and latency is scarce, deliberately spending more bandwidth can be a rational way to reduce response time. This is not a universal rule; it depends on the environment, hardware, and reliability requirements.

## Follow-up opportunities

1. Compare Pyrowave with H.264, HEVC, and AV1 under a fixed local-network test protocol.
2. Record bitrate, packet loss, encode/decode latency, GPU utilization, frame stability, and visual quality.
3. Monitor Steam Beta notes for support changes, bug fixes, mobile availability, and VR status.
4. Investigate GPU compute contention under demanding games and high-refresh-rate streaming.
5. Create a reusable latency-versus-bandwidth decision matrix for real-time systems research.

## Open questions

- What is the stable-release timeline?
- How does behavior vary across NVIDIA, AMD, Intel, Apple Silicon, and Steam Deck hardware?
- Does the benefit persist at 4K and 120 Hz?
- What happens under realistic congestion on a shared home LAN?
- When will mobile Steam Link support arrive?
- Will a separate VR-compatible low-latency path be developed?

## Evidence handling

Separate official Steam/Valve statements, independent benchmarks, and unverified community reports. Time-sensitive claims should include a source and access date.

See [Pyrowave source register](pyrowave-sources-2026-09-27.md).
