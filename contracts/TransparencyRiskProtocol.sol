pragma solidity ^0.8.20;

contract TransparencyRiskProtocol {
    address public admin;

    struct Risk {
        string caseStudy;    // e.g. Silicon Valley Bank collapse
        string factor;       // e.g. regulatory failure, tech transparency
        string outcome;      // e.g. reduced risk, volatility spike
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string caseStudy, string factor, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata caseStudy, string calldata factor, string calldata outcome) external onlyAdmin {
        risks.push(Risk(caseStudy, factor, outcome, block.timestamp));
        emit RiskLogged(caseStudy, factor, outcome, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
