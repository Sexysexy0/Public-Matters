// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

/**
 * @title SecurityGovernance
 * @dev Enhanced covenant: strict access control, multi-sig emergency, breach logging, and audit trail.
 */
contract SecurityGovernance is AccessControl, Pausable {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    bytes32 public constant ARCHIVER_ROLE = keccak256("ARCHIVER_ROLE");

    uint256 public quorumRequired = 2;
    mapping(address => bool) public emergencyVotes;
    uint256 public voteCount;

    event EmergencyTriggered(address indexed admin, bool isPaused);
    event DocumentArchived(uint256 indexed updateId, string IPFSHash);
    event BreachAttempt(address indexed actor, string reason);
    event AuditTrail(address indexed actor, string action, uint256 timestamp);

    constructor(address initialAdmin) {
        _grantRole(DEFAULT_ADMIN_ROLE, initialAdmin);
        _grantRole(OPERATOR_ROLE, initialAdmin);
        _grantRole(ARCHIVER_ROLE, initialAdmin);
    }

    modifier audit(string memory action) {
        emit AuditTrail(msg.sender, action, block.timestamp);
        _;
    }

    function triggerEmergencyVote() external onlyRole(DEFAULT_ADMIN_ROLE) audit("EmergencyVote") {
        require(!paused(), "Already paused");
        require(!emergencyVotes[msg.sender], "Already voted");
        emergencyVotes[msg.sender] = true;
        voteCount++;

        if (voteCount >= quorumRequired) {
            _pause();
            emit EmergencyTriggered(msg.sender, true);
            voteCount = 0;
        }
    }

    function resumeOperations() external onlyRole(DEFAULT_ADMIN_ROLE) audit("ResumeOps") {
        require(paused(), "System not paused");
        _unpause();
        emit EmergencyTriggered(msg.sender, false);
    }

    function logSystemState(uint256 updateId, string calldata ipfsHash)
        external
        onlyRole(OPERATOR_ROLE)
        whenNotPaused
        audit("LogSystemState")
    {
        if (updateId == 0 || bytes(ipfsHash).length == 0) {
            emit BreachAttempt(msg.sender, "Invalid log payload");
            revert("Governance: Invalid payload");
        }
        emit DocumentArchived(updateId, ipfsHash);
    }
}
