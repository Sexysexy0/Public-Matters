// SPDX-License-Identifier: TariffFirewallBlessing-License
pragma solidity ^0.8.0;

contract TariffFirewallBlessingRouter {
    address public steward;

    struct FirewallBlessing {
        string productClass;
        string threatVector;
        bool treatyAligned;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    FirewallBlessing[] public blessings;

    event FirewallBlessingRouted(string productClass, string threatVector, bool treatyAligned, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory productClass, string memory threatVector, bool treatyAligned, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        blessings.push(FirewallBlessing(productClass, threatVector, treatyAligned, blessingConfirmed, block.timestamp));
        emit FirewallBlessingRouted(productClass, threatVector, treatyAligned, blessingConfirmed, block.timestamp);
    }

    function getBlessing(uint index) public view returns (string memory, string memory, bool, bool, uint256) {
        FirewallBlessing memory b = blessings[index];
        return (b.productClass, b.threatVector, b.treatyAligned, b.blessingConfirmed, b.timestamp);
    }
}
