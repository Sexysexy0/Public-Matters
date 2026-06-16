// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title NarrativeAtomicCodex
/// @notice Codex covenant to encode Watchmen narrative irony vs film adaptation
contract NarrativeAtomicCodex {
    address public overseer;
    uint256 public ironyCount;

    struct IronyRecord {
        uint256 id;
        string domain;      // joke on reader, mastery of time, Dr. Manhattan, film vs comic
        string safeguard;   // dignity clause, equity clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => IronyRecord) public records;

    event IronyLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs narrative irony record
    function logIrony(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        ironyCount++;
        records[ironyCount] = IronyRecord({
            id: ironyCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit IronyLogged(ironyCount, domain, safeguard);
    }

    /// @notice Citizens can view narrative irony records
    function viewIrony(uint256 id) external view returns (IronyRecord memory) {
        return records[id];
    }
}
