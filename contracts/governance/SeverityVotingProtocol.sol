// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * SeverityVotingProtocol
 * Governance contract para sa severity classification ng incidents.
 * - Members: DAO participants
 * - Owner: highest authority (Vinvin)
 * - Functions: propose severity, vote, finalize, override
 */
contract SeverityVotingProtocol {
    address public owner;
    mapping(address => bool) public members;

    enum Severity { Low, Medium, High, Critical }

    struct Vote {
        address voter;
        Severity severity;
    }

    struct Incident {
        uint256 id;
        string description;
        uint256 timestamp;
        bool finalized;
        Severity finalSeverity;
        Vote[] votes;
    }

    uint256 public nextIncidentId;
    mapping(uint256 => Incident) public incidents;

    event MemberAdded(address indexed member);
    event MemberRemoved(address indexed member);
    event IncidentProposed(uint256 indexed id, string description);
    event SeverityVoted(uint256 indexed id, address indexed voter, Severity severity);
    event SeverityFinalized(uint256 indexed id, Severity severity);
    event SeverityOverridden(uint256 indexed id, Severity severity);

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

    // Propose new incident
    function proposeIncident(string calldata description) external onlyMember {
        Incident storage inc = incidents[nextIncidentId];
        inc.id = nextIncidentId;
        inc.description = description;
        inc.timestamp = block.timestamp;
        inc.finalized = false;
        emit IncidentProposed(nextIncidentId, description);
        nextIncidentId++;
    }

    // Vote severity
    function voteSeverity(uint256 id, Severity severity) external onlyMember {
        require(!incidents[id].finalized, "Already finalized");
        incidents[id].votes.push(Vote({voter: msg.sender, severity: severity}));
        emit SeverityVoted(id, msg.sender, severity);
    }

    // Finalize severity (simple majority)
    function finalizeSeverity(uint256 id) external onlyMember {
        require(!incidents[id].finalized, "Already finalized");
        uint256[] memory counts = new uint256[](4);

        for (uint i = 0; i < incidents[id].votes.length; i++) {
            counts[uint(incidents[id].votes[i].severity)]++;
        }

        uint256 maxCount = 0;
        Severity chosen = Severity.Low;
        for (uint j = 0; j < 4; j++) {
            if (counts[j] > maxCount) {
                maxCount = counts[j];
                chosen = Severity(j);
            }
        }

        incidents[id].finalSeverity = chosen;
        incidents[id].finalized = true;
        emit SeverityFinalized(id, chosen);
    }

    // Owner override
    function overrideSeverity(uint256 id, Severity severity) external onlyOwner {
        incidents[id].finalSeverity = severity;
        incidents[id].finalized = true;
        emit SeverityOverridden(id, severity);
    }
}
