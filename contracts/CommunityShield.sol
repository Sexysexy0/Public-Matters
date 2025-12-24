// contracts/CommunityShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CommunityShield
 * @notice Logs communal defense measures against hacks and scams.
 */
contract CommunityShield {
    address public admin;

    struct Defense {
        string name;        // "DiscordAudit", "SecurityUpdate"
        string description;
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Defense[] public defenses;

    event DefenseLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logDefense(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        defenses.push(Defense(name, description, status, block.timestamp));
        emit DefenseLogged(name, description, status, block.timestamp);
    }

    function totalDefenses() external view returns (uint256) { return defenses.length; }

    function getDefense(uint256 id) external view returns (Defense memory) {
        require(id < defenses.length, "Invalid id");
        return defenses[id];
    }
}
