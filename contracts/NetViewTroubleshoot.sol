// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NetViewTroubleshoot
/// @notice Smart contract governance system para sa IBM Tivoli NetView troubleshooting logic
contract NetViewTroubleshoot {
    
    // --- Severity Levels ---
    enum Severity { Critical, Significant, SomeImpact, Minimal }

    // --- Problem Classifications ---
    enum Classification { ABEND, DOC, INCORROUT, LOOP, MSG, PERFM, WAIT }

    // --- Events for Transparency ---
    event IssueReported(uint indexed issueId, Severity severity, string description);
    event IssueClassified(uint indexed issueId, Classification classification);
    event DiagnosticTriggered(uint indexed issueId, string tool);
    event IssueResolved(uint indexed issueId, string resolution);
    event AutoPlanExecuted(uint indexed issueId, string plan);

    // --- Storage ---
    struct Issue {
        Severity severity;
        Classification classification;
        string description;
        bool resolved;
    }

    mapping(uint => Issue) public issues;
    uint public issueCounter;

    // --- Access Control ---
    address public admin;
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can execute");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // --- Core Functions ---
    function reportIssue(Severity _severity, string memory _description) public onlyAdmin {
        issueCounter++;
        issues[issueCounter] = Issue(_severity, Classification.DOC, _description, false);
        emit IssueReported(issueCounter, _severity, _description);
        _executeAutoPlan(issueCounter, _severity);
    }

    function classifyIssue(uint _issueId, Classification _classification) public onlyAdmin {
        issues[_issueId].classification = _classification;
        emit IssueClassified(_issueId, _classification);
    }

    function triggerDiagnostic(uint _issueId, string memory _tool) public onlyAdmin {
        emit DiagnosticTriggered(_issueId, _tool);
    }

    function resolveIssue(uint _issueId, string memory _resolution) public onlyAdmin {
        issues[_issueId].resolved = true;
        emit IssueResolved(_issueId, _resolution);
    }

    // --- Auto-Mapping Severity → Resolution Plan ---
    function _executeAutoPlan(uint _issueId, Severity _severity) internal {
        string memory plan;
        if (_severity == Severity.Critical) {
            plan = "Emergency shutdown + immediate escalation";
        } else if (_severity == Severity.Significant) {
            plan = "Resource allocation + fallback procedures";
        } else if (_severity == Severity.SomeImpact) {
            plan = "Log issue + notify operators";
        } else if (_severity == Severity.Minimal) {
            plan = "Archive circumvention record";
        }
        emit AutoPlanExecuted(_issueId, plan);
    }
}
