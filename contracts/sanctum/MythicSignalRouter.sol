// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MythicSignalRouter {
    enum SignalType { Spike, Omen, Anomaly, PatternLoop }
    enum DetectionTier { Local, Regional, Planetary }

    struct SignalBlessing {
        uint256 id;
        SignalType signalType;
        DetectionTier detectionTier;
        string originTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => SignalBlessing) public signalRegistry;
    uint256 public signalCount;

    event SignalLogged(uint256 id, SignalType signalType, DetectionTier detectionTier);
    event TierUpdated(uint256 id, DetectionTier newTier);

    function logSignal(
        SignalType signalType,
        DetectionTier detectionTier,
        string memory originTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        signalRegistry[signalCount] = SignalBlessing(
            signalCount,
            signalType,
            detectionTier,
            originTag,
            clauseReference,
            timestamp
        );
        emit SignalLogged(signalCount, signalType, detectionTier);
        signalCount++;
    }

    function updateTier(uint256 id, DetectionTier newTier) public {
        require(id < signalCount, "Invalid signal ID");
        signalRegistry[id].detectionTier = newTier;
        emit TierUpdated(id, newTier);
    }

    function getSignalBlessing(uint256 id) public view returns (SignalBlessing memory) {
        return signalRegistry[id];
    }
}
