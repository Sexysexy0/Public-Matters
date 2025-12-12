// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// UpgradeHarmonizer: track upgrades and ensure cross-platform feature parity
contract UpgradeHarmonizer {
    struct Upgrade {
        uint256 id;
        uint256 platformId;
        string feature;      // e.g., "AESA radar", "EW suite", "IRST"
        string block;        // e.g., "Tranche 4", "Block 2"
        bool certified;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Upgrade) public upgrades;
    mapping(address => bool) public stewards;

    event UpgradeLogged(uint256 indexed id, uint256 platformId, string feature, string block);
    event UpgradeCertified(uint256 indexed id, bool certified);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logUpgrade(
        uint256 platformId,
        string calldata feature,
        string calldata block,
        bool certified
    ) external {
        require(stewards[msg.sender], "Only steward");
        upgrades[nextId] = Upgrade(nextId, platformId, feature, block, certified, block.timestamp);
        emit UpgradeLogged(nextId, platformId, feature, block);
        nextId++;
    }

    function certify(uint256 id, bool certified) external {
        require(stewards[msg.sender], "Only steward");
        upgrades[id].certified = certified;
        emit UpgradeCertified(id, certified);
    }
}
