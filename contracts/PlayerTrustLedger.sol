// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlayerTrustLedger
/// @notice Ledger covenant to encode history of broken promises and trust safeguards
contract PlayerTrustLedger {
    address public overseer;
    uint256 public entryCount;

    struct PromiseRecord {
        uint256 id;
        string promise;     // e.g. "No Loot Boxes"
        string outcome;     // what actually happened
        string safeguard;   // accountability clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PromiseRecord) public records;

    event PromiseLogged(uint256 indexed id, string promise, string outcome, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs broken promise record
    function logPromise(string calldata promise, string calldata outcome, string calldata safeguard, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = PromiseRecord({
            id: entryCount,
            promise: promise,
            outcome: outcome,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PromiseLogged(entryCount, promise, outcome, safeguard);
    }

    /// @notice Citizens can view promise records
    function viewPromise(uint256 id) external view returns (PromiseRecord memory) {
        return records[id];
    }
}
