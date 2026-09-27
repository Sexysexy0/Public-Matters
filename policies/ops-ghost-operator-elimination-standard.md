# Operations Ghost-Operator Elimination Standard

## Purpose

This standard helps organizations identify and reduce undocumented operational dependencies that can create safety, quality, security, continuity, accountability, or resilience risks.

A ghost operator is a generic term for an undocumented person-dependent action, workaround, credential, override, script, spreadsheet, device configuration, or informal procedure that is necessary for work to continue but is not adequately visible, owned, reviewed, or controlled.

The term is descriptive, not accusatory. It must not be used to blame workers for gaps in documentation, staffing, training, tooling, leadership, or system design.

## Core principle

Make critical work visible, attributable, reviewable, and recoverable.

Organizations should understand how work is actually performed before attempting to eliminate a workaround. A documented practice may be formalized, redesigned, retired, or prohibited depending on its purpose, risk, evidence, and feasible alternatives.

## Examples of ghost-operator conditions

- A procedure known only by a long-tenured worker.
- An unowned script, macro, spreadsheet, or automation task.
- A shared, default, hard-coded, or unrevoked credential.
- A manual data correction completed outside the approved system.
- A machine override, bypass, jumper, or alarm suppression used without documented authorization.
- A shift-handover instruction communicated verbally but not recorded.
- A vendor configuration, remote access path, or service account with no current owner.
- A workaround required because the approved process, interface, equipment, or staffing model cannot meet actual operating conditions.
- A recurring exception handled informally because formal escalation is slow, unavailable, or unclear.

## Scope and proportionality

Apply this standard proportionately.

Higher-risk activities involving machinery, hazardous energy, production control, financial records, personal information, healthcare, public services, security controls, regulated systems, or external commitments require stronger review and formal controls.

Low-risk local practices may require only clear ownership, basic documentation, and periodic review. Do not impose burdensome process solely to create paperwork.

## Discovery

Use respectful, evidence-based discovery methods:

- Observe normal work and exception handling.
- Review shift handovers, tickets, logs, procedures, alarms, incident records, and maintenance history.
- Ask workers what they do when the documented process does not work.
- Identify tools, credentials, scripts, spreadsheets, devices, and integrations that lack an owner.
- Compare written procedures with actual work.
- Identify single-person dependencies, shared accounts, and undocumented escalation paths.
- Record the operational purpose of each workaround before evaluating it.

Do not conduct discovery as a disciplinary search. Protect good-faith reporting and distinguish unsafe or unauthorized conduct from a system that leaves workers without a practical approved path.

## Classification

For each identified condition, record:

- Operational purpose.
- System, asset, process, data, or service affected.
- Known owner and backup owner.
- Frequency and trigger.
- Required access, authority, tools, or credentials.
- Safety, quality, security, privacy, financial, continuity, and legal exposure.
- Existing controls, logs, approvals, and rollback capability.
- Consequence if the person, tool, or workaround is unavailable.
- Feasible formal alternative.
- Evidence limitations and review date.

## Response options

Select the least disruptive response that addresses the documented risk:

1. Retain and document the practice when it is low risk, necessary, and adequately controlled.
2. Formalize the practice with an owner, procedure, training, access control, and review cycle.
3. Redesign the process, interface, staffing model, automation, or equipment so the workaround is no longer needed.
4. Create a time-bound exception with explicit authority, monitoring, and an expiry date.
5. Transition the practice through supervised knowledge transfer and backup coverage.
6. Restrict or retire the practice when risk is unacceptable or a safer alternative exists.
7. Escalate for specialized safety, security, engineering, legal, privacy, labor, or regulatory review.

Do not remove a workaround before verifying that the formal process can support actual operating conditions.

## Access and accountability controls

For critical operations:

- Use named accounts and least-privilege access where feasible.
- Avoid shared credentials and document approved emergency-access arrangements.
- Maintain an owner and backup owner for scripts, integrations, service accounts, machine settings, and exception procedures.
- Record material changes, approvals, emergency actions, overrides, and reversals.
- Use time-bound access and time-bound exceptions where appropriate.
- Test access revocation, backups, recovery, and handover procedures.
- Preserve a usable audit trail without collecting unnecessary personal information.

## Machinery and safety safeguards

For machinery, production systems, hazardous energy, and other safety-sensitive operations:

- Do not bypass guards, interlocks, alarms, protective devices, permits, or lockout/tagout controls outside approved and authorized processes.
- Treat a recurring override or alarm suppression as evidence of a design, maintenance, capacity, training, or process issue requiring review.
- Require qualified technical and safety review before changing control logic, safety settings, calibration, or protective functions.
- Document emergency actions promptly and review them after stabilization.
- Stop or escalate work when conditions exceed authorized operating limits.

This standard does not authorize operational overrides or substitute for safety law, engineering controls, site procedures, or qualified supervision.

## Knowledge transfer and continuity

Reduce single-person dependency through:

- Current procedures written for real operating conditions.
- Cross-training and supervised practice.
- Backup owners and accessible contact paths.
- Version-controlled scripts, configurations, and runbooks.
- Shift-handover records and exception logs.
- Recovery exercises for absence, outage, system failure, and vendor loss.
- Periodic review of whether a documented procedure still matches actual work.

## Review and learning

Review conditions after an incident, near miss, outage, recurring exception, audit finding, staff transition, major system change, or material change in risk.

Measure progress using evidence such as:

- Number and severity of undocumented dependencies found and resolved.
- Reduction in shared or unowned privileged access.
- Procedure-to-practice alignment.
- Handover completeness.
- Recovery and cross-training success.
- Exception age and expiry compliance.
- Repeat incidents, near misses, rework, or downtime.
- Worker-reported ability to raise and resolve process gaps safely.

Do not use the number of reports alone as a failure measure. An increase in reports may indicate stronger visibility and psychological safety.

## Worker protections

- Do not punish workers for reporting undocumented workarounds in good faith.
- Do not treat documentation as a substitute for adequate staffing, time, equipment, training, or safe design.
- Involve affected workers in validating the real workflow and proposed change.
- Communicate why a practice is being changed and how work can continue safely.
- Provide training, transition time, and support before changing a critical process.

## Limits

This standard does not replace applicable law, collective agreements, occupational-safety requirements, lockout/tagout procedures, cybersecurity controls, privacy requirements, engineering review, management-of-change procedures, incident response, procurement rules, or professional judgment.
