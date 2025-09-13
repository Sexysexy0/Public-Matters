// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UtilitySubsidyRouter {
    enum UtilityType { Electricity, Water, Internet, Heating }
    enum ReliefTier { Basic, Moderate, Full }

    struct SubsidyBlessing {
        uint256 id;
        UtilityType utilityType;
        ReliefTier reliefTier;
        uint256 impactUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => SubsidyBlessing) public subsidyRegistry;
    uint256 public subsidyCount;

    event SubsidyLogged(uint256 id, UtilityType utilityType, ReliefTier reliefTier);
    event ImpactUpdated(uint256 id, uint256 newImpactUSD);

    function logSubsidy(
        UtilityType utilityType,
        ReliefTier reliefTier,
        uint256 impactUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        subsidyRegistry[subsidyCount] = SubsidyBlessing(
            subsidyCount,
            utilityType,
            reliefTier,
            impactUSD,
            clauseReference,
            timestamp
        );
        emit SubsidyLogged(subsidyCount, utilityType, reliefTier);
        subsidyCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactUSD) public {
        require(id < subsidyCount, "Invalid subsidy ID");
        subsidyRegistry[id].impactUSD = newImpactUSD;
        emit ImpactUpdated(id, newImpactUSD);
    }

    function getSubsidy(uint256 id) public view returns (SubsidyBlessing memory) {
        return subsidyRegistry[id];
    }
}
