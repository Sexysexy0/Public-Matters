// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RiskBucketOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of risk bucket safeguards
contract RiskBucketOracle {
    address public overseer;
    uint256 public bucketCount;

    struct RiskBucket {
        uint256 id;
        string name; // Core, Satellite, Safety
        uint256 maxAllocation; // percentage allocation cap
        string riskLevel; // Low, Medium, High
        uint256 timestamp;
    }

    mapping(uint256 => RiskBucket) public buckets;

    event BucketLogged(uint256 indexed id, string name, uint256 maxAllocation, string riskLevel);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logBucket(
        string calldata name,
        uint256 maxAllocation,
        string calldata riskLevel
    ) external onlyOverseer {
        bucketCount++;
        buckets[bucketCount] = RiskBucket({
            id: bucketCount,
            name: name,
            maxAllocation: maxAllocation,
            riskLevel: riskLevel,
            timestamp: block.timestamp
        });
        emit BucketLogged(bucketCount, name, maxAllocation, riskLevel);
    }

    function viewBucket(uint256 id) external view returns (RiskBucket memory) {
        return buckets[id];
    }
}
