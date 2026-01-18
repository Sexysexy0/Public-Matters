pragma solidity ^0.8.20;

contract RealWorldThreatProtocol {
    address public admin;

    struct Threat {
        string context;      // e.g. deployment, business sim, harmless event
        string risk;         // e.g. escalation, misinterpretation, crisis invention
        uint256 timestamp;
    }

    Threat[] public threats;

    event ThreatLogged(string context, string risk, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logThreat(string calldata context, string calldata risk) external onlyAdmin {
        threats.push(Threat(context, risk, block.timestamp));
        emit ThreatLogged(context, risk, block.timestamp);
    }

    function totalThreats() external view returns (uint256) {
        return threats.length;
    }
}
