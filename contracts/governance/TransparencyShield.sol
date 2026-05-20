// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * TransparencyShield
 * Public safeguard contract para sa immutable oversight logs.
 * - Owner: highest authority (Vinvin)
 * - Members: DAO participants
 * - Functions: publish logs, verify authenticity, enforce openness
 */
contract TransparencyShield {
    address public owner;
    mapping(address => bool) public members;

    struct PublicLog {
        uint256 id;
        address actor;
        string action;
        string details;
        uint256 timestamp;
    }

    uint256 public nextLogId;
    mapping(uint256 => PublicLog) public publicLogs;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event LogPublished(uint256 indexed id, address indexed actor, string action, string details);

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

    // Publish public log
    function publishLog(string calldata action, string calldata details) external onlyMember {
        publicLogs[nextLogId] = PublicLog({
            id: nextLogId,
            actor: msg.sender,
            action: action,
            details: details,
            timestamp: block.timestamp
        });
        emit LogPublished(nextLogId, msg.sender, action, details);
        nextLogId++;
    }

    // Owner override: force publish
    function forcePublish(string calldata action, string calldata details) external onlyOwner {
        publicLogs[nextLogId] = PublicLog({
            id: nextLogId,
            actor: msg.sender,
            action: action,
            details: details,
            timestamp: block.timestamp
        });
        emit LogPublished(nextLogId, msg.sender, action, details);
        nextLogId++;
    }
}
