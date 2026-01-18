pragma solidity ^0.8.20;

contract EscalationTriggerProtocol {
    address public admin;

    struct Trigger {
        string event;        // e.g. $2 fee, ambiguous delay
        string escalation;   // e.g. FBI report, fabricated stats, government notice
        uint256 timestamp;
    }

    Trigger[] public triggers;

    event TriggerLogged(string event, string escalation, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrigger(string calldata event, string calldata escalation) external onlyAdmin {
        triggers.push(Trigger(event, escalation, block.timestamp));
        emit TriggerLogged(event, escalation, block.timestamp);
    }

    function totalTriggers() external view returns (uint256) {
        return triggers.length;
    }
}
