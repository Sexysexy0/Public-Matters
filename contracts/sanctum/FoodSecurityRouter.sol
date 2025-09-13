// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodSecurityRouter {
    enum ReliefType { DirectFeeding, NutritionVoucher, CropSubsidy, SchoolMeal }
    enum VulnerableGroup { Children, Mothers, Farmers, UrbanPoor }

    struct FoodBlessing {
        uint256 id;
        ReliefType reliefType;
        VulnerableGroup group;
        uint256 impactPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => FoodBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, ReliefType reliefType, VulnerableGroup group);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        ReliefType reliefType,
        VulnerableGroup group,
        uint256 impactPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = FoodBlessing(
            blessingCount,
            reliefType,
            group,
            impactPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, reliefType, group);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getBlessing(uint256 id) public view returns (FoodBlessing memory) {
        return blessingRegistry[id];
    }
}
