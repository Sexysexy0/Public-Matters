// SPDX-License-Identifier: TreatyTradeAudit-License
pragma solidity ^0.8.0;

contract TreatyTradeAuditRouter {
    address public steward;

    struct AuditSignal {
        string corridorID;
        string productType;
        string originNation;
        string destinationNation;
        bool auditConfirmed;
        string complianceStatus;
        uint256 timestamp;
    }

    AuditSignal[] public signals;

    event TreatyTradeAudited(string corridorID, string productType, string originNation, string destinationNation, bool auditConfirmed, string complianceStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function auditTrade(string memory corridorID, string memory productType, string memory originNation, string memory destinationNation, bool auditConfirmed, string memory complianceStatus) public {
        require(msg.sender == steward, "Only steward can audit");
        signals.push(AuditSignal(corridorID, productType, originNation, destinationNation, auditConfirmed, complianceStatus, block.timestamp));
        emit TreatyTradeAudited(corridorID, productType, originNation, destinationNation, auditConfirmed, complianceStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, string memory, bool, string memory, uint256) {
        AuditSignal memory s = signals[index];
        return (s.corridorID, s.productType, s.originNation, s.destinationNation, s.auditConfirmed, s.complianceStatus, s.timestamp);
    }
}
