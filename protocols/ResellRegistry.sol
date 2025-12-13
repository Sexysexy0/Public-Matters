// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ResellRegistry: record resell transactions of containers
contract ResellRegistry {
    struct Sale {
        uint256 id;
        string buyer;
        string containerSize;
        uint256 price;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Sale) public sales;
    mapping(address => bool) public stewards;

    event SaleLogged(uint256 indexed id, string buyer, string containerSize, uint256 price);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSale(string calldata buyer, string calldata containerSize, uint256 price) external {
        require(stewards[msg.sender], "Only steward");
        sales[nextId] = Sale(nextId, buyer, containerSize, price, block.timestamp);
        emit SaleLogged(nextId, buyer, containerSize, price);
        nextId++;
    }
}
