// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AntiMonopolySignalRouter {
    enum Sector { Streaming, Cable, News, Children, IP }
    enum DominanceLevel { Low, Moderate, High, Critical }

    struct DominanceSignal {
        uint256 id;
        Sector sector;
        string entityName;
        uint256 marketShare;
        DominanceLevel level;
        string auditNote;
        uint256 timestamp;
    }

    mapping(uint256 => DominanceSignal) public signalRegistry;
    uint256 public signalCount;

    event SignalLogged(uint256 id, string entityName, DominanceLevel level);

    function logSignal(
        Sector sector,
        string memory entityName,
        uint256 marketShare,
        DominanceLevel level,
        string memory auditNote,
        uint256 timestamp
    ) public {
        signalRegistry[signalCount] = DominanceSignal(
            signalCount,
            sector,
            entityName,
            marketShare,
            level,
            auditNote,
            timestamp
        );
        emit SignalLogged(signalCount, entityName, level);
        signalCount++;
    }

    function getSignal(uint256 id) public view returns (DominanceSignal memory) {
        return signalRegistry[id];
    }
}
