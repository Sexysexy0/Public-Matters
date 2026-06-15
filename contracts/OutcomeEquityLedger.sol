// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OutcomeEquityLedger
/// @notice Ledger covenant to encode fairness in final results and accountability
contract OutcomeEquityLedger {
    address public overseer;
    uint256 public resultCount;

    struct ResultRecord {
        uint256 id;
        string faction;     // Mafia, Townsfolk, Angel, Sheriff
        string outcome;     // victory, defeat, stalemate
        string safeguard;   // fairness clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ResultRecord) public records;

    event ResultLogged(uint256 indexed id, string faction, string outcome, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs final result record
    function logResult(string calldata faction, string calldata outcome, string calldata safeguard, string calldata notes) external onlyOverseer {
        resultCount++;
        records[resultCount] = ResultRecord({
            id: resultCount,
            faction: faction,
            outcome: outcome,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ResultLogged(resultCount, faction, outcome, safeguard);
    }

    /// @notice Citizens can view final result records
    function viewResult(uint256 id) external view returns (ResultRecord memory) {
        return records[id];
    }
}
