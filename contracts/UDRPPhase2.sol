// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title UDRPPhase2
/// @notice Smart contract governance system para sa Tier 2 issues ng WIPO-ICA UDRP Review
contract UDRPPhase2 {

    // --- Tier 2 Issues ---
    enum IssueType { BadFaithLoop, SupplementalFilings, PanelistQuality, FreeSpeechDefense }

    // --- Events for Transparency ---
    event IssueRaised(uint indexed issueId, IssueType issueType, string description);
    event SafeguardApplied(uint indexed issueId, string safeguard);
    event IssueResolved(uint indexed issueId, string resolution);

    // --- Storage ---
    struct Issue {
        IssueType issueType;
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
    function raiseIssue(IssueType _issueType, string memory _description) public onlyAdmin {
        issueCounter++;
        issues[issueCounter] = Issue(_issueType, _description, false);
        emit IssueRaised(issueCounter, _issueType, _description);
        _applySafeguard(issueCounter, _issueType);
    }

    function resolveIssue(uint _issueId, string memory _resolution) public onlyAdmin {
        issues[_issueId].resolved = true;
        emit IssueResolved(_issueId, _resolution);
    }

    // --- Auto-Mapping Issue → Safeguard ---
    function _applySafeguard(uint _issueId, IssueType _issueType) internal {
        string memory safeguard;
        if (_issueType == IssueType.BadFaithLoop) {
            safeguard = "Apply flexible AND/OR safeguard for bad faith use";
        } else if (_issueType == IssueType.SupplementalFilings) {
            safeguard = "Limit supplemental filings to exceptional cases";
        } else if (_issueType == IssueType.PanelistQuality) {
            safeguard = "Enforce accreditation and conflict-of-interest safeguards";
        } else if (_issueType == IssueType.FreeSpeechDefense) {
            safeguard = "Ensure consistent fair use and criticism site protection";
        }
        emit SafeguardApplied(_issueId, safeguard);
    }
}
