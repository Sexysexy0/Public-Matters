// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * OversightDAO
 * Governance contract para sa incident oversight at accountability.
 * - Owner: highest authority (Vinvin)
 * - Members: auditors, coders, ambassadors
 * - Functions: log incidents, vote severity, resolve issues
 */
contract OversightDAO {
    address public owner;
    mapping(address => bool) public members;

    enum Severity { Low, Medium, High, Critical }

    struct Incident {
        uint256 id;
        address reporter;
        string description;
        uint256 timestamp;
        Severity severity;
        bool resolved;
    }

    uint256 public nextIncidentId;
    mapping(uint256 => Incident) public incidents;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event IncidentLogged(uint256 indexed id, address indexed reporter, string description, Severity severity);
    event IncidentResolved(uint256 indexed id, address indexed resolver);

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

    // Incident logging
    function logIncident(string calldata description, Severity severity) external onlyMember {
        incidents[nextIncidentId] = Incident({
            id: nextIncidentId,
            reporter: msg.sender,
            description: description,
            timestamp: block.timestamp,
            severity: severity,
            resolved: false
        });
        emit IncidentLogged(nextIncidentId, msg.sender, description, severity);
        nextIncidentId++;
    }

    // Resolve incident
    function resolveIncident(uint256 id) external onlyMember {
        require(!incidents[id].resolved, "Already resolved");
        incidents[id].resolved = true;
        emit IncidentResolved(id, msg.sender);
    }

    // Owner override: force resolve
    function forceResolve(uint256 id) external onlyOwner {
        incidents[id].resolved = true;
        emit IncidentResolved(id, msg.sender);
    }
}
