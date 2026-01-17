pragma solidity ^0.8.20;

contract CryptoAdaptationProtocol {
    address public admin;

    struct Upgrade {
        string method;       // e.g. post-quantum cryptography, consensus fork
        string purpose;      // e.g. strengthen security, adapt to new threats
        uint256 timestamp;
    }

    Upgrade[] public upgrades;

    event UpgradeLogged(string method, string purpose, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logUpgrade(string calldata method, string calldata purpose) external onlyAdmin {
        upgrades.push(Upgrade(method, purpose, block.timestamp));
        emit UpgradeLogged(method, purpose, block.timestamp);
    }

    function totalUpgrades() external view returns (uint256) {
        return upgrades.length;
    }
}
