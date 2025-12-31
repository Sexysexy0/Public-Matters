// contracts/AbundanceProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AbundanceProtocol
 * @notice Ensures validator-grade dignity by linking abundance to reduced corruption.
 */
contract AbundanceProtocol {
    address public admin;

    struct Strategy {
        string focus;       // "EconomicGrowth", "BasicNeeds", "CivicEngagement"
        string description;
        uint256 timestamp;
    }

    Strategy[] public strategies;

    event StrategyLogged(string focus, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logStrategy(string calldata focus, string calldata description) external onlyAdmin {
        strategies.push(Strategy(focus, description, block.timestamp));
        emit StrategyLogged(focus, description, block.timestamp);
    }

    function totalStrategies() external view returns (uint256) { return strategies.length; }

    function getStrategy(uint256 id) external view returns (Strategy memory) {
        require(id < strategies.length, "Invalid id");
        return strategies[id];
    }
}
