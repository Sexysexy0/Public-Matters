// contracts/MediaResilienceShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MediaResilienceShield
 * @notice Logs resilience measures for media integrity and public trust.
 */
contract MediaResilienceShield {
    address public admin;

    struct Measure {
        string name;        // "FactChecking", "CommunityOversight"
        string description;
        string status;      // "Active", "Pending"
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
