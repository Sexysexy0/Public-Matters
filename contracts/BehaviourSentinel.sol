// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BehaviourSentinel
/// @notice Sentinel safeguard for real-time monitoring of behaviour drift
contract BehaviourSentinel {
    address public oversightCommittee;
    uint256 public sentinelCount;

    struct BehaviourAlert {
        uint256 id;
        string domain;     // e.g. tech, creative, governance
        string drift;      // type of drift: unwanted, corrupted, misaligned
        string resolution; // cleanse, align, purge
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => BehaviourAlert) public alerts;

    event BehaviourFlagged(uint256 indexed id, string domain, string drift, string resolution, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight flags behaviour drift
    function flagBehaviour(string calldata domain, string calldata drift, string calldata resolution, string calldata notes) external onlyOversight {
        sentinelCount++;
        alerts[sentinelCount] = BehaviourAlert({
            id: sentinelCount,
            domain: domain,
            drift: drift,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit BehaviourFlagged(sentinelCount, domain, drift, resolution, notes);
    }

    /// @notice Citizens can view behaviour alerts
    function viewAlert(uint256 id) external view returns (BehaviourAlert memory) {
        return alerts[id];
    }
}
