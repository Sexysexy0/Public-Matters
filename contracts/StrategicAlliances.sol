// contracts/StrategicAlliances.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StrategicAlliances
 * @notice Ledger for BRICS+ resilience, EU fragility, US debt storms, and China’s ascendancy.
 */
contract StrategicAlliances {
    address public admin;

    struct AllianceEvent {
        string actor;        // e.g., "BRICS+", "EU", "US", "China"
        string description;
        uint256 value;       // optional numeric value (e.g., billions)
        uint256 timestamp;
    }

    AllianceEvent[] public events;

    event AllianceLogged(string actor, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logAlliance(string calldata actor, string calldata description, uint256 value) external onlyAdmin {
        events.push(AllianceEvent(actor, description, value, block.timestamp));
        emit AllianceLogged(actor, description, value, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    function getEvent(uint256 id) external view returns (AllianceEvent memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
