// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LegacyResonanceCodex
/// @notice Codex covenant to encode enduring voice and moral witness legacy
contract LegacyResonanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct LegacyRecord {
        uint256 id;
        string voice;       // critic, whistleblower, moral witness
        string impact;      // public discourse, governance, cultural memory
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LegacyRecord) public records;

    event LegacyLogged(uint256 indexed id, string voice, string impact);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs legacy resonance record
    function logLegacy(string calldata voice, string calldata impact, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = LegacyRecord({
            id: codexCount,
            voice: voice,
            impact: impact,
            notes: notes,
            timestamp: block.timestamp
        });
        emit LegacyLogged(codexCount, voice, impact);
    }

    /// @notice Citizens can view legacy resonance records
    function viewLegacy(uint256 id) external view returns (LegacyRecord memory) {
        return records[id];
    }
}
