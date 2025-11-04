// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GenerationalWealthAllocationTreaty {
    address public steward;

    struct AllocationClause {
        string capitalSource;
        string assetType;
        string allocationStrategy;
        string emotionalTag;
    }

    AllocationClause[] public treatyLog;

    event GenerationalWealthTagged(string capitalSource, string assetType, string allocationStrategy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagWealthAllocation(
        string memory capitalSource,
        string memory assetType,
        string memory allocationStrategy,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(AllocationClause(capitalSource, assetType, allocationStrategy, emotionalTag));
        emit GenerationalWealthTagged(capitalSource, assetType, allocationStrategy, emotionalTag);
    }
}
