// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BarangaySanctumRegistry {
    struct Sanctum {
        string barangay;
        string buildType; // "Prefab", "Modular", "Vertical"
        bool isBlessed;
        string emotionalTag; // "SanctumGlow", "AuditGlow"
        uint256 timestamp;
    }

    Sanctum[] public sanctums;

    function registerSanctum(string memory barangay, string memory buildType, bool isBlessed, string memory emotionalTag) public {
        sanctums.push(Sanctum(barangay, buildType, isBlessed, emotionalTag, block.timestamp));
    }

    function totalSanctums() public view returns (uint256) {
        return sanctums.length;
    }
}
