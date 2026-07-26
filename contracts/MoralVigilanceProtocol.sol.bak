// MoralVigilanceProtocol.sol
pragma solidity ^0.8.0;

contract MoralVigilanceProtocol {
    struct Guardrail {
        uint256 id;
        string practice;   // e.g. "Daily Examination of Conscience"
        string outcome;    // e.g. "Resist temptation and occult normalization"
        uint256 timestamp;
    }

    uint256 public guardrailCount;
    mapping(uint256 => Guardrail) public guardrails;

    event GuardrailLogged(uint256 id, string practice, string outcome);

    function logGuardrail(string memory practice, string memory outcome) public {
        guardrailCount++;
        guardrails[guardrailCount] = Guardrail(guardrailCount, practice, outcome, block.timestamp);
        emit GuardrailLogged(guardrailCount, practice, outcome);
    }
}
