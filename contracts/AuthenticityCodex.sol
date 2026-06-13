// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuthenticityCodex
/// @notice Codex covenant to document authenticity rules and lawful alignment
contract AuthenticityCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct AuthenticityRule {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string principle;    // authenticity, lawful, professional
        string restriction;  // no fabrication, no unlawful teaching
        string behaviour;    // clean, aligned, disciplined
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => AuthenticityRule) public rules;

    event RuleLogged(uint256 indexed id, string domain, string principle, string restriction, string behaviour, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs authenticity rule
    function logRule(string calldata domain, string calldata principle, string calldata restriction, string calldata behaviour, string calldata notes) external onlyOversight {
        codexCount++;
        rules[codexCount] = AuthenticityRule({
            id: codexCount,
            domain: domain,
            principle: principle,
            restriction: restriction,
            behaviour: behaviour,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RuleLogged(codexCount, domain, principle, restriction, behaviour, notes);
    }

    /// @notice Citizens can view authenticity rules
    function viewRule(uint256 id) external view returns (AuthenticityRule memory) {
        return rules[id];
    }
}
