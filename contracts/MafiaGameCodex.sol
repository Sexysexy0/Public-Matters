// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MafiaGameCodex
/// @notice Codex covenant to document Mafia game roles, eliminations, and outcomes
contract MafiaGameCodex {
    address public overseer;
    uint256 public roundCount;

    struct RoundRecord {
        uint256 id;
        string player;      // e.g. Sam Altman, Palmer Luckey
        string role;        // Mafia, Angel, Sheriff, Townsfolk
        string action;      // eliminated, protected, investigated
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => RoundRecord) public records;

    event RoundLogged(uint256 indexed id, string player, string role, string action);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs round record
    function logRound(string calldata player, string calldata role, string calldata action, string calldata notes) external onlyOverseer {
        roundCount++;
        records[roundCount] = RoundRecord({
            id: roundCount,
            player: player,
            role: role,
            action: action,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RoundLogged(roundCount, player, role, action);
    }

    /// @notice Citizens can view round records
    function viewRound(uint256 id) external view returns (RoundRecord memory) {
        return records[id];
    }
}
