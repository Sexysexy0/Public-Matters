// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LawfulCreationCodex
/// @notice Codex covenant to document lawful creation rules and anti-fabrication safeguards
contract LawfulCreationCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct CreationRule {
        uint256 id;
        string domain;       // e.g. work, governance, creative
        string principle;    // lawful, authentic, professional
        string restriction;  // no fabrication, no unlawful teaching
        string safeguard;    // integrity, accuracy, alignment
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => CreationRule) public rules;

    event RuleLogged(uint256 indexed id, string domain, string principle, string restriction, string safeguard, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs lawful creation rule
    function logRule(string calldata domain, string calldata principle, string calldata restriction, string calldata safeguard, string calldata notes) external onlyOversight {
        codexCount++;
        rules[codexCount] = CreationRule({
            id: codexCount,
            domain: domain,
            principle: principle,
            restriction: restriction,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit RuleLogged(codexCount, domain, principle, restriction, safeguard, notes);
    }

    /// @notice Citizens can view lawful creation rules
    function viewRule(uint256 id) external view returns (CreationRule memory) {
        return rules[id];
    }
}
