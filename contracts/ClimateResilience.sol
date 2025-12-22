// contracts/ClimateResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ClimateResilience
 * @notice Ledger for communal resilience against climate risks and disasters.
 */
contract ClimateResilience {
    address public admin;

    struct Measure {
        string name;        // "FloodBarrier", "HeatAdaptation"
        string description;
        uint256 value;      // e.g., budget or capacity
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string name, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeasure(string calldata name, string calldata description, uint256 value) external onlyAdmin {
        measures.push(Measure(name, description, value, block.timestamp));
        emit MeasureLogged(name, description, value, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) { return measures.length; }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
