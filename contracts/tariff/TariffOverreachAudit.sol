// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TariffOverreachAudit {
    struct TariffAct {
        string product;
        uint256 imposedDate;
        string emergencyClaim;
        bool isLegal;
        string auditNotes;
    }

    TariffAct[] public auditLog;

    function logTariff(
        string memory product,
        uint256 imposedDate,
        string memory emergencyClaim,
        bool isLegal,
        string memory auditNotes
    ) public {
        auditLog.push(TariffAct(product, imposedDate, emergencyClaim, isLegal, auditNotes));
    }

    function getAuditCount() public view returns (uint256) {
        return auditLog.length;
    }

    function getTariff(uint256 index) public view returns (TariffAct memory) {
        require(index < auditLog.length, "Invalid index");
        return auditLog[index];
    }
}
