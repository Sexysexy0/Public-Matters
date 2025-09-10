// SPDX-License-Identifier: TreatyEquityFirewall-License
pragma solidity ^0.8.0;

contract TreatyEquityFirewallRouter {
    address public steward;

    struct EquityFirewallSignal {
        string exportType;
        string threatVector;
        string equityScore;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    EquityFirewallSignal[] public signals;

    event EquityFirewallBlessingRouted(string exportType, string threatVector, string equityScore, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory exportType, string memory threatVector, string memory equityScore, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(EquityFirewallSignal(exportType, threatVector, equityScore, blessingConfirmed, block.timestamp));
        emit EquityFirewallBlessingRouted(exportType, threatVector, equityScore, blessingConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        EquityFirewallSignal memory s = signals[index];
        return (s.exportType, s.threatVector, s.equityScore, s.blessingConfirmed, s.timestamp);
    }
}
