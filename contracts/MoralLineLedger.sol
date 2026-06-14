// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MoralLineLedger
/// @notice Ledger covenant to document ethical stands and moral lines in governance and security
contract MoralLineLedger {
    address public overseer;
    uint256 public entryCount;

    struct MoralRecord {
        uint256 id;
        string decision;    // refusal to torture, whistleblowing, resistance
        string consequence; // prosecution, imprisonment, retaliation
        string principle;   // dignity, truth, justice
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => MoralRecord) public records;

    event MoralLogged(uint256 indexed id, string decision, string consequence, string principle);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs moral line record
    function logMoral(string calldata decision, string calldata consequence, string calldata principle, string calldata notes) external onlyOverseer {
        entryCount++;
        records[entryCount] = MoralRecord({
            id: entryCount,
            decision: decision,
            consequence: consequence,
            principle: principle,
            notes: notes,
            timestamp: block.timestamp
        });
        emit MoralLogged(entryCount, decision, consequence, principle);
    }

    /// @notice Citizens can view moral line records
    function viewMoral(uint256 id) external view returns (MoralRecord memory) {
        return records[id];
    }
}
