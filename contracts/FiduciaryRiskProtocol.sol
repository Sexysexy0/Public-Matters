pragma solidity ^0.8.20;

contract FiduciaryRiskProtocol {
    address public admin;

    struct Risk {
        string concern;      // e.g. Volatility, Accounting, Legal
        string mitigation;   // e.g. Custody, Multi-sig, ETF wrapper
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string concern, string mitigation, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata concern, string calldata mitigation) external onlyAdmin {
        risks.push(Risk(concern, mitigation, block.timestamp));
        emit RiskLogged(concern, mitigation, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
