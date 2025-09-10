// SPDX-License-Identifier: InvestorSanctumProtection-License
pragma solidity ^0.8.0;

contract InvestorSanctumProtectionRouter {
    address public steward;

    struct ProtectionSignal {
        string investorID;
        string threatVector;
        bool treatyAligned;
        bool firewallCleared;
        bool restorationActivated;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event InvestorSanctumProtectionRouted(string investorID, string threatVector, bool treatyAligned, bool firewallCleared, bool restorationActivated, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeProtection(string memory investorID, string memory threatVector, bool treatyAligned, bool firewallCleared, bool restorationActivated) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ProtectionSignal(investorID, threatVector, treatyAligned, firewallCleared, restorationActivated, block.timestamp));
        emit InvestorSanctumProtectionRouted(investorID, threatVector, treatyAligned, firewallCleared, restorationActivated, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, bool, bool, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.investorID, s.threatVector, s.treatyAligned, s.firewallCleared, s.restorationActivated, s.timestamp);
    }
}
