// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TrusteeProgramCodex
/// @notice Covenant to encode program officer responsibilities and governance safeguards
contract TrusteeProgramCodex {
    address public overseer;
    uint256 public recordCount;

    struct ProgramRecord {
        uint256 id;
        string domain;      // program supervision, budget, reporting, stakeholder, strategy, compliance
        string safeguard;   // accountability clause, transparency clause, equity safeguard
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ProgramRecord) public records;

    event ProgramLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs program governance record
    function logProgram(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        recordCount++;
        records[recordCount] = ProgramRecord({
            id: recordCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ProgramLogged(recordCount, domain, safeguard);
    }

    /// @notice Citizens can view program governance records
    function viewProgram(uint256 id) external view returns (ProgramRecord memory) {
        return records[id];
    }
}
