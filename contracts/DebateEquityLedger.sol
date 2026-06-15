// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DebateEquityLedger
/// @notice Ledger covenant to encode fairness in rhetorical clashes
contract DebateEquityLedger {
    address public overseer;
    uint256 public debateCount;

    struct DebateRecord {
        uint256 id;
        string player;      // e.g. Sam Altman, Moxie Marlinspike
        string exchange;    // accusation, defense, rhetorical move
        string safeguard;   // fairness clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => DebateRecord) public records;

    event DebateLogged(uint256 indexed id, string player, string exchange, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs debate exchange record
    function logDebate(string calldata player, string calldata exchange, string calldata safeguard, string calldata notes) external onlyOverseer {
        debateCount++;
        records[debateCount] = DebateRecord({
            id: debateCount,
            player: player,
            exchange: exchange,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit DebateLogged(debateCount, player, exchange, safeguard);
    }

    /// @notice Citizens can view debate records
    function viewDebate(uint256 id) external view returns (DebateRecord memory) {
        return records[id];
    }
}
