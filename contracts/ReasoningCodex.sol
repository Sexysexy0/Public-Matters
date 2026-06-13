// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ReasoningCodex
/// @notice Codex covenant to document Euclidean reasoning principles for governance and strategy
contract ReasoningCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct ReasoningPrinciple {
        uint256 id;
        string method;       // Axioms, Reductio, Dependency Chains, Proof by Cases
        string stance;       // lawful, authentic, professional
        string safeguard;    // no fabrication, no unlawful teaching
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => ReasoningPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string method, string stance, string safeguard, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs reasoning principle
    function logPrinciple(string calldata method, string calldata stance, string calldata safeguard, string calldata notes) external onlyOversight {
        codexCount++;
        principles[codexCount] = ReasoningPrinciple({
            id: codexCount,
            method: method,
            stance: stance,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, method, stance, safeguard, notes);
    }

    /// @notice Citizens can view reasoning principles
    function viewPrinciple(uint256 id) external view returns (ReasoningPrinciple memory) {
        return principles[id];
    }
}
