// SPDX-License-Identifier: GlobalHealthFirewallBlessing-License
pragma solidity ^0.8.0;

contract GlobalHealthFirewallBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string region;
        string vaccineType;
        string threatVector;
        bool firewallCleared;
        bool treatyAligned;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event HealthFirewallBlessingRouted(string region, string vaccineType, string threatVector, bool firewallCleared, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory region, string memory vaccineType, string memory threatVector, bool firewallCleared, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(region, vaccineType, threatVector, firewallCleared, treatyAligned, block.timestamp));
        emit HealthFirewallBlessingRouted(region, vaccineType, threatVector, firewallCleared, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.threatVector, s.firewallCleared, s.treatyAligned, s.timestamp);
    }
}
