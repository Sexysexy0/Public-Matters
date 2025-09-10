// SPDX-License-Identifier: ZeroTariffFirewallBlessing-License
pragma solidity ^0.8.0;

contract ZeroTariffFirewallBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string partnerNation;
        string productType;
        bool blessingConfirmed;
        bool tariffExempt;
        bool firewallCleared;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event FirewallBlessingRouted(string partnerNation, string productType, bool blessingConfirmed, bool tariffExempt, bool firewallCleared, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory partnerNation, string memory productType, bool blessingConfirmed, bool tariffExempt, bool firewallCleared) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(partnerNation, productType, blessingConfirmed, tariffExempt, firewallCleared, block.timestamp));
        emit FirewallBlessingRouted(partnerNation, productType, blessingConfirmed, tariffExempt, firewallCleared, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.partnerNation, s.productType, s.blessingConfirmed, s.tariffExempt, s.firewallCleared, s.timestamp);
    }
}
