// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MarketLedger: record crypto market swings
contract MarketLedger {
    struct Market {
        uint256 id;
        string asset;       // "BTC", "ETH", "SOL"
        int256 change;      // % change
        uint256 price;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Market) public markets;
    mapping(address => bool) public stewards;

    event MarketLogged(uint256 indexed id, string asset, int256 change, uint256 price);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logMarket(string calldata asset, int256 change, uint256 price) external {
        require(stewards[msg.sender], "Only steward");
        markets[nextId] = Market(nextId, asset, change, price, block.timestamp);
        emit MarketLogged(nextId, asset, change, price);
        nextId++;
    }
}
