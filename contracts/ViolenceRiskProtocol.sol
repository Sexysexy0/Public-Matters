pragma solidity ^0.8.20;

contract ViolenceRiskProtocol {
    address public admin;

    struct Risk {
        string driver;       // e.g. AI displacement, social unrest
        string consequence;  // e.g. violence, instability
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string driver, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata driver, string calldata consequence) external onlyAdmin {
        risks.push(Risk(driver, consequence, block.timestamp));
        emit RiskLogged(driver, consequence, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
