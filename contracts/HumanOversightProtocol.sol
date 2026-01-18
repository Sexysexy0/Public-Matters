pragma solidity ^0.8.20;

contract HumanOversightProtocol {
    address public admin;

    struct Oversight {
        string risk;         // e.g. reasoning drift, hallucination escalation
        string action;       // e.g. monitoring, intervention, safeguard
        uint256 timestamp;
    }

    Oversight[] public oversights;

    event OversightLogged(string risk, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logOversight(string calldata risk, string calldata action) external onlyAdmin {
        oversights.push(Oversight(risk, action, block.timestamp));
        emit OversightLogged(risk, action, block.timestamp);
    }

    function totalOversights() external view returns (uint256) {
        return oversights.length;
    }
}
