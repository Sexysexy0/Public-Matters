// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitcoinFreedomFirewall {
    enum ThreatLevel { Low, Moderate, High, Critical }
    enum BanType { FullBan, BankingRestriction, MiningBan, ExchangeDelisting }

    struct BanSignal {
        uint256 id;
        string country;
        BanType banType;
        ThreatLevel threatLevel;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => BanSignal) public banRegistry;
    uint256 public banCount;

    event BanLogged(uint256 id, string country, BanType banType, ThreatLevel threatLevel);
    event ThreatLevelUpdated(uint256 id, ThreatLevel newLevel);

    function logBan(
        string memory country,
        BanType banType,
        ThreatLevel threatLevel,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        banRegistry[banCount] = BanSignal(
            banCount,
            country,
            banType,
            threatLevel,
            clauseReference,
            timestamp
        );
        emit BanLogged(banCount, country, banType, threatLevel);
        banCount++;
    }

    function updateThreatLevel(uint256 id, ThreatLevel newLevel) public {
        require(id < banCount, "Invalid ban ID");
        banRegistry[id].threatLevel = newLevel;
        emit ThreatLevelUpdated(id, newLevel);
    }

    function getBanSignal(uint256 id) public view returns (BanSignal memory) {
        return banRegistry[id];
    }
}
