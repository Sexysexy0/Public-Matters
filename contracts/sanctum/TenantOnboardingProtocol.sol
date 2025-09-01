// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TenantOnboardingProtocol {
    struct Tenant {
        string tenantID;
        string fullName;
        string barangay;
        string unitID;
        string emotionalTag; // "DamayClause", "SanctumGlow", "AuditGlow"
        uint256 onboardingTimestamp;
        bool isBlessed;
    }

    mapping(string => Tenant) public tenants;

    event TenantOnboarded(string tenantID, string unitID, string emotionalTag, uint256 onboardingTimestamp);

    function onboardTenant(
        string memory _tenantID,
        string memory _fullName,
        string memory _barangay,
        string memory _unitID,
        string memory _emotionalTag
    ) public {
        tenants[_tenantID] = Tenant({
            tenantID: _tenantID,
            fullName: _fullName,
            barangay: _barangay,
            unitID: _unitID,
            emotionalTag: _emotionalTag,
            onboardingTimestamp: block.timestamp,
            isBlessed: true
        });

        emit TenantOnboarded(_tenantID, _unitID, _emotionalTag, block.timestamp);
    }

    function getTenantDetails(string memory _tenantID) public view returns (Tenant memory) {
        return tenants[_tenantID];
    }

    function markUnblessed(string memory _tenantID) public {
        tenants[_tenantID].isBlessed = false;
    }
}
