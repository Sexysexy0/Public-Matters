// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AllocationOracle
/// @notice Covenant contract to safeguard portfolios through systemic anchoring of allocation safeguards
contract AllocationOracle {
    address public overseer;
    uint256 public allocationCount;

    struct AllocationRule {
        uint256 id;
        string bucket; // Core, Satellite, Safety
        uint256 targetPercentage; // target allocation
        uint256 toleranceBand; // allowable deviation
        uint256 timestamp;
    }

    mapping(uint256 => AllocationRule) public allocations;

    event AllocationLogged(uint256 indexed id, string bucket, uint256 targetPercentage, uint256 toleranceBand);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logAllocation(
        string calldata bucket,
        uint256 targetPercentage,
        uint256 toleranceBand
    ) external onlyOverseer {
        allocationCount++;
        allocations[allocationCount] = AllocationRule({
            id: allocationCount,
            bucket: bucket,
            targetPercentage: targetPercentage,
            toleranceBand: toleranceBand,
            timestamp: block.timestamp
        });
        emit AllocationLogged(allocationCount, bucket, targetPercentage, toleranceBand);
    }

    function viewAllocation(uint256 id) external view returns (AllocationRule memory) {
        return allocations[id];
    }
}
