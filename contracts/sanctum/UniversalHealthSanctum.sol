// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UniversalHealthSanctum {
    enum CareType { Preventive, Curative, Palliative, DisabilitySupport }
    enum CoverageTier { Basic, Enhanced, Full }

    struct HealthBlessing {
        uint256 id;
        CareType careType;
        CoverageTier coverageTier;
        string regionTag;
        uint256 impactPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => HealthBlessing) public healthRegistry;
    uint256 public healthCount;

    event BlessingLogged(uint256 id, CareType careType, CoverageTier coverageTier);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        CareType careType,
        CoverageTier coverageTier,
        string memory regionTag,
        uint256 impactPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        healthRegistry[healthCount] = HealthBlessing(
            healthCount,
            careType,
            coverageTier,
            regionTag,
            impactPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(healthCount, careType, coverageTier);
        healthCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < healthCount, "Invalid blessing ID");
        healthRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getHealthBlessing(uint256 id) public view returns (HealthBlessing memory) {
        return healthRegistry[id];
    }
}
