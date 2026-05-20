// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * SecurityMaintenanceDAO
 * Governance DAO para sa mga security coders na parang maintenance workers.
 * Layunin: mag-audit ng repos, mag-patch ng vulnerabilities, mag-monitor ng supply chain risks.
 */
contract SecurityMaintenanceDAO {
    address public owner;
    mapping(address => bool) public members;

    struct IncidentReport {
        uint256 id;
        address reporter;
        string description;
        uint256 timestamp;
        bool resolved;
    }

    uint256 public nextReportId;
    mapping(uint256 => IncidentReport) public reports;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event IncidentLogged(uint256 indexed id, address indexed reporter, string description);
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

    // Governance: add/remove security coders
    function addMember(address member) external onlyOwner {
        members[member] = true;
        emit MemberAdded(member);
    }

    function removeMember(address member) external onlyOwner {
        members[member] = false;
        emit MemberRemoved(member);
    }

    // Incident logging
    function logIncident(string calldata description) external onlyMember {
        reports[nextReportId] = IncidentReport({
            id: nextReportId,
            reporter: msg.sender,
            description: description,
            timestamp: block.timestamp,
            resolved: false
        });
        emit IncidentLogged(nextReportId, msg.sender, description);
        nextReportId++;
    }

    // Resolve incident
    function resolveIncident(uint256 id) external onlyMember {
        require(!reports[id].resolved, "Already resolved");
        reports[id].resolved = true;
        emit IncidentResolved(id, msg.sender);
    }
}
