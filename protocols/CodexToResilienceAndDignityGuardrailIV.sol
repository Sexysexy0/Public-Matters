// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract CodexToResilienceAndDignityGuardrailIV {
    string public batchID = "1321.9.260";
    string public steward = "Vinvin";

    address public admin;

    struct Guardrail {
        string principle;     // trust, dignity, fairness, resilience
        string description;
        uint256 timestamp;
    }

    Guardrail[] public guardrails;

    event GuardrailCodified(string principle, string description);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function codifyGuardrail(string memory principle, string memory description) public onlyAdmin {
        guardrails.push(Guardrail(principle, description, block.timestamp));
        emit GuardrailCodified(principle, description);
    }
}
