pragma solidity ^0.8.20;

contract IncidentEscalationProtocol {
    address public admin;

    struct Escalation {
        string incident;     // e.g. malware outbreak, credential leak
        string level;        // e.g. low, medium, high, critical
        uint256 timestamp;
    }

    Escalation[] public escalations;

    event EscalationLogged(string incident, string level, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logEscalation(string calldata incident, string calldata level) external onlyAdmin {
        escalations.push(Escalation(incident, level, block.timestamp));
        emit EscalationLogged(incident, level, block.timestamp);
    }

    function totalEscalations() external view returns (uint256) {
        return escalations.length;
    }
}
