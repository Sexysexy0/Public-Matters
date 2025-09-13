// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SanctumBroadcastNode {
    enum AlertType { Mythic, Civic, Treaty, Emergency }
    enum BroadcastTier { Local, Regional, Global }

    struct BroadcastBlessing {
        uint256 id;
        AlertType alertType;
        BroadcastTier tier;
        string originTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => BroadcastBlessing) public broadcastRegistry;
    uint256 public broadcastCount;

    event BroadcastLogged(uint256 id, AlertType alertType, BroadcastTier tier);
    event TierUpdated(uint256 id, BroadcastTier newTier);

    function logBroadcast(
        AlertType alertType,
        BroadcastTier tier,
        string memory originTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        broadcastRegistry[broadcastCount] = BroadcastBlessing(
            broadcastCount,
            alertType,
            tier,
            originTag,
            clauseReference,
            timestamp
        );
        emit BroadcastLogged(broadcastCount, alertType, tier);
        broadcastCount++;
    }

    function updateTier(uint256 id, BroadcastTier newTier) public {
        require(id < broadcastCount, "Invalid broadcast ID");
        broadcastRegistry[id].tier = newTier;
        emit TierUpdated(id, newTier);
    }

    function getBroadcastBlessing(uint256 id) public view returns (BroadcastBlessing memory) {
        return broadcastRegistry[id];
    }
}
