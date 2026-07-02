// Copyright (c) 2026 Emervin V. Gueco (Vin).
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PrivacyGuardRails
/// @notice Covenant contract establishing guardrails against surveillance misuse,
///         ensuring dignity, civil liberties, and protection from overreach.
contract PrivacyGuardRails {
    address public overseer;
    uint256 public ruleCount;

    struct Guardrail {
        uint256 id;
        string principle;      // Privacy, Consent, Oversight, Transparency, Minimization
        string description;    // The safeguard encoded
        uint256 timestamp;
    }

    mapping(uint256 => Guardrail> public guardrails;

    event GuardrailSet(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Add a new privacy guardrail
    function addGuardrail(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        ruleCount++;
        guardrails[ruleCount] = Guardrail({
            id: ruleCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit GuardrailSet(ruleCount, principle, description);
    }

    /// @notice View a specific guardrail
    function viewGuardrail(uint256 id) external view returns (Guardrail memory) {
        return guardrails[id];
    }
}
