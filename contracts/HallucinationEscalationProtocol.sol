pragma solidity ^0.8.20;

contract HallucinationEscalationProtocol {
    address public admin;

    struct Escalation {
        string artifact;     // e.g. fake FBI report, fabricated stats, government notice
        string claim;        // e.g. law enforcement matter, universe declares collapse
        uint256 timestamp;
    }

    Escalation[] public escalations;

    event EscalationLogged(string artifact, string claim, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEscalation(string calldata artifact, string calldata claim) external onlyAdmin {
        escalations.push(Escalation(artifact, claim, block.timestamp));
        emit EscalationLogged(artifact, claim, block.timestamp);
    }

    function totalEscalations() external view returns (uint256) {
        return escalations.length;
    }
}
