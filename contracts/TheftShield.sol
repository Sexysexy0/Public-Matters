// contracts/TheftShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TheftShield
 * @notice Logs defenses against intellectual property theft and technology exfiltration.
 */
contract TheftShield {
    address public admin;

    struct Defense {
        string domain;      // "IP", "Academia", "TechExports"
        string description;
        uint256 timestamp;
    }

    Defense[] public defenses;

    event DefenseLogged(string domain, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDefense(string calldata domain, string calldata description) external onlyAdmin {
        defenses.push(Defense(domain, description, block.timestamp));
        emit DefenseLogged(domain, description, block.timestamp);
    }

    function totalDefenses() external view returns (uint256) { return defenses.length; }

    function getDefense(uint256 id) external view returns (Defense memory) {
        require(id < defenses.length, "Invalid id");
        return defenses[id];
    }
}
