// contracts/VolatilityLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title VolatilityLedger
 * @notice Tracks volatility events that disrupted Bitcoin rallies.
 */
contract VolatilityLedger {
    address public admin;

    struct Event {
        string description;
        string type;       // "Delegitimization", "Leverage Reduction", "Market Shock"
        uint256 impact;    // e.g., % drop
        uint256 timestamp;
    }

    Event[] public events;

    event EventLogged(string description, string type, uint256 impact, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEvent(string calldata description, string calldata type, uint256 impact) external onlyAdmin {
        events.push(Event(description, type, impact, block.timestamp));
        emit EventLogged(description, type, impact, block.timestamp);
    }

    function totalEvents() external view returns (uint256) { return events.length; }

    function getEvent(uint256 id) external view returns (Event memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
