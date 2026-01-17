pragma solidity ^0.8.20;

contract PortfolioRiskProtocol {
    address public admin;

    struct Risk {
        string factor;       // e.g. quantum threat, inflation, regulation
        string impact;       // e.g. high, medium, low
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string factor, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata factor, string calldata impact) external onlyAdmin {
        risks.push(Risk(factor, impact, block.timestamp));
        emit RiskLogged(factor, impact, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
