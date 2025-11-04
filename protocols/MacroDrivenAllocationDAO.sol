// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MacroDrivenAllocationDAO {
    address public steward;

    struct AllocationEntry {
        string assetName;
        string macroDriver;
        string allocationStrategy;
        string emotionalTag;
    }

    AllocationEntry[] public registry;

    event MacroAllocationTagged(string assetName, string macroDriver, string allocationStrategy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagAllocation(
        string memory assetName,
        string memory macroDriver,
        string memory allocationStrategy,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(AllocationEntry(assetName, macroDriver, allocationStrategy, emotionalTag));
        emit MacroAllocationTagged(assetName, macroDriver, allocationStrategy, emotionalTag);
    }
}
