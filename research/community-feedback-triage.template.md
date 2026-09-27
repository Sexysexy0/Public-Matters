# Community Feedback Triage Template

## Purpose

This template turns community feedback into a documented, evidence-labeled improvement process for software, games, open-source projects, services, and public-interest initiatives.

Feedback documents user experience. It does not automatically prove technical cause, legal fault, intent, majority preference, or a required product decision.

## Triage cycle

Collect -> Classify -> De-duplicate -> Verify -> Prioritize -> Respond -> Implement or decline -> Measure -> Close or revisit

## 1. Collect

Record enough context to understand the reported experience:

- Source type and reference
- Date received or observed
- Reported theme
- Description in the reporter's terms where appropriate
- Product version, environment, or affected workflow where available
- Evidence status
- Privacy and sharing limitations

Do not collect credentials, private messages, unnecessary personal data, or information unrelated to the issue.

## 2. Classify

| Category | Examples |
|---|---|
| Reliability | Crashes, disconnects, failed saves, broken lobbies |
| Performance | Low frame rate, stutter, slow loading, battery or resource use |
| Usability | Confusing interface, difficult workflow, unclear instructions |
| Accessibility | Missing captions, input barriers, compatibility issues |
| Safety or abuse | Harassment, harmful behavior, moderation concerns |
| Fairness or balance | Matchmaking, spawn behavior, exploit, competitive imbalance |
| Progression or monetization | Unlock friction, reward design, pricing, paywall concern |
| Content or capability | Missing mode, feature request, map, integration, functionality |
| Documentation or support | Missing guide, unclear policy, unresolved support path |
| Other | Requires additional explanation |

Assign one primary category and optional secondary categories.

## 3. De-duplicate

Group substantially similar feedback without erasing meaningful differences. Record the common theme, known independent reports, affected versions or platforms, uncertainty notes, and representative evidence references.

High-volume feedback can signal importance, but it does not by itself establish root cause or priority.

## 4. Verify

| Evidence status | Meaning |
|---|---|
| `reported` | A person or source describes an experience; no independent confirmation yet |
| `observed` | A condition was directly observed in a documented environment |
| `reproduced` | A condition was independently repeated with documented steps |
| `disputed` | Credible sources conflict or evidence remains incomplete |
| `unsupported` | Insufficient information to rely on the claim |
| `fictional_example` | Demonstration data only; never a real issue report |

Verification questions:

1. Can the issue be reproduced?
2. Which version, platform, settings, or conditions are involved?
3. Who is affected and how severely?
4. Is the reported symptom distinct from the suspected cause?
5. Are there privacy, security, safety, or accessibility implications?
6. What evidence would resolve uncertainty?

## 5. Prioritize

| Criterion | Question |
|---|---|
| Severity | How serious is the user harm or operational impact? |
| Reach | How many and which groups may be affected? |
| Reproducibility | Can the condition be independently confirmed? |
| Safety and rights | Does it affect safety, privacy, accessibility, fairness, or lawful use? |
| Urgency | Does delay create escalating harm or irreversible loss? |
| Feasibility | Is there a safe, practical response? |
| Regression risk | Could a fix harm other users or systems? |
| Strategic fit | Does the response align with project purpose and commitments? |

## 6. Respond

| Status | Suggested language |
|---|---|
| Received | We recorded this feedback and are reviewing the available context. |
| Investigating | We are checking whether the reported condition can be reproduced. |
| Confirmed | We confirmed the issue in documented conditions and are prioritizing a response. |
| Implemented | A change was released; state its scope, version, and known limitation. |
| Declined | State the documented reason and any available alternative. |
| Needs evidence | State what detail would help investigate. |

Do not promise a date, fix, or outcome that cannot be supported.

## 7. Implement or decline

For each material issue, preserve:

- Issue identifier
- Evidence status and sources
- Priority rationale
- Chosen action or reason for decline
- Owner or responsible role
- Target version, review date, or next checkpoint
- Expected effect and measurable outcome
- Known limitations and rollback conditions

## 8. Measure

After a response, observe reproduction rate, crash or support trend, performance or latency change, accessibility feedback, new regressions, user understanding, and unresolved feedback.

## 9. Close or revisit

Close an item only when the decision and evidence are recorded. Reopen it when new evidence, a regression, changed conditions, or a material affected-user report justifies review.

## Privacy and anti-harassment boundaries

- Do not publish personal data, private messages, account identifiers, or credentials.
- Do not expose reporters to retaliation.
- Do not use feedback processes to organize harassment, brigading, or attacks on critics or competitors.
- Do not equate disagreement with bad faith.
- Preserve material negative feedback and stated limitations.
