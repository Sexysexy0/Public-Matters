// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FloodControlRedemptionDAO {
    address public steward;

    struct RedemptionEntry {
        string projectLocation;
        string redemptionMechanism;
        string communitySignal;
        string emotionalTag;
    }

    RedemptionEntry[] public registry;

    event FloodControlRedeemed(string projectLocation, string redemptionMechanism, string communitySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function redeemFloodControl(
        string memory projectLocation,
        string memory redemptionMechanism,
        string memory communitySignal,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(RedemptionEntry(projectLocation, redemptionMechanism, communitySignal, emotionalTag));
        emit FloodControlRedeemed(projectLocation, redemptionMechanism, communitySignal, emotionalTag);
    }
}
