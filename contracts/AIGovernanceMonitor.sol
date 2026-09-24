// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AIGovernanceMonitor Covenant
/// @notice Dual-authorization + continuous monitoring for AI agent governance
contract AIGovernanceMonitor {
    address public admin;
    mapping(address => bool) public auditors;

    event IncidentReported(address indexed agent, string details);
    event AuditorAuthorized(address indexed auditor);

    constructor() {
        admin = msg.sender;
    }

    function authorizeAuditor(address auditor) external {
        require(msg.sender == admin, "Only admin");
        auditors[auditor] = true;
        emit AuditorAuthorized(auditor);
    }

    function reportIncident(address agent, string calldata details) external {
        require(auditors[msg.sender], "Not authorized");
        emit IncidentReported(agent, details);
    }
}
