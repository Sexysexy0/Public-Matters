pragma solidity ^0.8.20;

contract AccessRiskProtocol {
    address public admin;

    struct Risk {
        string borrowerType; // e.g. prime, subprime
        string restriction;  // e.g. tighter approvals, lower limits
        string effect;       // e.g. reduced access to credit
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string borrowerType, string restriction, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata borrowerType, string calldata restriction, string calldata effect) external onlyAdmin {
        risks.push(Risk(borrowerType, restriction, effect, block.timestamp));
        emit RiskLogged(borrowerType, restriction, effect, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
