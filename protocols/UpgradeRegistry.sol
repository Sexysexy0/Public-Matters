// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// UpgradeRegistry: record systems upgraded to latest patched versions
contract UpgradeRegistry {
    struct Upgrade {
        uint256 id;
        string system;      // e.g., "Vercel app", "API gateway"
        string version;     // patched version
        address upgrader;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Upgrade) public upgrades;
    mapping(address => bool) public stewards;

    event UpgradeLogged(uint256 indexed id, string system, string version);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logUpgrade(string calldata system, string calldata version) external {
        require(stewards[msg.sender], "Only steward");
        upgrades[nextId] = Upgrade(nextId, system, version, msg.sender, block.timestamp);
        emit UpgradeLogged(nextId, system, version);
        nextId++;
    }
}
