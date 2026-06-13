// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DecisionContinuityCodex
/// @notice Codex covenant to document continuity of proof-based decision governance
contract DecisionContinuityCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct ContinuityRule {
        uint256 id;
        string domain;       // governance, strategy, creative
        string principle;    // continuity, lawful, authentic
        string safeguard;    // no fabrication, no unlawful teaching
        string method;       // axioms, reductio, dependency chains, proof by cases
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ContinuityRule) public rules;

    event ContinuityLogged(uint256 indexed id, string domain, string principle, string safeguard, string method, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs continuity rule
    function logContinuity(string calldata domain, string calldata principle, string calldata safeguard, string calldata method, string calldata notes) external onlyOversight {
        codexCount++;
        rules[codexCount] = ContinuityRule({
            id: codexCount,
            domain: domain,
            principle: principle,
            safeguard: safeguard,
            method: method,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ContinuityLogged(codexCount, domain, principle, safeguard, method, notes);
    }

    /// @notice Citizens can view continuity rules
    function viewContinuity(uint256 id) external view returns (ContinuityRule memory) {
        return rules[id];
    }
}
