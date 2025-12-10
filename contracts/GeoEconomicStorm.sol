// contracts/GeoEconomicStorm.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title GeoEconomicStorm
 * @notice Communal audit ledger for global risks: media distractions, alliance fractures, debt manipulations, currency shifts.
 */
contract GeoEconomicStorm {
    address public admin;

    struct RiskEvent {
        string category;   // "Media", "Alliance", "Debt", "Currency"
        string description;
        uint256 timestamp;
    }

    RiskEvent[] public risks;

    event RiskLogged(string category, string description, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Log a new risk event
    function logRisk(string calldata category, string calldata description) external onlyAdmin {
        risks.push(RiskEvent(category, description, block.timestamp));
        emit RiskLogged(category, description, block.timestamp);
    }

    // View total risks
    function totalRisks() external view returns (uint256) {
        return risks.length;
    }

    // Retrieve a specific risk
    function getRisk(uint256 id) external view returns (RiskEvent memory) {
        require(id < risks.length, "Invalid risk id");
        return risks[id];
    }
}
