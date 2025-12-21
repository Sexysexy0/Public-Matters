// contracts/BRICSResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BRICSResilience
 * @notice Protocol for resilience measures within BRICS+ alliance.
 */
contract BRICSResilience {
    address public admin;

    struct Measure {
        string policy;
        string description;
        uint256 value;
        uint256 timestamp;
    }

    Measure[] public measures;

    event MeasureLogged(string policy, string description, uint256 value, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logMeasure(string calldata policy, string calldata description, uint256 value) external onlyAdmin {
        measures.push(Measure(policy, description, value, block.timestamp));
        emit MeasureLogged(policy, description, value, block.timestamp);
    }

    function totalMeasures() external view returns (uint256) {
        return measures.length;
    }

    function getMeasure(uint256 id) external view returns (Measure memory) {
        require(id < measures.length, "Invalid id");
        return measures[id];
    }
}
