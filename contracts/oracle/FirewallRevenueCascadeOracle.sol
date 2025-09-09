// SPDX-License-Identifier: FirewallRevenueCascade-License
pragma solidity ^0.8.0;

contract FirewallRevenueCascadeOracle {
    address public steward;

    struct RevenueCascade {
        string actor;
        uint256 revenueShare;
        string reformTriggered;
        string rippleZone;
        uint256 timestamp;
    }

    RevenueCascade[] public cascades;

    event RevenueCascadeEmitted(string actor, uint share, string reform, string zone, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCascade(string memory actor, uint256 revenueShare, string memory reformTriggered, string memory rippleZone) public {
        require(msg.sender == steward, "Only steward can emit");
        cascades.push(RevenueCascade(actor, revenueShare, reformTriggered, rippleZone, block.timestamp));
        emit RevenueCascadeEmitted(actor, revenueShare, reformTriggered, rippleZone, block.timestamp);
    }

    function getCascade(uint index) public view returns (string memory, uint256, string memory, string memory, uint256) {
        RevenueCascade memory c = cascades[index];
        return (c.actor, c.revenueShare, c.reformTriggered, c.rippleZone, c.timestamp);
    }
}
