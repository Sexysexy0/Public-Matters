// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MedianClassProtectionDeck {
    enum SupportType { TaxRelief, HousingSubsidy, WageBoost, DebtShield }
    enum Region { Urban, Suburban, Rural }

    struct ProtectionBlessing {
        uint256 id;
        Region region;
        SupportType supportType;
        uint256 impactUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ProtectionBlessing) public blessingRegistry;
    uint256 public blessingCount;

    event BlessingLogged(uint256 id, Region region, SupportType supportType);
    event ImpactUpdated(uint256 id, uint256 newImpactUSD);

    function logBlessing(
        Region region,
        SupportType supportType,
        uint256 impactUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        blessingRegistry[blessingCount] = ProtectionBlessing(
            blessingCount,
            region,
            supportType,
            impactUSD,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(blessingCount, region, supportType);
        blessingCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactUSD) public {
        require(id < blessingCount, "Invalid blessing ID");
        blessingRegistry[id].impactUSD = newImpactUSD;
        emit ImpactUpdated(id, newImpactUSD);
    }

    function getBlessing(uint256 id) public view returns (ProtectionBlessing memory) {
        return blessingRegistry[id];
    }
}
