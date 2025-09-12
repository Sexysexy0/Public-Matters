// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegulatoryMomentumRouter {
    enum FilingStatus { Pending, Approved, Delayed, Rejected }
    enum AssetType { BTC, ETH, DOGE, XRP, SOL, Other }

    struct ETFSignal {
        uint256 id;
        AssetType assetType;
        string provider;
        FilingStatus status;
        uint256 inflowUSD;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ETFSignal) public etfRegistry;
    uint256 public etfCount;

    event ETFLogged(uint256 id, AssetType assetType, FilingStatus status);
    event StatusUpdated(uint256 id, FilingStatus newStatus);

    function logETF(
        AssetType assetType,
        string memory provider,
        FilingStatus status,
        uint256 inflowUSD,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        etfRegistry[etfCount] = ETFSignal(
            etfCount,
            assetType,
            provider,
            status,
            inflowUSD,
            clauseReference,
            timestamp
        );
        emit ETFLogged(etfCount, assetType, status);
        etfCount++;
    }

    function updateFilingStatus(uint256 id, FilingStatus newStatus) public {
        require(id < etfCount, "Invalid ETF ID");
        etfRegistry[id].status = newStatus;
        emit StatusUpdated(id, newStatus);
    }

    function getETF(uint256 id) public view returns (ETFSignal memory) {
        return etfRegistry[id];
    }
}
