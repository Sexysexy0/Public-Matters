// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OriginDesignCodex
/// @notice Codex covenant to document scientific-theistic debate principles
contract OriginDesignCodex {
    address public oversightCommittee;
    uint256 public codexCount;

    struct DebatePrinciple {
        uint256 id;
        string theme;       // Big Bang, Fine-Tuning, Information, Worldview
        string stance;      // lawful, authentic, professional
        string safeguard;   // no fabrication, no unlawful teaching
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => DebatePrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string theme, string stance, string safeguard, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight logs debate principle
    function logPrinciple(string calldata theme, string calldata stance, string calldata safeguard, string calldata notes) external onlyOversight {
        codexCount++;
        principles[codexCount] = DebatePrinciple({
            id: codexCount,
            theme: theme,
            stance: stance,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, theme, stance, safeguard, notes);
    }

    /// @notice Citizens can view debate principles
    function viewPrinciple(uint256 id) external view returns (DebatePrinciple memory) {
        return principles[id];
    }
}
