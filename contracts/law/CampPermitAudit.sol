// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract CampPermitAudit {
    struct Camp {
        address steward;
        uint plantCount;
        bool fdaApproved;
        uint taxRate;
        string auditHash;
    }

    mapping(address => Camp) public camps;

    event CampRegistered(address steward, uint plantCount, uint taxRate);

    function registerCamp(uint _plantCount, string memory _auditHash) public {
        require(_plantCount > 3, "Use Homegrow Registry");
        uint _taxRate = _plantCount * 5; // 5 tokens per plant
        camps[msg.sender] = Camp(msg.sender, _plantCount, false, _taxRate, _auditHash);
        emit CampRegistered(msg.sender, _plantCount, _taxRate);
    }

    function auditCamp(address _steward) public view returns (Camp memory) {
        return camps[_steward];
    }
}
