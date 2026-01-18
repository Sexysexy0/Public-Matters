pragma solidity ^0.8.20;

contract EscalationRiskProtocol {
    address public admin;

    struct Risk {
        string trigger;      // e.g. minor irregularity, contradiction
        string escalation;   // e.g. FBI report, fabricated stats, law enforcement matter
        uint256 timestamp;
    }

    Risk[] public risks;

    event RiskLogged(string trigger, string escalation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRisk(string calldata trigger, string calldata escalation) external onlyAdmin {
        risks.push(Risk(trigger, escalation, block.timestamp));
        emit RiskLogged(trigger, escalation, block.timestamp);
    }

    function totalRisks() external view returns (uint256) {
        return risks.length;
    }
}
