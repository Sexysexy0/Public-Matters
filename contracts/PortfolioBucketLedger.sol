// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PortfolioBucketLedger
/// @notice Encodes portfolio buckets for structured diversification.
/// @dev Anchors BTC core, majors, high-risk caps, and stablecoin buffer.

contract PortfolioBucketLedger {
    address public overseer;
    uint256 public bucketCount;

    struct Bucket {
        uint256 id;
        string name;        // BTC Core, Majors, High-Risk, Stablecoin Buffer
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Bucket> public buckets;
    event BucketDeclared(uint256 indexed id, string name, string description);

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function declareBucket(string calldata name, string calldata description) external onlyOverseer {
        bucketCount++;
        buckets[bucketCount] = Bucket(bucketCount, name, description, block.timestamp);
        emit BucketDeclared(bucketCount, name, description);
    }
}
