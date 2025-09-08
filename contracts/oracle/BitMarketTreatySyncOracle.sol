// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketTreatySyncOracle {
    address public steward;
    uint public lastSyncTimestamp;

    event TreatySyncTriggered(uint timestamp, string reason);

    constructor() {
        steward = msg.sender;
        lastSyncTimestamp = block.timestamp;
    }

    function detectSyncNeed(string memory reason) public returns (bool) {
        uint currentTime = block.timestamp;
        bool needsSync = currentTime > lastSyncTimestamp + 7 days;
        if (needsSync) {
            lastSyncTimestamp = currentTime;
            emit TreatySyncTriggered(currentTime, reason);
        }
        return needsSync;
    }

    function manualOverride(string memory reason) public {
        require(msg.sender == steward, "Only steward may override");
        lastSyncTimestamp = block.timestamp;
        emit TreatySyncTriggered(block.timestamp, reason);
    }
}
