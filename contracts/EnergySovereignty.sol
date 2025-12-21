// contracts/EnergySovereignty.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EnergySovereignty
 * @notice Ledger for oil resilience, renewable dignity, nuclear stewardship, and communal audit of energy flows.
 */
contract EnergySovereignty {
    address public admin;

    struct EnergyEvent {
        string sector;       // "Oil", "Renewable", "Nuclear", "Grid"
        string description;
        uint256 value;       // optional numeric value (e.g., MW, USD)
        uint256 timestamp;
    }

    EnergyEvent[] public events;

    event EnergyLogged(string sector, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logEnergy(string calldata sector, string calldata description, uint256 value) external onlyAdmin {
        events.push(EnergyEvent(sector, description, value, block.timestamp));
        emit EnergyLogged(sector, description, value, block.timestamp);
    }

    function totalEvents() external view returns (uint256) {
        return events.length;
    }

    function getEvent(uint256 id) external view returns (EnergyEvent memory) {
        require(id < events.length, "Invalid id");
        return events[id];
    }
}
