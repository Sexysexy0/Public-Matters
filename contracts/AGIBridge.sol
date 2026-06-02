// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AGIBridge
/// @notice Bridge contract linking AGIContinuity, AGICouncil, and AGIArchive
/// @dev Provides unified governance and archival flow for AGI safeguards

interface IAGIContinuity {
    function logMilestone(string calldata stage, string calldata description) external;
    function logAudit(string calldata sector, string calldata findings) external;
    function logEthicalCheck(string calldata company, string calldata report) external;
}

interface IAGICouncil {
    function createProposal(string calldata subject, string calldata action) external;
    function executeProposal(uint256 id) external;
}

interface IAGIArchive {
    function storeRecord(string calldata category, string calldata content) external;
}

contract AGIBridge {
    address public steward;
    IAGIContinuity public continuity;
    IAGICouncil public council;
    IAGIArchive public archive;

    event BridgeLinked(address continuity, address council, address archive, uint256 timestamp);
    event UnifiedAction(string category, string content, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _steward, address _continuity, address _council, address _archive) {
        steward = _steward;
        continuity = IAGIContinuity(_continuity);
        council = IAGICouncil(_council);
        archive = IAGIArchive(_archive);
        emit BridgeLinked(_continuity, _council, _archive, block.timestamp);
    }

    /// @notice Unified logging of milestone + archival
    function unifiedMilestone(string calldata stage, string calldata description) external onlySteward {
        continuity.logMilestone(stage, description);
        archive.storeRecord("Milestone", description);
        emit UnifiedAction("Milestone", description, block.timestamp);
    }

    /// @notice Unified logging of audit + archival
    function unifiedAudit(string calldata sector, string calldata findings) external onlySteward {
        continuity.logAudit(sector, findings);
        archive.storeRecord("Disruption Audit", findings);
        emit UnifiedAction("Disruption Audit", findings, block.timestamp);
    }

    /// @notice Unified logging of ethical check + archival
    function unifiedEthical(string calldata company, string calldata report) external onlySteward {
        continuity.logEthicalCheck(company, report);
        archive.storeRecord("Ethical Check", report);
        emit UnifiedAction("Ethical Check", report, block.timestamp);
    }

    /// @notice Unified council proposal + archival
    function unifiedProposal(string calldata subject, string calldata action) external onlySteward {
        council.createProposal(subject, action);
        archive.storeRecord("Council Proposal", action);
        emit UnifiedAction("Council Proposal", action, block.timestamp);
    }
}
