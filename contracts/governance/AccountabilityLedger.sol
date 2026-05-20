// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * AccountabilityLedger
 * Governance contract para sa transparent audit trail ng lahat ng actions.
 * - Owner: highest authority (Vinvin)
 * - Members: DAO participants
 * - Functions: log denial, confirmation, resolution, override
 */
contract AccountabilityLedger {
    address public owner;
    mapping(address => bool) public members;

    enum ActionType { Denial, Confirmation, Resolution, Override }

    struct ActionLog {
        uint256 id;
        address actor;
        ActionType action;
        string details;
        uint256 timestamp;
    }

    uint256 public nextActionId;
    mapping(uint256 => ActionLog) public logs;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event ActionRecorded(uint256 indexed id, address indexed actor, ActionType action, string details);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Not member");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Governance: add/remove members
    function addMember(address member) external onlyOwner {
        members[member] = true;
        emit MemberAdded(member);
    }

    function removeMember(address member) external onlyOwner {
        members[member] = false;
        emit MemberRemoved(member);
    }

    // Record an action
    function recordAction(ActionType action, string calldata details) external onlyMember {
        logs[nextActionId] = ActionLog({
            id: nextActionId,
            actor: msg.sender,
            action: action,
            details: details,
            timestamp: block.timestamp
        });
        emit ActionRecorded(nextActionId, msg.sender, action, details);
        nextActionId++;
    }

    // Owner override: force record
    function forceRecord(ActionType action, string calldata details) external onlyOwner {
        logs[nextActionId] = ActionLog({
            id: nextActionId,
            actor: msg.sender,
            action: action,
            details: details,
            timestamp: block.timestamp
        });
        emit ActionRecorded(nextActionId, msg.sender, action, details);
        nextActionId++;
    }
}
