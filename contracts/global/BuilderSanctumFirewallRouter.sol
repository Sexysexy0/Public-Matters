// SPDX-License-Identifier: BuilderSanctumFirewall-License
pragma solidity ^0.8.0;

contract BuilderSanctumFirewallRouter {
    address public steward;

    struct FirewallSignal {
        string builderID;
        string threatVector;
        string projectScope;
        bool treatyAligned;
        bool sanctumProtected;
        uint256 timestamp;
    }

    FirewallSignal[] public signals;

    event BuilderSanctumFirewallRouted(string builderID, string threatVector, string projectScope, bool treatyAligned, bool sanctumProtected, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeFirewall(string memory builderID, string memory threatVector, string memory projectScope, bool treatyAligned, bool sanctumProtected) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(FirewallSignal(builderID, threatVector, projectScope, treatyAligned, sanctumProtected, block.timestamp));
        emit BuilderSanctumFirewallRouted(builderID, threatVector, projectScope, treatyAligned, sanctumProtected, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        FirewallSignal memory s = signals[index];
        return (s.builderID, s.threatVector, s.projectScope, s.treatyAligned, s.sanctumProtected, s.timestamp);
    }
}
