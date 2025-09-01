// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SuccessionAuditLedger {
    struct Succession {
        string originalTenantID;
        string successorID;
        string unitID;
        string emotionalTag; // Inherited: "DamayClause", "SanctumGlow", "AuditGlow"
        uint256 successionTimestamp;
        bool isVerified;
    }

    mapping(string => Succession) public successions;

    event SuccessionLogged(string originalTenantID, string successorID, string emotionalTag, uint256 successionTimestamp);

    function logSuccession(
        string memory _originalTenantID,
        string memory _successorID,
        string memory _unitID,
        string memory _emotionalTag
    ) public {
        successions[_successorID] = Succession({
            originalTenantID: _originalTenantID,
            successorID: _successorID,
            unitID: _unitID,
            emotionalTag: _emotionalTag,
            successionTimestamp: block.timestamp,
            isVerified: true
        });

        emit SuccessionLogged(_originalTenantID, _successorID, _emotionalTag, block.timestamp);
    }

    function getSuccessionDetails(string memory _successorID) public view returns (Succession memory) {
        return successions[_successorID];
    }
}
