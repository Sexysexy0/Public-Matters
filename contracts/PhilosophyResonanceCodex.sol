// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PhilosophyResonanceCodex
/// @notice Codex covenant to document themes from Lex Fridman × Jordan Peterson dialogue
contract PhilosophyResonanceCodex {
    address public overseer;
    uint256 public codexCount;

    struct ThemeRecord {
        uint256 id;
        string theme;       // Nietzsche, Perception, Ideology, Hero Myth, Psychopathy, Resilience
        string detail;      // description of insight
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ThemeRecord) public records;

    event ThemeLogged(uint256 indexed id, string theme, string detail);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs philosophical theme record
    function logTheme(string calldata theme, string calldata detail, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = ThemeRecord({
            id: codexCount,
            theme: theme,
            detail: detail,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ThemeLogged(codexCount, theme, detail);
    }

    /// @notice Citizens can view theme records
    function viewTheme(uint256 id) external view returns (ThemeRecord memory) {
        return records[id];
    }
}
