pragma solidity ^0.8.20;

contract GlobalRiskProtocol {
    address public admin;

    struct Risk {
        string event;        // e.g. war, inflation, tariffs
        string impact;       // e.g. recession, market volatility
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string event, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata event, string calldata impact) external onlyAdmin {
        risks.push(Risk(event, impact, block.timestamp));
        emit RiskLogged(event, impact, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
