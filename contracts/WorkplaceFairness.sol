// contracts/WorkplaceFairness.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WorkplaceFairness
 * @notice Logs workplace dignity measures and fairness protocols.
 */
contract WorkplaceFairness {
    address public admin;

    struct Measure {
        string name;        // "NoOvertimeAbuse", "EqualOpportunity"
        string description;
        string status;      // "Implemented", "Pending"
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string name, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeasure(string calldata name, string calldata description, string calldata status) external onlyAdmin {
        measures.push(Measure(name, description, status, block.timestamp));
        emit MeasureLogged(name, description, status, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) { return measures.length; }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
