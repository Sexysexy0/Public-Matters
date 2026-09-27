# Fictional Operations Ghost-Operator Case Example

## Status

This is a fictional training example. It does not describe a real worker, organization, facility, machine, incident, vendor, credential, or safety event.

## Record administration

- Record identifier: GHOST-OPS-DEMO-001
- Date opened: Fictional date
- Assessor role: Operations improvement facilitator
- Site or system: Fictional packaged-goods line
- Information classification: Internal training example
- Access restrictions: No real operational information
- Status: Closed fictional example

## Condition summary

- Plain-language description: During a recurring production-report reconciliation, an experienced shift coordinator manually corrects a data-export spreadsheet so the daily report matches the production counter.
- Operational purpose: Prevent an incorrect daily production total from being sent to planning and inventory teams.
- Trigger: A data export intermittently rounds a batch count incorrectly after an unplanned restart.
- Frequency: Approximately two or three times per month in the fictional scenario.
- How the practice became known: The coordinator described the correction during a non-disciplinary workflow review.
- Is the practice documented: No.
- Is the practice required for current operations: Temporarily yes, until the reporting defect is corrected.
- Is work able to continue safely without it: Production can continue, but planning and inventory data may be inaccurate.

## Affected operations

- Process affected: Production reporting and inventory planning.
- Operational owner: Fictional production reporting manager.
- Backup owner: Fictional manufacturing systems analyst.
- Teams affected: Shift operations, planning, inventory control, and finance reconciliation.
- Upstream dependency: Production-counter export after restart events.
- Downstream dependency: Daily plan, inventory record, and management report.
- Third-party involvement: None in this fictional example.
- Known recovery method: Re-run export and compare the batch counter with the raw line-event log.

## Practice classification

- Person-dependent knowledge.
- Manual data correction outside the approved reporting system.
- Recurring exception or temporary workaround.
- Missing interface or system capability.

## Evidence and visibility

- Evidence sources: Coordinator interview, sample daily reports, production-counter records, and raw line-event logs.
- Evidence summary: The exported report undercounts one batch after a specific restart sequence. The manual correction matches the raw line-event log in the reviewed fictional examples.
- Existing logs or audit trail: Raw line-event log exists; the spreadsheet correction is not separately logged.
- Existing approvals: No documented authority for the manual correction.
- Existing documentation: The written reporting procedure instructs staff to export and submit the report but does not address restart-related count discrepancies.
- Difference between written process and actual work: The actual process includes a manual reconciliation step known to one coordinator.
- Reporter protection concern: The coordinator should not be disciplined for surfacing a good-faith workaround that prevented inaccurate reporting.

## Risk and continuity assessment

- Safety exposure: Low in this fictional scenario because the correction does not control machinery or safety functions.
- Quality exposure: Medium because inaccurate counts can distort production performance analysis.
- Security exposure: Low if access to the raw log and spreadsheet remains restricted.
- Privacy exposure: Low because the example uses no personal customer data.
- Financial exposure: Medium because inventory and planning decisions may be affected.
- Continuity exposure: Medium because the correction depends on one experienced coordinator.
- Consequence if unavailable: Incorrect reports may be sent or reporting may be delayed.
- Existing controls: Raw line-event log and coordinator review.
- Immediate containment: Require a second reviewer for corrections and record each correction in a temporary exception log.

## Access and authority

- Required systems and tools: Reporting export, production-counter record, raw line-event log, controlled spreadsheet.
- Access holder type: Named accounts in the fictional scenario.
- Least-privilege review: Required before giving additional workers access to raw line-event logs.
- Approval authority: Fictional production reporting manager.
- Exception expiry: Thirty days or until the reporting defect is corrected, whichever occurs first.
- Revocation and recovery: Remove temporary spreadsheet-edit access after the approved reporting fix is deployed and verified.
- Audit trail: Temporary correction log records date, reason, source evidence, editor, reviewer, and approval.

## Response decision

- Recommended response: Time-bound exception, formalization of interim reconciliation, and redesign of the reporting export.
- Why this response is proportionate: The workaround addresses a verified reporting defect, but single-person knowledge and unlogged corrections create continuity and accountability risk.
- Formal process needed: Interim reconciliation procedure with named owner, backup reviewer, evidence source, and escalation path.
- Training needed: Cross-train two additional authorized staff on reading the raw line-event log and using the interim procedure.
- Technology change needed: Correct the restart-event export logic and add an automated discrepancy flag.
- Worker support: Recognize the coordinator's good-faith reporting and involve them in validating the replacement workflow.
- Fallback plan: If the automated correction fails, use the approved interim reconciliation procedure and temporary exception log.
- Target completion: Fictional date after testing and management-of-change approval.

## Machinery and safety checkpoint

- Applicability: Not applicable to machine-control changes in this fictional example.
- Safeguard: The reporting correction must not modify machine logic, production-control settings, alarm states, interlocks, safety devices, or lockout/tagout controls.
- Escalation: Any proposed change affecting machine controls requires qualified engineering and safety review under the applicable management-of-change process.

## Review and closure

- Outcome: The fictional team added an automated discrepancy flag, corrected the export logic, and documented the interim procedure for the transition period.
- Procedure-to-practice alignment: Verified through fictional shift-handover and report-review exercises.
- Owner and backup owner: Confirmed.
- Recovery test: The backup reviewer completed a fictional reconciliation using the documented sources.
- Worker feedback: The coordinator reported that the documented process removed pressure to rely on memory and informal approval.
- Remaining risk: Monitor future restart events for new count discrepancies.
- Closure condition: Close only after the corrected export and discrepancy flag perform as expected across a defined observation period.
- Follow-up review: Fictional scheduled review after deployment.
