// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ReliabilityContinuumCodex
/// @notice Codex covenant for long-term reliability of curated sources
contract ReliabilityContinuumCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct ReliabilityCodex {
        uint256 id;
        string industry;     // e.g. business, movie, music
        string source;       // reliable source identifier
        string reliability;  // high, medium, low
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ReliabilityCodex) public codices;

    event CodexLogged(uint256 indexed id, string industry, string source, string reliability, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs reliability codex for industry source
    function logCodex(string calldata industry, string calldata source, string calldata reliability, string calldata notes) external onlyOversight {
        codexCount++;
        codices[codexCount] = ReliabilityCodex({
            id: codexCount,
            industry: industry,
            source: source,
            reliability: reliability,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CodexLogged(codexCount, industry, source, reliability, notes);
    }

    /// @notice Citizens can view reliability codex records
    function viewCodex(uint256 id) external view returns (ReliabilityCodex memory) {
        return codices[id];
    }
}
