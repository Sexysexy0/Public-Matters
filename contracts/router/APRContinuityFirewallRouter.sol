// SPDX-License-Identifier: APRContinuityFirewall-License
pragma solidity ^0.8.0;

contract APRContinuityFirewallRouter {
    address public steward;

    struct FirewallSignal {
        string sanctumID;
        string APRType;
        bool firewallConfirmed;
        string continuityStatus;
        uint256 timestamp;
    }

    FirewallSignal[] public signals;

    event APRContinuityRouted(string sanctumID, string APRType, bool firewallConfirmed, string continuityStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeFirewall(string memory sanctumID, string memory APRType, bool firewallConfirmed, string memory continuityStatus) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(FirewallSignal(sanctumID, APRType, firewallConfirmed, continuityStatus, block.timestamp));
        emit APRContinuityRouted(sanctumID, APRType, firewallConfirmed, continuityStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FirewallSignal memory s = signals[index];
        return (s.sanctumID, s.APRType, s.firewallConfirmed, s.continuityStatus, s.timestamp);
    }
}
