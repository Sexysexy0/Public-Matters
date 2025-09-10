// SPDX-License-Identifier: TreatyEnergyFirewall-License
pragma solidity ^0.8.0;

contract TreatyEnergyFirewallRouter {
    address public steward;

    struct FirewallSignal {
        string corridorID;
        string energyType;
        string threatVector;
        bool firewallCleared;
        bool treatyAligned;
        uint256 timestamp;
    }

    FirewallSignal[] public signals;

    event EnergyFirewallRouted(string corridorID, string energyType, string threatVector, bool firewallCleared, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeFirewall(string memory corridorID, string memory energyType, string memory threatVector, bool firewallCleared, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(FirewallSignal(corridorID, energyType, threatVector, firewallCleared, treatyAligned, block.timestamp));
        emit EnergyFirewallRouted(corridorID, energyType, threatVector, firewallCleared, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        FirewallSignal memory s = signals[index];
        return (s.corridorID, s.energyType, s.threatVector, s.firewallCleared, s.treatyAligned, s.timestamp);
    }
}
