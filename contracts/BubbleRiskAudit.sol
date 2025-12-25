// contracts/BubbleRiskAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BubbleRiskAudit
 * @notice Tracks AI bubble risk and communal equity warnings.
 */
contract BubbleRiskAudit {
    address public admin;

    struct Risk {
        string sector;      // "AI", "Tech"
        uint256 probability; // percentage odds
        string verdict;     // "Overvalued", "Stable"
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string sector, uint256 probability, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logRisk(string calldata sector, uint256 probability, string calldata verdict) external onlyAdmin {
        risks.push(Risk(sector, probability, verdict, block.timestamp));
        emit RiskLogged(sector, probability, verdict, block.timestamp);
    }

    function totalRisks() external view returns (uint256) { return risks.length; }

    function getRisk(uint256 id) external view returns (Risk memory) {
        require(id < risks.length, "Invalid id");
        return risks[id];
    }
}
