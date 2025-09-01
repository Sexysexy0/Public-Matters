// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FamilyHousingAssistance {
    struct AssistanceGrant {
        string familyID;
        string region;
        uint256 amount; // 150000, 200000, 300000
        string emotionalTag; // "DamayClause", "RemoteGlow", "AuditGlow"
        bool isApproved;
        uint256 timestamp;
    }

    AssistanceGrant[] public grants;

    function approveGrant(string memory familyID, string memory region, uint256 amount, string memory emotionalTag) public {
        require(amount >= 150000 && amount <= 300000, "Invalid amount tier");
        grants.push(AssistanceGrant(familyID, region, amount, emotionalTag, true, block.timestamp));
    }

    function totalGrants() public view returns (uint256) {
        return grants.length;
    }
}
