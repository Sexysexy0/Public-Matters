// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SmartSanctumAlliance {
    struct PartnerOrg {
        string name;
        string specialty; // "Prefab", "Steel", "Vertical Build", etc.
        string emotionalTag; // "DamayClause", "SanctumGlow"
        bool isVerified;
        uint256 timestamp;
    }

    PartnerOrg[] public partners;

    function registerPartner(string memory name, string memory specialty, string memory emotionalTag, bool isVerified) public {
        partners.push(PartnerOrg(name, specialty, emotionalTag, isVerified, block.timestamp));
    }

    function totalPartners() public view returns (uint256) {
        return partners.length;
    }
}
