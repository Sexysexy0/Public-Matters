// contracts/FinancialResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FinancialResilience
 * @notice Ledger for communal resilience against debt storms and liquidity shocks.
 */
contract FinancialResilience {
    address public admin;

    struct Measure {
        string name;        // "DebtCap", "LiquidityBoost"
        string description;
        uint256 value;
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
