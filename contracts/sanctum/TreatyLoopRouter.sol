// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TreatyLoopRouter {
    enum LoopType { Civic, Mythic, Diplomatic, Ancestral }
    enum SyncTier { Local, Regional, Global }

    struct LoopBlessing {
        uint256 id;
        LoopType loopType;
        SyncTier syncTier;
        string stewardTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => LoopBlessing) public loopRegistry;
    uint256 public loopCount;

    event LoopLogged(uint256 id, LoopType loopType, SyncTier syncTier);
    event TierUpdated(uint256 id, SyncTier newSyncTier);

    function logLoop(
        LoopType loopType,
        SyncTier syncTier,
        string memory stewardTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        loopRegistry[loopCount] = LoopBlessing(
            loopCount,
            loopType,
            syncTier,
            stewardTag,
            clauseReference,
            timestamp
        );
        emit LoopLogged(loopCount, loopType, syncTier);
        loopCount++;
    }

    function updateTier(uint256 id, SyncTier newSyncTier) public {
        require(id < loopCount, "Invalid loop ID");
        loopRegistry[id].syncTier = newSyncTier;
        emit TierUpdated(id, newSyncTier);
    }

    function getLoopBlessing(uint256 id) public view returns (LoopBlessing memory) {
        return loopRegistry[id];
    }
}
