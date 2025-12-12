// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// UpgradeRegistry: record upgrades or new acquisitions (Block 70/72, Block 80)
contract UpgradeRegistry {
    struct Upgrade {
        uint256 id;
        string model;
        string block;       // e.g., "Block 70", "Block 80"
        string features;    // radar, EW suite, etc.
        uint256 cost;       // USD millions
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Upgrade) public upgrades;
    mapping(address => bool) public stewards;

    event UpgradeLogged(uint256 indexed id, string model, string block);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logUpgrade(string calldata model, string calldata block, string calldata features, uint256 cost) external {
        require(stewards[msg.sender], "Only steward");
        upgrades[nextId] = Upgrade(nextId, model, block, features, cost, block.timestamp);
        emit UpgradeLogged(nextId, model, block);
        nextId++;
    }
}
