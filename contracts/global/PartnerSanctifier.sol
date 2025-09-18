// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PartnerSanctifier {
    struct PartnerAudit {
        string partnerName;
        string corridorId;
        string emotionalTag;
        bool blessed;
        uint256 timestamp;
    }

    mapping(bytes32 => PartnerAudit) public audits;
    event PartnerBlessed(string partnerName, string emotionalTag, uint256 timestamp);
    event PartnerFlagged(string partnerName, string emotionalTag, uint256 timestamp);

    function auditPartner(
        string memory partnerName,
        string memory corridorId,
        string memory emotionalTag,
        bool bless
    ) public {
        bytes32 key = keccak256(abi.encodePacked(corridorId));
        audits[key] = PartnerAudit(partnerName, corridorId, emotionalTag, bless, block.timestamp);

        if (bless) {
            emit PartnerBlessed(partnerName, emotionalTag, block.timestamp);
        } else {
            emit PartnerFlagged(partnerName, emotionalTag, block.timestamp);
        }
    }

    function getAudit(string memory corridorId) public view returns (PartnerAudit memory) {
        bytes32 key = keccak256(abi.encodePacked(corridorId));
        return audits[key];
    }
}
