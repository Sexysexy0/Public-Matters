// contracts/RiskLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RiskLedger
 * @notice Tracks economic risks such as exports, governance, inflation, and global headwinds.
 */
contract RiskLedger {
    address public admin;

    struct Risk {
        string category;   // "Exports", "Governance", "Inflation"
        string description;
        string severity;   // "Low", "Medium", "High"
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string category, string description, string severity, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRisk(string calldata category, string calldata description, string calldata severity) external onlyAdmin {
        risks.push(Risk(category, description, severity, block.timestamp));
        emit RiskLogged(category, description, severity, block.timestamp);
    }

    function totalRisks() external view returns (uint256) { return risks.length; }

    function getRisk(uint256 id) external view returns (Risk memory) {
        require(id < risks.length, "Invalid id");
        return risks[id];
    }
}
