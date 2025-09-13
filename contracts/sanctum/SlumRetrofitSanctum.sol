// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SlumRetrofitSanctum {
    enum RetrofitType { DrainageUpgrade, RoofReinforcement, Fireproofing, AccessibilityRamp }
    enum RiskZone { Flood, Earthquake, Fire, Landslide }

    struct RetrofitBlessing {
        uint256 id;
        RetrofitType retrofitType;
        RiskZone riskZone;
        string barangayTag;
        uint256 impactPHP;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => RetrofitBlessing) public retrofitRegistry;
    uint256 public retrofitCount;

    event BlessingLogged(uint256 id, RetrofitType retrofitType, RiskZone riskZone);
    event ImpactUpdated(uint256 id, uint256 newImpactPHP);

    function logBlessing(
        RetrofitType retrofitType,
        RiskZone riskZone,
        string memory barangayTag,
        uint256 impactPHP,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        retrofitRegistry[retrofitCount] = RetrofitBlessing(
            retrofitCount,
            retrofitType,
            riskZone,
            barangayTag,
            impactPHP,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(retrofitCount, retrofitType, riskZone);
        retrofitCount++;
    }

    function updateImpact(uint256 id, uint256 newImpactPHP) public {
        require(id < retrofitCount, "Invalid blessing ID");
        retrofitRegistry[id].impactPHP = newImpactPHP;
        emit ImpactUpdated(id, newImpactPHP);
    }

    function getBlessing(uint256 id) public view returns (RetrofitBlessing memory) {
        return retrofitRegistry[id];
    }
}
