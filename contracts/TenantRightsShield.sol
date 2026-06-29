// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TenantRightsShield
/// @notice Covenant contract to safeguard communities through systemic anchoring of tenant rights and renter protection
contract TenantRightsShield {
    address public overseer;
    uint256 public tenantCount;

    struct TenantEntry {
        uint256 id;
        string tenant;
        string landlord;
        string principle;
        uint256 timestamp;
    }

    mapping(uint256 => TenantEntry) public tenants;

    event TenantLogged(uint256 indexed id, string tenant, string landlord);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logTenant(
        string calldata tenant,
        string calldata landlord,
        string calldata principle
    ) external onlyOverseer {
        tenantCount++;
        tenants[tenantCount] = TenantEntry({
            id: tenantCount,
            tenant: tenant,
            landlord: landlord,
            principle: principle,
            timestamp: block.timestamp
        });
        emit TenantLogged(tenantCount, tenant, landlord);
    }

    function viewTenant(uint256 id) external view returns (TenantEntry memory) {
        return tenants[id];
    }
}
