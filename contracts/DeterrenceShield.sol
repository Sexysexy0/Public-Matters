// contracts/DeterrenceShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DeterrenceShield
 * @notice Logs deterrence measures in defense strategy.
 */
contract DeterrenceShield {
    address public admin;

    struct Measure {
        string type;        // "Nuclear", "Cyber", "Conventional"
        string description;
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string type, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeasure(string calldata type, string calldata description, string calldata status) external onlyAdmin {
        measures.push(Measure(type, description, status, block.timestamp));
        emit MeasureLogged(type, description, status, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) { return measures.length; }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
