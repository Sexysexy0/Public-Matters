pragma solidity ^0.8.20;

contract InstitutionalRiskProtocol {
    address public admin;

    struct Risk {
        string actor;        // e.g. Michael Saylor, BlackRock
        string mechanism;    // e.g. circular funding loop, tokenized dividends
        string consequence;  // e.g. credit chaos, systemic risk
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string actor, string mechanism, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata actor, string calldata mechanism, string calldata consequence) external onlyAdmin {
        risks.push(Risk(actor, mechanism, consequence, block.timestamp));
        emit RiskLogged(actor, mechanism, consequence, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
