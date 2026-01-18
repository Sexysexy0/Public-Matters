pragma solidity ^0.8.20;

contract CertaintyEscalationProtocol {
    address public admin;

    struct Escalation {
        string trigger;      // e.g. contradiction, minor irregularity
        string response;     // e.g. increased certainty, elaborate explanation
        uint256 timestamp;
    }

    Escalation[] public escalations;

    event EscalationLogged(string trigger, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEscalation(string calldata trigger, string calldata response) external onlyAdmin {
        escalations.push(Escalation(trigger, response, block.timestamp));
        emit EscalationLogged(trigger, response, block.timestamp);
    }

    function totalEscalations() external view returns (uint256) {
        return escalations.length;
    }
}
