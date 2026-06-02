// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NoosphereOracle
/// @notice Safeguard contract for myth graffiti and ARG storytelling
/// @dev Encodes narrative arcs, proto-AI flows, and weaponized ARG audits

contract NoosphereOracle {
    address public storyteller;
    uint256 public arcCount;
    uint256 public flowCount;
    uint256 public auditCount;

    struct MythArc {
        uint256 id;
        string theme;       // e.g., "Ong's Hat", "Counterculture Narrative"
        string description;
        uint256 timestamp;
    }

    struct StoryFlow {
        uint256 id;
        string system;      // e.g., "Proto-AI", "Chatbot Emory"
        string resonance;   // e.g., "Graffiti on Noosphere"
        uint256 timestamp;
    }

    struct ARGWeaponAudit {
        uint256 id;
        string caseStudy;   // e.g., "John Titor", "QAnon", "Pizzagate"
        string findings;    // e.g., "Weaponized narrative tactics"
        uint256 timestamp;
    }

    mapping(uint256 => MythArc) public arcs;
    mapping(uint256 => StoryFlow) public flows;
    mapping(uint256 => ARGWeaponAudit) public audits;

    event ArcLogged(uint256 id, string theme, string description, uint256 timestamp);
    event FlowLogged(uint256 id, string system, string resonance, uint256 timestamp);
    event AuditLogged(uint256 id, string caseStudy, string findings, uint256 timestamp);
    event OracleCheck(string report, uint256 timestamp);

    modifier onlyStoryteller() {
        require(msg.sender == storyteller, "Not authorized");
        _;
    }

    constructor(address _storyteller) {
        storyteller = _storyteller;
        arcCount = 0;
        flowCount = 0;
        auditCount = 0;
    }

    /// @notice Log a new myth arc
    function logArc(string calldata theme, string calldata description) external onlyStoryteller {
        arcCount++;
        arcs[arcCount] = MythArc(arcCount, theme, description, block.timestamp);
        emit ArcLogged(arcCount, theme, description, block.timestamp);
    }

    /// @notice Log a proto-AI storytelling flow
    function logFlow(string calldata system, string calldata resonance) external onlyStoryteller {
        flowCount++;
        flows[flowCount] = StoryFlow(flowCount, system, resonance, block.timestamp);
        emit FlowLogged(flowCount, system, resonance, block.timestamp);
    }

    /// @notice Log a weaponized ARG audit
    function logAudit(string calldata caseStudy, string calldata findings) external onlyStoryteller {
        auditCount++;
        audits[auditCount] = ARGWeaponAudit(auditCount, caseStudy, findings, block.timestamp);
        emit AuditLogged(auditCount, caseStudy, findings, block.timestamp);
    }

    /// @notice Oracle check for narrative integrity
    function logOracleCheck(string calldata report) external onlyStoryteller {
        emit OracleCheck(report, block.timestamp);
    }
}
