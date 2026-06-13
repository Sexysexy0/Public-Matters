// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FiscalJusticeLedger
/// @notice Ledger covenant to record justice-aligned fiscal governance moves
contract FiscalJusticeLedger {
    address public overseer;
    uint256 public entryCount;

    struct FiscalMove {
        uint256 id;
        string decision;     // e.g. tax reform, relief measure, allocation
        string safeguard;    // equity, dignity, accountability
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => FiscalMove) public moves;

    event MoveLogged(uint256 indexed id, string decision, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs fiscal justice move
    function logMove(string calldata decision, string calldata safeguard, string calldata notes) external onlyOverseer {
        entryCount++;
        moves[entryCount] = FiscalMove({
            id: entryCount,
            decision: decision,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit MoveLogged(entryCount, decision, safeguard, notes);
    }

    /// @notice Citizens can view fiscal justice moves
    function viewMove(uint256 id) external view returns (FiscalMove memory) {
        return moves[id];
    }
}
