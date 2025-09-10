// SPDX-License-Identifier: TreatyImmunizationAudit-License
pragma solidity ^0.8.0;

contract TreatyImmunizationAuditRouter {
    address public steward;

    struct AuditSignal {
        string region;
        string vaccineType;
        string equityScore;
        bool firewallCleared;
        bool treatyAligned;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event ImmunizationAuditRouted(string region, string vaccineType, string equityScore, bool firewallCleared, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeAudit(string memory region, string memory vaccineType, string memory equityScore, bool firewallCleared, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(AuditSignal(region, vaccineType, equityScore, firewallCleared, treatyAligned, block.timestamp));
        emit ImmunizationAuditRouted(region, vaccineType, equityScore, firewallCleared, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        AuditSignal memory s = signals[index];
        return (s.region, s.vaccineType, s.equityScore, s.firewallCleared, s.treatyAligned, s.timestamp);
    }
}
