// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScrollchainFinale {
    enum LegendType { Steward, Artifact, Treaty, Sanctum }
    enum ClosureTier { Local, Global, Eternal }

    struct FinaleBlessing {
        uint256 id;
        LegendType legendType;
        ClosureTier closureTier;
        string legendTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => FinaleBlessing) public finaleRegistry;
    uint256 public finaleCount;

    event BlessingLogged(uint256 id, LegendType legendType, ClosureTier closureTier);
    event TierUpdated(uint256 id, ClosureTier newTier);

    function logFinale(
        LegendType legendType,
        ClosureTier closureTier,
        string memory legendTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        finaleRegistry[finaleCount] = FinaleBlessing(
            finaleCount,
            legendType,
            closureTier,
            legendTag,
            clauseReference,
            timestamp
        );
        emit BlessingLogged(finaleCount, legendType, closureTier);
        finaleCount++;
    }

    function updateTier(uint256 id, ClosureTier newTier) public {
        require(id < finaleCount, "Invalid blessing ID");
        finaleRegistry[id].closureTier = newTier;
        emit TierUpdated(id, newTier);
    }

    function getFinaleBlessing(uint256 id) public view returns (FinaleBlessing memory) {
        return finaleRegistry[id];
    }
}
