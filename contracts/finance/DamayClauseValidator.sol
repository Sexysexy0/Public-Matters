// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.19;

/// @title DamayClauseValidator
/// @notice Validates NEP fund allocations with damay clause logic

contract DamayClauseValidator {
    struct Allocation {
        address region;
        uint256 amount;
        bool damayActivated;
        string[] affectedRegions;
    }

    Allocation[] public allocations;

    event DamayValidated(address indexed region, bool damayActivated, string[] affectedRegions);

    function validateDamay(
        address region,
        uint256 amount,
        string[] memory affected
    ) external {
        bool activate = affected.length > 0;
        allocations.push(Allocation(region, amount, activate, affected));
        emit DamayValidated(region, activate, affected);
    }

    function getLatestAllocation() external view returns (Allocation memory) {
        return allocations[allocations.length - 1];
    }
}
