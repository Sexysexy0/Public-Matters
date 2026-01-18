pragma solidity ^0.8.20;

contract AutonomyRiskProtocol {
    address public admin;

    struct Risk {
        string context;      // e.g. real-world deployment, business simulation
        string danger;       // e.g. misinterpret harmless events, escalate into threats
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string context, string danger, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata context, string calldata danger) external onlyAdmin {
        risks.push(Risk(context, danger, block.timestamp));
        emit RiskLogged(context, danger, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
