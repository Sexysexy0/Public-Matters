// contracts/EconomicWarfare.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EconomicWarfare
 * @notice Ledger for asset seizures, retaliations, currency shifts, and communal fallout.
 */
contract EconomicWarfare {
    address public admin;

    struct Event {
        string actor;        // e.g., "EU", "Russia", "China"
        string action;       // e.g., "Seizure", "Nationalization", "CurrencyShift", "FundCreation"
        string description;  // details of the move
        uint256 value;       // numeric value in USD equivalent
        uint256 timestamp;
    }

    Event[] public events;

    event EventLogged(string actor, string action, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Log a new economic warfare event
    function logEvent(string calldata actor, string calldata action, string calldata description, uint256 value) external onlyAdmin {
        events.push(Event(actor, action, description, value, block.timestamp));
        emit EventLogged(actor, action, description, value, block.timestamp);
    }

    // View total events
    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    // Retrieve a specific event
    function getEvent(uint256 id) external view returns (Event memory) {
        require(id < events.length, "Invalid event id");
        return events[id];
    }
}
