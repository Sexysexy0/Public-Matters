// contracts/SpyDefense.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SpyDefense
 * @notice Logs counter-intelligence measures against infiltration and espionage.
 */
contract SpyDefense {
    address public admin;

    struct Measure {
        string type;        // "CounterIntel", "Surveillance", "BlockchainLogs"
        string description;
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string type, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMeasure(string calldata type, string calldata description) external onlyAdmin {
        measures.push(Measure(type, description, block.timestamp));
        emit MeasureLogged(type, description, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) { return measures.length; }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
