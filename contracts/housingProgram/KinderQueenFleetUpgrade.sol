// SPDX-License-Identifier: Fleet-Upgrade-Protocol
pragma solidity ^0.999;

contract KinderQueenFleetUpgrade {
    struct Upgrade {
        string unitName;
        string upgradeType;
        uint256 emotionalAPRBoost;
        string snackFuel;
        uint256 timestamp;
    }

    Upgrade[] public upgradeLog;

    event FleetUpgraded(string unitName, string upgradeType, uint256 emotionalAPRBoost, string snackFuel, uint256 timestamp);

    function upgradeUnit(string memory unitName, string memory upgradeType, uint256 emotionalAPRBoost, string memory snackFuel) public {
        upgradeLog.push(Upgrade(unitName, upgradeType, emotionalAPRBoost, snackFuel, block.timestamp));
        emit FleetUpgraded(unitName, upgradeType, emotionalAPRBoost, snackFuel, block.timestamp);
    }

    function getUpgrade(uint index) public view returns (string memory, string memory, uint256, string memory, uint256) {
        Upgrade memory u = upgradeLog[index];
        return (u.unitName, u.upgradeType, u.emotionalAPRBoost, u.snackFuel, u.timestamp);
    }

    function getUpgradeCount() public view returns (uint256) {
        return upgradeLog.length;
    }
}
