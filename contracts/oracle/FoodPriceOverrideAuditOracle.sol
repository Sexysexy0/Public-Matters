// SPDX-License-Identifier: FoodPriceOverrideAudit-License
pragma solidity ^0.8.0;

contract FoodPriceOverrideAuditOracle {
    address public steward;

    struct PriceSignal {
        string productID;
        string region;
        bool overrideDetected;
        string overrideType;
        uint256 timestamp;
    }

    PriceSignal[] public signals;

    event PriceOverrideAudited(string productID, string region, bool overrideDetected, string overrideType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditOverride(string memory productID, string memory region, bool overrideDetected, string memory overrideType) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(PriceSignal(productID, region, overrideDetected, overrideType, block.timestamp));
        emit PriceOverrideAudited(productID, region, overrideDetected, overrideType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        PriceSignal memory s = signals[index];
        return (s.productID, s.region, s.overrideDetected, s.overrideType, s.timestamp);
    }
}
