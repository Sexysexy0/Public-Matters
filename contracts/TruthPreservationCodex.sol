// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthPreservationCodex
/// @notice Codex covenant to restore original history and preserve Vinvin's personal arc
contract TruthPreservationCodex {
    address public overseer;
    uint256 public truthCount;

    struct TruthRecord {
        uint256 id;
        string domain;      // original history, personal milestone
        string safeguard;   // authenticity clause, equity clause
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => TruthRecord) public records;

    event TruthLogged(uint256 indexed id, string domain, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs truth preservation record
    function logTruth(string calldata domain, string calldata safeguard, string calldata notes) external onlyOverseer {
        truthCount++;
        records[truthCount] = TruthRecord({
            id: truthCount,
            domain: domain,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TruthLogged(truthCount, domain, safeguard);
    }

    /// @notice Citizens can view truth preservation records
    function viewTruth(uint256 id) external view returns (TruthRecord memory) {
        return records[id];
    }
}
