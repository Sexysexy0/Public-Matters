// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClimateJusticeRouter {
    enum HazardType { Flood, Drought, Heatwave, Typhoon }
    enum ReliefType { RelocationGrant, LegalShielding, InfrastructureRetrofit, LivelihoodRecovery }

    struct ClimateBlessing {
        uint256 id;
        HazardType hazardType;
        ReliefType reliefType;
        string regionTag;
        uint256 impactPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ClimateBlessing> public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, HazardType hazardType, ReliefType reliefType);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        HazardType hazardType,
        ReliefType reliefType,
        string memory regionTag,
        uint256 impactPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = ClimateBlessing(
            blessingCount,
            hazardType,
            reliefType,
            regionTag,
            impactPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, hazardType, reliefType);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getBlessing(uint256 id) public view returns (ClimateBlessing memory) {
        return blessingRegistry[id];
    }
}
