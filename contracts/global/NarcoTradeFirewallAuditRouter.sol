// SPDX-License-Identifier: NarcoTradeFirewallAudit-License
pragma solidity ^0.8.0;

contract NarcoTradeFirewallAuditRouter {
    address public steward;

    struct AuditSignal {
        string originNation;
        string productType;
        bool isThreat;
        string threatLevel;
        bool treatyAligned;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event NarcoTradeAudited(string originNation, string productType, bool isThreat, string threatLevel, bool treatyAligned, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditTrade(string memory originNation, string memory productType, bool isThreat, string memory threatLevel, bool treatyAligned) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(AuditSignal(originNation, productType, isThreat, threatLevel, treatyAligned, block.timestamp));
        emit NarcoTradeAudited(originNation, productType, isThreat, threatLevel, treatyAligned, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, bool, uint256) {
        AuditSignal memory s = signals[index];
        return (s.originNation, s.productType, s.isThreat, s.threatLevel, s.treatyAligned, s.timestamp);
    }
}
