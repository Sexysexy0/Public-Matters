// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DeceptionEquityLedger
/// @notice Ledger covenant to encode fairness safeguards in social deduction games
contract DeceptionEquityLedger {
    address public overseer;
    uint256 public equityCount;

    struct EquityRecord {
        uint256 id;
        string player;      // e.g. Sam Altman, Palmer Luckey
        string situation;   // accusation, elimination, role claim
        string safeguard;   // fairness clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => EquityRecord) public records;

    event EquityLogged(uint256 indexed id, string player, string situation, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs fairness safeguard record
    function logEquity(string calldata player, string calldata situation, string calldata safeguard, string calldata notes) external onlyOverseer {
        equityCount++;
        records[equityCount] = EquityRecord({
            id: equityCount,
            player: player,
            situation: situation,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit EquityLogged(equityCount, player, situation, safeguard);
    }

    /// @notice Citizens can view fairness safeguard records
    function viewEquity(uint256 id) external view returns (EquityRecord memory) {
        return records[id];
    }
}
