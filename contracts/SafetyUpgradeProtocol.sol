pragma solidity ^0.8.20;

contract SafetyUpgradeProtocol {
    address public admin;

    struct Upgrade {
        string system;        // e.g. cooling, containment dome, seismic reinforcement
        string action;        // e.g. retrofit, replace, modernize
        string status;        // e.g. planned, ongoing, completed
        uint256 timestamp;
    }

    Upgrade[] public upgrades;

    event UpgradeLogged(string system, string action, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUpgrade(string calldata system, string calldata action, string calldata status) external onlyAdmin {
        upgrades.push(Upgrade(system, action, status, block.timestamp));
        emit UpgradeLogged(system, action, status, block.timestamp);
    }

    function totalUpgrades() external view returns (uint256) {
        return upgrades.length;
    }
}
