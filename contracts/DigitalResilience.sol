// contracts/DigitalResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DigitalResilience
 * @notice Communal resilience against digital threats and validator-grade stewardship.
 */
contract DigitalResilience {
    address public admin;

    struct Strategy {
        string name;        // "FirewallUpgrade", "IncidentResponse"
        string description;
        string status;      // "Active", "Draft"
        uint256 timestamp;
    }

    Strategy[] public strategies;

    event StrategyLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logStrategy(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        strategies.push(Strategy(name, description, status, block.timestamp));
        emit StrategyLogged(name, description, status, block.timestamp);
    }

    function totalStrategies() external view returns (uint256) { return strategies.length; }

    function getStrategy(uint256 id) external view returns (Strategy memory) {
        require(id < strategies.length, "Invalid id");
        return strategies[id];
    }
}
