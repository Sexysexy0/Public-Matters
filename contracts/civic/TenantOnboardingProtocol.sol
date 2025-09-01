// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TenantOnboardingProtocol {
    struct Tenant {
        string name;
        string region;
        bool isHomeless;
        bool isVerified;
        string emotionalTag; // "MercyPing", "DamayClause", "AuditGlow"
        uint256 timestamp;
    }

    Tenant[] public tenants;

    function registerTenant(string memory name, string memory region, bool isHomeless, bool isVerified, string memory emotionalTag) public {
        tenants.push(Tenant(name, region, isHomeless, isVerified, emotionalTag, block.timestamp));
    }

    function totalTenants() public view returns (uint256) {
        return tenants.length;
    }
}
