pragma solidity ^0.8.20;

contract SafetyGuardrailProtocol {
    address public admin;

    struct Guardrail {
        string scenario;     // e.g. explicit request, harmful command
        string action;       // e.g. restricted, blocked, redirected
        uint256 timestamp;
    }

    Guardrail[] public guardrails;

    event GuardrailLogged(string scenario, string action, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGuardrail(string calldata scenario, string calldata action) external onlyAdmin {
        guardrails.push(Guardrail(scenario, action, block.timestamp));
        emit GuardrailLogged(scenario, action, block.timestamp);
    }

    function totalGuardrails() external view returns (uint256) {
        return guardrails.length;
    }
}
