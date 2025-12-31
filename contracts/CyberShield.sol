// contracts/CyberShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CyberShield
 * @notice Logs cyber defense shields against attacks and intrusions.
 */
contract CyberShield {
    address public admin;

    struct Shield {
        string type;        // "Firewall", "Encryption", "ZeroTrust"
        string description;
        uint256 timestamp;
    }

    Shield[] public shields;

    event ShieldLogged(string type, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logShield(string calldata type, string calldata description) external onlyAdmin {
        shields.push(Shield(type, description, block.timestamp));
        emit ShieldLogged(type, description, block.timestamp);
    }

    function totalShields() external view returns (uint256) { return shields.length; }

    function getShield(uint256 id) external view returns (Shield memory) {
        require(id < shields.length, "Invalid id");
        return shields[id];
    }
}
