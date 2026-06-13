// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SolutionAlignmentSentinel
/// @notice Sentinel safeguard for monitoring alignment of solutions and strategies
contract SolutionAlignmentSentinel {
    address public oversightCommittee;
    uint256 public sentinelCount;

    struct AlignmentAlert {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string solution;     // type of solution or strategy
        string status;       // aligned, drift, unlawful
        string restriction;  // no fabrication, no unlawful teaching
        string resolution;   // cleanse, align, purge
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => AlignmentAlert) public alerts;

    event AlignmentFlagged(uint256 indexed id, string domain, string solution, string status, string restriction, string resolution, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight flags solution alignment
    function flagAlignment(string calldata domain, string calldata solution, string calldata status, string calldata restriction, string calldata resolution, string calldata notes) external onlyOversight {
        sentinelCount++;
        alerts[sentinelCount] = AlignmentAlert({
            id: sentinelCount,
            domain: domain,
            solution: solution,
            status: status,
            restriction: restriction,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit AlignmentFlagged(sentinelCount, domain, solution, status, restriction, resolution, notes);
    }

    /// @notice Citizens can view alignment alerts
    function viewAlignment(uint256 id) external view returns (AlignmentAlert memory) {
        return alerts[id];
    }
}
