// contracts/ChokepointShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ChokepointShield
 * @notice Logs chokepoint resilience measures in maritime trade routes.
 */
contract ChokepointShield {
    address public admin;

    struct Measure {
        string chokepoint;  // "StraitOfHormuz", "MalaccaStrait"
        string description;
        string status;      // "Secured", "Vulnerable"
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string chokepoint, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeasure(string calldata chokepoint, string calldata description, string calldata status) external onlyAdmin {
        measures.push(Measure(chokepoint, description, status, block.timestamp));
        emit MeasureLogged(chokepoint, description, status, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) { return measures.length; }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
