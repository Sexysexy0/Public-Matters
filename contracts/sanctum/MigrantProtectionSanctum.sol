// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MigrantProtectionSanctum {
    enum ProtectionType { LegalAid, Repatriation, WageRecovery, AntiTrafficking }
    enum DeploymentRegion { MiddleEast, AsiaPacific, Europe, Americas }

    struct ProtectionBlessing {
        uint256 id;
        ProtectionType protectionType;
        DeploymentRegion region;
        uint256 impactPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ProtectionBlessing) public protectionRegistry;
    uint256 public protectionCount;

    event BlessingLogged(uint256 id, ProtectionType protectionType, DeploymentRegion region);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        ProtectionType protectionType,
        DeploymentRegion region,
        uint256 impactPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        protectionRegistry[protectionCount] = ProtectionBlessing(
            protectionCount,
            protectionType,
            region,
            impactPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(protectionCount, protectionType, region);
        protectionCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < protectionCount, "Invalid blessing ID");
        protectionRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getBlessing(uint256 id) public view returns (ProtectionBlessing memory) {
        return protectionRegistry[id];
    }
}
