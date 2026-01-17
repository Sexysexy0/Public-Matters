pragma solidity ^0.8.20;

contract QuantumRiskProtocol {
    address public admin;

    struct Risk {
        string system;       // e.g. Bitcoin, banking, military comms
        string threat;       // e.g. quantum break, cryptography vulnerability
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string system, string threat, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata system, string calldata threat) external onlyAdmin {
        risks.push(Risk(system, threat, block.timestamp));
        emit RiskLogged(system, threat, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
