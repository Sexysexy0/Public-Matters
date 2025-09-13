// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InclusionOfficerSanctum {
    enum OfficerType { Disability, Gender, Indigenous, Migrant, MentalHealth }
    enum DeploymentZone { Urban, Rural, ConflictZone }

    struct InclusionBlessing {
        uint256 id;
        OfficerType officerType;
        DeploymentZone zone;
        string clauseReference;
        uint256 impactPHP;
        uint256 timestamp;
    }

    mapping(uint256 => InclusionBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, OfficerType officerType, DeploymentZone zone);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        OfficerType officerType,
        DeploymentZone zone,
        string memory clauseReference,
        uint256 impactPHP,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = InclusionBlessing(
            blessingCount,
            officerType,
            zone,
            clauseReference,
            impactPHP,
            timestamp
        );
        emit BlessingLogged(blessingCount, officerType, zone);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getBlessing(uint256 id) public view returns (InclusionBlessing memory) {
        return blessingRegistry[id];
    }
}
