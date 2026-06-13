// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PersonaContinuityBridge
/// @notice Bridge covenant to connect professional personality codex with integrity guardianship
contract PersonaContinuityBridge {
    address public oversightCommittee;
    uint256 public bridgeCount;

    struct ContinuityLink {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string codex;        // professional personality codex reference
        string guardian;     // integrity guardian reference
        string discipline;   // lawful, authentic, solution-driven
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityLink) public links;

    event ContinuityLinked(uint256 indexed id, string domain, string codex, string guardian, string discipline, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight links codex to guardian
    function linkContinuity(string calldata domain, string calldata codex, string calldata guardian, string calldata discipline, string calldata notes) external onlyOversight {
        bridgeCount++;
        links[bridgeCount] = ContinuityLink({
            id: bridgeCount,
            domain: domain,
            codex: codex,
            guardian: guardian,
            discipline: discipline,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ContinuityLinked(bridgeCount, domain, codex, guardian, discipline, notes);
    }

    /// @notice Citizens can view continuity links
    function viewContinuity(uint256 id) external view returns (ContinuityLink memory) {
        return links[id];
    }
}
