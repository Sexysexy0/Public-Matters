// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PricePassThrough: record consumer price changes after tax/VAT cuts
contract PricePassThrough {
    struct PriceChange {
        uint256 id;
        string item;
        uint256 oldPrice;
        uint256 newPrice;
        bool compliant;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => PriceChange) public priceChanges;
    mapping(address => bool) public stewards;

    event PriceChangeLogged(uint256 indexed id, string item, uint256 oldPrice, uint256 newPrice, bool compliant);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPriceChange(string calldata item, uint256 oldPrice, uint256 newPrice, bool compliant) external {
        require(stewards[msg.sender], "Only steward");
        priceChanges[nextId] = PriceChange(nextId, item, oldPrice, newPrice, compliant, block.timestamp);
        emit PriceChangeLogged(nextId, item, oldPrice, newPrice, compliant);
        nextId++;
    }
}
