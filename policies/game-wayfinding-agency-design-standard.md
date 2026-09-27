# Game Wayfinding and Agency Design Standard

## Purpose

This standard helps game teams design navigation and guidance systems that support player understanding without unnecessarily replacing observation, exploration, choice, or environmental storytelling.

It does not prohibit waypoints, minimaps, companion hints, accessibility tools, objective markers, or other explicit guidance. It requires teams to use them deliberately, offer appropriate player control, and evaluate whether the environment itself communicates the intended path.

## Core principle

A level should communicate plausible progress through the game world before relying on persistent direction UI.

When players do not progress, teams should diagnose the source of the problem and select the least intrusive intervention that preserves fair access, player agency, and the intended experience.

## Guidance hierarchy

Evaluate guidance in this order:

1. Player goal clarity.
2. Environmental cues.
3. Contextual feedback.
4. Optional player-requested hints.
5. Adaptive hints after evidence of sustained non-progress.
6. Persistent or explicit navigation UI.

A higher guidance layer may be used immediately when it is necessary for accessibility, safety, player preference, task clarity, or the intended genre experience.

## Environmental guidance

Use one or more coherent environmental cues before adding permanent route UI:

- Landmark hierarchy, framing, and sightlines.
- Lighting, contrast, color, and silhouette.
- Geometry, path width, elevation, barriers, and openings.
- Motion, sound, animation, and visible activity.
- Set dressing, signage, narrative context, and object placement.
- Camera composition, interaction feedback, and readable affordances.

Do not rely on a single color cue as the only navigation language. Color-based guidance should be distinguishable through additional forms such as shape, contrast, material, sound, animation, or interface support.

## Agency and discoverability

Separate discoverability from difficulty.

Players should be able to infer where progress may be possible without automatically knowing the safest route, the optimal route, the exact solution, or every available reward.

A route may be deliberately ambiguous when ambiguity creates meaningful exploration or tension. It should not remain ambiguous solely because the intended path is poorly communicated.

## Explicit guidance

Explicit guidance may include waypoints, minimaps, compass markers, route lines, objective text, interaction prompts, companion dialogue, or visual markings.

Use it when:

- A player requests it.
- It is necessary to meet accessibility needs.
- The objective cannot reasonably be inferred from the environment.
- The task is routine or repeated and additional searching would not create meaningful play.
- The player has demonstrated repeated failure or sustained non-progress.
- The genre, pacing, or narrative context calls for direct instruction.

Avoid using permanent guidance as the first response to a playtest failure without first evaluating the environment, camera, objective clarity, interaction feedback, and accessibility context.

## Adaptive hints

Adaptive hints should be optional, dismissible where feasible, and proportionate to evidence.

Possible evidence includes:

- Repeated return to the same location.
- Repeated failed interaction attempts.
- Sustained time without meaningful progress.
- Multiple plausible but unsuccessful routes.
- Explicit player request.
- A player-accessibility setting.

Do not use elapsed time alone as proof that a player is lost. Slow play, exploration, observation, experimentation, and intentional detours may be valid player choices.

## Accessibility and player control

Provide guidance choices that support different player needs and preferences.

Where feasible, allow players to adjust:

- HUD visibility and objective-marker intensity.
- Hint frequency and timing.
- Navigation mode, including minimal, contextual, or explicit guidance.
- Text, icon, audio, contrast, color, and motion cues.
- Companion assistance and repeated instruction.
- Puzzle and traversal assistance.

Accessibility support is not a failure of level design. A player should not need to sacrifice access in order to experience environmental storytelling.

## Playtest and iteration

Test navigation with people who did not build the level.

Record:

- The intended player goal.
- The environmental cues available.
- First-attempt route selection and completion.
- Confusion points and duration.
- Hint requests, hint triggers, and UI activation.
- Camera, affordance, interaction, or accessibility barriers.
- Player-reported confidence, agency, and immersion.
- The smallest intervention likely to address the observed issue.

When players fail to progress, classify the cause before revising the design:

- Unclear goal.
- Unreadable environmental cue.
- Camera or control limitation.
- Unclear interaction affordance.
- Deliberate challenge.
- Accessibility barrier.
- Preference for explicit guidance.
- Technical defect.
- Insufficient or conflicting playtest evidence.

Revise the environment before adding persistent UI when that change can solve the documented issue without reducing access.

## Review questions

Before adding or increasing navigation UI, ask:

1. What is the player's immediate goal?
2. What environmental evidence currently points toward plausible progress?
3. Can players see, hear, infer, or test the next action?
4. Is confusion intentional, fair, and productive?
5. Which player groups experience difficulty, and why?
6. Would a contextual, optional, or delayed hint be sufficient?
7. Does the proposed UI reveal more than necessary?
8. Can the change be toggled or adjusted by the player?
9. What evidence will determine whether the change improved access and preserved agency?

## Limits

This standard does not prescribe a single genre, camera model, visual style, accessibility configuration, or level structure. It does not replace usability research, accessibility testing, platform requirements, player-safety review, or technical quality assurance.
