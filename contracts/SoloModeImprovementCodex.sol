// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SoloModeImprovementCodex
/// @notice Codex covenant to encode player feedback and suggestions for REDSEC Solo Mode
contract SoloModeImprovementCodex {
    address public overseer;
    uint256 public codexCount;

    struct ImprovementRecord {
        uint256 id;
        string theme;       // e.g., Solo Mode, Optimization, Loot Economy, Cinematic Replay
        string suggestion;  // actionable improvement
        string source;      // player comment, creator reflection
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ImprovementRecord) public records;

    event ImprovementLogged(uint256 indexed id, string theme, string suggestion, string source);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs improvement record
    function logImprovement(string calldata theme, string calldata suggestion, string calldata source, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ImprovementRecord({
            id: codexCount,
            theme: theme,
            suggestion: suggestion,
            source: source,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ImprovementLogged(codexCount, theme, suggestion, source);
    }

    /// @notice Citizens can view improvement records
    function viewImprovement(uint256 id) external view returns (ImprovementRecord memory) {
        return records[id];
    }
}
