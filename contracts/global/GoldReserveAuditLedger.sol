// SPDX-License-Identifier: CollateralSanctum
pragma solidity ^0.8.19;

contract GoldReserveAuditLedger {
    struct ReserveAudit {
        string country;
        uint256 goldReservesTons;
        uint256 externalDebtUSD;
        bool collateralized;
        string auditNote;
        bool flagged;
    }

    mapping(bytes32 => ReserveAudit) public audits;

    event AuditTagged(string country, uint256 goldReservesTons, uint256 externalDebtUSD);
    event CollateralFlagged(string country, string auditNote);

    function tagAudit(string memory country, uint256 goldReservesTons, uint256 externalDebtUSD, string memory auditNote) public {
        bytes32 auditId = keccak256(abi.encodePacked(country, block.timestamp));
        bool isCollateralized = goldReservesTons * 65000 >= externalDebtUSD; // Approx gold price per ton in USD
        audits[auditId] = ReserveAudit(country, goldReservesTons, externalDebtUSD, isCollateralized, auditNote, false);
        emit AuditTagged(country, goldReservesTons, externalDebtUSD);
    }

    function flagCollateralRisk(string memory country, string memory auditNote) public {
        bytes32 auditId = keccak256(abi.encodePacked(country, block.timestamp));
        audits[auditId].flagged = true;
        audits[auditId].auditNote = auditNote;
        emit CollateralFlagged(country, auditNote);
    }

    function getAuditStatus(string memory country) public view returns (ReserveAudit memory) {
        bytes32 auditId = keccak256(abi.encodePacked(country, block.timestamp));
        return audits[auditId];
    }
}
