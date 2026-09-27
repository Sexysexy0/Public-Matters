# Fictional Game Wayfinding Observation Example

## Status

This is a fictional example for training and documentation. It does not describe a real game, player, studio, test session, or outcome.

## Session record

- Study identifier: WAYFINDING-DEMO-001
- Level or mission: Flooded Transit Station
- Test date: Fictional date
- Participant reference: Participant A
- Playtest format: Recorded usability session
- Build version: Fictional prototype 0.3
- Guidance configuration: Contextual
- Accessibility settings enabled: Default subtitles and standard HUD
- Recording consent and retention limits: Fictional example only; no real recording exists

## Intended experience

- Immediate player goal: Reach the maintenance room to restore power.
- Intended route: Leave the ticket hall, identify the elevated service corridor, cross a damaged platform, and enter the maintenance door.
- Optional detour: Search a closed kiosk for a supply item.
- Deliberate challenge: The player should decide whether to cross the unstable platform or search for a lower route.
- Expected environmental cues: A flickering maintenance light above the corridor, a visible cable leading toward the maintenance door, and a distant generator sound.
- Guidance intentionally available: Objective text and optional contextual hint after demonstrated non-progress.
- Guidance intentionally unavailable: Persistent route line, minimap route, and immediate companion solution.
- Completion condition: Enter the maintenance room.

## Observation timeline

| Time | Player action or location | Observed behavior | Guidance used | Outcome |
|---|---|---|---|---|
| 00:00 | Ticket hall | Reads objective text and looks toward the main platform | None | Begins exploration |
| 00:42 | Kiosk entrance | Searches optional kiosk | None | Finds supply item |
| 01:36 | Ticket hall | Returns and faces several dark exits | None | Hesitates |
| 02:10 | Lower tunnel | Chooses a plausible but blocked route | None | Returns to ticket hall |
| 03:05 | Ticket hall | Repeats inspection of blocked route | None | Sustained non-progress |
| 03:25 | Ticket hall | Requests help through hint control | Contextual hint | Looks toward service corridor |
| 04:08 | Damaged platform | Crosses platform and enters maintenance door | Contextual hint | Completes route |

## Confusion-point record

### Confusion point

- Time or location: 01:36 to 03:25, ticket hall and lower tunnel.
- Immediate player goal: Find a route to the maintenance room.
- Player behavior: The player understood the goal but interpreted the lower tunnel as the likely route because it was brighter, wider, and directly ahead.
- Environmental cues present: Flickering maintenance light, cable direction, and generator sound near the elevated service corridor.
- Guidance present: Objective text; no route line or companion callout.
- Player action: Explored the kiosk, entered the lower tunnel, returned, and repeated inspection of the blocked tunnel.
- Duration before progress or support: Approximately 109 seconds after returning from the kiosk.
- Did the player request help: Yes.
- Did the system provide help: Yes; it highlighted the maintenance-light direction without displaying a full route.
- Did the player recover independently: No.
- Observed impact: Moderate.
- Player-reported confidence: "I knew I had to get to maintenance, but the blocked tunnel seemed like the main path."
- Player-reported immersion: The player reported that the hint felt helpful and did not reveal the full route.

### Cause classification

- Conflicting environmental cues.
- Unreadable environmental cue.
- Insufficient evidence that a persistent waypoint is necessary.

## Interpretation

The player had a clear objective and explored a reasonable alternate route. The problem was not a lack of motivation, refusal to explore, or inability to use controls.

The lower tunnel communicated stronger path priority than the intended elevated service corridor. Its width, brightness, forward alignment, and open entrance outweighed the intended cues of flickering light, cable direction, and distant audio.

The player-requested contextual hint restored progress without revealing the whole traversal sequence. However, the need for a hint indicates that the environmental hierarchy should be improved before a persistent route marker is added.

## Proposed intervention

- Make the elevated service corridor visible from the ticket-hall entrance.
- Increase contrast around the maintenance light while preserving the damaged-station atmosphere.
- Position the cable so that its direction is readable from the first decision point.
- Reduce the apparent path priority of the blocked lower tunnel through debris, darkness, framing, or earlier visible obstruction.
- Keep the contextual hint available after player request or sustained non-progress.
- Do not add a permanent route line in the next build.

## Retest plan

- Test the revised environment with participants unfamiliar with the level.
- Begin with contextual guidance available but unused by default.
- Measure first-attempt route selection, time to identify the service corridor, lower-tunnel entry rate, hint-request rate, hint-trigger rate, completion rate, confidence, and immersion.
- Compare results against this fictional baseline.
- Add explicit navigation UI only if revised environmental cues and optional contextual guidance remain insufficient for fair access.

## Learning

A player taking a plausible but unintended route is not automatically evidence that the player needs more UI.

First determine whether the level communicates route hierarchy, goal relevance, and affordances clearly. Then use the least intrusive intervention that improves access while preserving observation, choice, and environmental storytelling.
