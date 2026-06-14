// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IdeologyFailureLedger
/// @notice Ledger covenant to record catastrophic failures of totalitarian ideologies
contract IdeologyFailureLedger {
    address public overseer;
    uint256 public entryCount;

    struct FailureRecord {
        uint256 id;
        string ideology;    // Communism, Nazism
        string consequence; // famine, genocide, collapse
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => FailureRecord) public records;

    event FailureLogged(uint256 indexed id, string ideology, string consequence);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs ideology failure record
    function logFailure(string calldata ideology, string calldata consequence, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = FailureRecord({
            id: entryCount,
            ideology: ideology,
            consequence: consequence,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FailureLogged(entryCount, ideology, consequence);
    }

    /// @notice Citizens can view ideology failure records
    function viewFailure(uint256 id) external view returns (FailureRecord memory) {
        return records[id];
    }
}
