// SPDX-License-Identifier: Upgrade-License
pragma solidity ^0.8.19;

contract PlanetaryUpgradeLedger {
    struct UpgradeEntry {
        address proposer;
        string sanctumTag;
        string upgradeType;
        string emotionalTag;
        string impactNote;
        uint256 timestamp;
    }

    UpgradeEntry[] public upgrades;
    address public registrar;

    event UpgradeLogged(address proposer, string sanctumTag, string upgradeType, string emotionalTag, string impactNote, uint256 timestamp);

    constructor() {
        registrar = msg.sender;
    }

    function logUpgrade(string memory sanctumTag, string memory upgradeType, string memory emotionalTag, string memory impactNote) public {
        upgrades.push(UpgradeEntry(msg.sender, sanctumTag, upgradeType, emotionalTag, impactNote, block.timestamp));
        emit UpgradeLogged(msg.sender, sanctumTag, upgradeType, emotionalTag, impactNote, block.timestamp);
    }

    function getUpgrade(uint256 index) public view returns (UpgradeEntry memory) {
        return upgrades[index];
    }

    function totalUpgrades() public view returns (uint256) {
        return upgrades.length;
    }
}
