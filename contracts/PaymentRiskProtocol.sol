pragma solidity ^0.8.20;

contract PaymentRiskProtocol {
    address public admin;

    struct Risk {
        string service;      // e.g. Stripe, Shopiroller
        string exposure;     // e.g. live secret key, loyalty program
        string impact;       // e.g. charge users, steal rewards
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string service, string exposure, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata service, string calldata exposure, string calldata impact) external onlyAdmin {
        risks.push(Risk(service, exposure, impact, block.timestamp));
        emit RiskLogged(service, exposure, impact, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
