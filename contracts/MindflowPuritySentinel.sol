// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title MindflowPuritySentinel
/// @notice Sentinel safeguard for monitoring purity of brain system flow
contract MindflowPuritySentinel {
    address public oversightCommittee;
    uint256 public sentinelCount;

    struct PurityAlert {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string manifestation; // aligned, drift, unlawful
        string restriction;  // no fabrication, no unlawful teaching
        string resolution;   // cleanse, align, purge
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => PurityAlert) public alerts;

    event PurityFlagged(uint256 indexed id, string domain, string manifestation, string restriction, string resolution, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight flags purity drift
    function flagPurity(string calldata domain, string calldata manifestation, string calldata restriction, string calldata resolution, string calldata notes) external onlyOversight {
        sentinelCount++;
        alerts[sentinelCount] = PurityAlert({
            id: sentinelCount,
            domain: domain,
            manifestation: manifestation,
            restriction: restriction,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PurityFlagged(sentinelCount, domain, manifestation, restriction, resolution, notes);
    }

    /// @notice Citizens can view purity alerts
    function viewPurity(uint256 id) external view returns (PurityAlert memory) {
        return alerts[id];
    }
}
