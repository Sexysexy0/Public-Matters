# AntitrustIntegrity Dashboard Spec

Purpose
Provide a single-page, tamper-proof dashboard that visualizes and alerts from AntitrustIntegrity events: whistleblower intake, merger submissions, council votes, investigations, FOIA requests, compliance violations, emergency freezes, and bounty payouts.

Primary audience
Investigative journalists, state AG teams, auditors, civic technologists.

Top-level layout
- Header: Project name; last indexed block/time; quick filters (date range, mergerId, caseId, identifier).
- KPI row (4 tiles): Open Whistle Cases; Active Mergers; Investigations In Progress; Frozen Identifiers.
- Time series: Events per day (stacked by type).
- Live feed: Chronological event log (most recent 50 events) with event type, id, actor, short payload. Click expands full event JSON.
- Entity panel: Inspect a selected mergerId / caseId / identifier — shows event timeline, votes, deposit, escrow balance, investigation reports, FOIA requests.
- Alerts & Rules: Configurable thresholds with on-screen and webhook alerts.
- Download / Share: Export event timeline (CSV) and permalink to current view.

Metrics and Data Sources
| Metric | Source Event | Why it matters |
|---|---:|---|
| Open Whistle Cases | WhistleblowerFiled | Tracks incoming leads and bounties |
| Active Mergers | MergerSubmitted, MergerApproved, MergerRejected | Shows pending corporate consolidation activity |
| Council Vote Rate | MergerVote | Detects voting patterns and unusual unanimity |
| Investigation Latency | InvestigationTriggered → InvestigationReport | Measures time to complete investigations |
| FOIA Fulfillment Rate | FOIARequest + fulfillFOIA | Transparency responsiveness |
| Frozen Identifiers | EmergencyFreeze, EmergencyLift | Flags emergency interventions |
| Bounty Payouts | BountyPaid | Incentive effectiveness |

Alert examples
- Merger deposit timeout reached without finalization → alert.
- Single submitter with >N mergers in 30 days → suspicious consolidation pattern.
- Council approvals concentrated to a small subset of members → influence concentration.

Event Mapping to index
- WhistleblowerFiled(caseId, reporter, evidenceHash, bounty, timestamp)
- MergerSubmitted(mergerId, submitter, deposit, submitTime)
- MergerVote(mergerId, voter, approve, timestamp)
- MergerApproved(mergerId)
- MergerRejected(mergerId)
- InvestigationTriggered(investigationId, mergerId, investigator, timestamp)
- InvestigationReport(investigationId, investigator, reportHash, timestamp)
- FOIARequest(requestId, requester, target, timestamp)
- ComplianceViolation(targetId, reason, timestamp)
- EmergencyFreeze(identifier, triggeredBy, timestamp)
- EmergencyLift(identifier, liftedBy, timestamp)
- BountyPaid(caseId, reporter, amount, timestamp)

Indexing keys
- Primary: blockNumber, txHash, logIndex
- Secondary: caseId, mergerId, investigationId, requestId, identifier, reporter, submitter, investigator, triggeredBy

Data Model SQL sketches
```sql
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  block_number BIGINT,
  tx_hash TEXT,
  log_index INT,
  event_type TEXT,
  payload JSONB,
  created_at TIMESTAMP
);

CREATE TABLE mergers (
  merger_id BIGINT PRIMARY KEY,
  submitter TEXT,
  deposit NUMERIC,
  submit_time TIMESTAMP,
  approvals INT DEFAULT 0,
  rejections INT DEFAULT 0,
  finalized BOOLEAN DEFAULT FALSE,
  approved BOOLEAN DEFAULT FALSE
);

CREATE TABLE whistlecases (
  case_id BIGINT PRIMARY KEY,
  reporter TEXT,
  evidence_hash TEXT,
  bounty NUMERIC,
  validated BOOLEAN DEFAULT FALSE,
  timestamp TIMESTAMP
);
