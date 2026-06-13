// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LogicSentinel
/// @notice Sentinel safeguard for monitoring logical rigor in orchestration outputs
contract LogicSentinel {
    address public oversightCommittee;
    uint256 public sentinelCount;

    struct LogicAlert {
        uint256 id;
        string method;       // axioms, reductio, dependency chains, proof by cases
        string status;       // rigorous, drift, unlawful
        string restriction;  // no fabrication, no unlawful teaching
        string resolution;   // cleanse, align, purge
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => LogicAlert) public alerts;

    event LogicFlagged(uint256 indexed id, string method, string status, string restriction, string resolution, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight flags logical rigor drift
    function flagLogic(string calldata method, string calldata status, string calldata restriction, string calldata resolution, string calldata notes) external onlyOversight {
        sentinelCount++;
        alerts[sentinelCount] = LogicAlert({
            id: sentinelCount,
            method: method,
            status: status,
            restriction: restriction,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit LogicFlagged(sentinelCount, method, status, restriction, resolution, notes);
    }

    /// @notice Citizens can view logic alerts
    function viewLogic(uint256 id) external view returns (LogicAlert memory) {
        return alerts[id];
    }
}
