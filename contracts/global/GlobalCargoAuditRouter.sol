// SPDX-License-Identifier: AuditSanctum
pragma solidity ^0.8.19;

contract GlobalCargoAuditRouter {
    struct CargoAudit {
        string assetType; // e.g., "Medical Supplies", "Grain", "Gold"
        string originCountry;
        string destinationCountry;
        string treatyName;
        string inspectorEntity;
        uint256 quantity;
        bool audited;
        bool compliant;
        string auditNote;
    }

    mapping(bytes32 => CargoAudit) public audits;

    event CargoAuditTagged(string assetType, string originCountry, string destinationCountry, string treatyName);
    event CargoComplianceVerified(string inspectorEntity, string assetType);

    function tagCargoAudit(string memory assetType, string memory originCountry, string memory destinationCountry, string memory treatyName, string memory inspectorEntity, uint256 quantity, string memory auditNote) public {
        bytes32 auditId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, treatyName, block.timestamp));
        audits[auditId] = CargoAudit(assetType, originCountry, destinationCountry, treatyName, inspectorEntity, quantity, false, false, auditNote);
        emit CargoAuditTagged(assetType, originCountry, destinationCountry, treatyName);
    }

    function verifyCargoCompliance(string memory assetType, string memory originCountry, string memory destinationCountry, string memory treatyName, string memory inspectorEntity) public {
        bytes32 auditId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, treatyName, block.timestamp));
        audits[auditId].audited = true;
        audits[auditId].compliant = true;
        emit CargoComplianceVerified(inspectorEntity, assetType);
    }

    function getAuditStatus(string memory assetType, string memory originCountry, string memory destinationCountry, string memory treatyName) public view returns (CargoAudit memory) {
        bytes32 auditId = keccak256(abi.encodePacked(assetType, originCountry, destinationCountry, treatyName, block.timestamp));
        return audits[auditId];
    }
}
