pragma solidity ^0.8.20;

contract PostQuantumUpgradeProtocol {
    address public admin;

    struct Upgrade {
        string algorithm;    // e.g. lattice-based, hash-based signatures
        string purpose;      // e.g. resist quantum attacks
        uint256 timestamp;
    }

    Upgrade[] public upgrades;

    event UpgradeLogged(string algorithm, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUpgrade(string calldata algorithm, string calldata purpose) external onlyAdmin {
        upgrades.push(Upgrade(algorithm, purpose, block.timestamp));
        emit UpgradeLogged(algorithm, purpose, block.timestamp);
    }

    function totalUpgrades() external view returns (uint256) {
        return upgrades.length;
    }
}
