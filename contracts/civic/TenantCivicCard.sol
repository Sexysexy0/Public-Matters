// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TenantCivicCard {
    struct CivicCard {
        string tenantID;
        string fullName;
        string barangay;
        string unitID;
        string emotionalTag; // "DamayClause", "SanctumGlow", "AuditGlow"
        uint256 issuedTimestamp;
        bool isValid;
    }

    mapping(string => CivicCard) public civicCards;

    event CivicCardIssued(string tenantID, string emotionalTag, uint256 issuedTimestamp);

    function issueCard(
        string memory _tenantID,
        string memory _fullName,
        string memory _barangay,
        string memory _unitID,
        string memory _emotionalTag
    ) public {
        civicCards[_tenantID] = CivicCard({
            tenantID: _tenantID,
            fullName: _fullName,
            barangay: _barangay,
            unitID: _unitID,
            emotionalTag: _emotionalTag,
            issuedTimestamp: block.timestamp,
            isValid: true
        });

        emit CivicCardIssued(_tenantID, _emotionalTag, block.timestamp);
    }

    function revokeCard(string memory _tenantID) public {
        civicCards[_tenantID].isValid = false;
    }

    function getCardDetails(string memory _tenantID) public view returns (CivicCard memory) {
        return civicCards[_tenantID];
    }
}
