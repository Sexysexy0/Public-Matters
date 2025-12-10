// contracts/EconomicJustice.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EconomicJustice
 * @notice Wage fairness, debt transparency, inflation resilience, and communal wealth redistribution.
 */
contract EconomicJustice {
    address public admin;

    struct JusticeEvent {
        string category;   // "Wage", "Debt", "Inflation", "Redistribution"
        string description;
        uint256 timestamp;
    }

    JusticeEvent[] public events;

    event JusticeLogged(string category, string description, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logJustice(string calldata category, string calldata description) external onlyAdmin {
        events.push(JusticeEvent(category, description, block.timestamp));
        emit JusticeLogged(category, description, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    function getEvent(uint256 id) external view returns (JusticeEvent memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
