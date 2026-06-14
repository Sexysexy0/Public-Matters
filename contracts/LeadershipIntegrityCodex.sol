// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title LeadershipIntegrityCodex
/// @notice Codex covenant to document management leadership principles
contract LeadershipIntegrityCodex {
    address public overseer;
    uint256 public codexCount;

    struct LeadershipPrinciple {
        uint256 id;
        string principle;   // e.g. fairness, dignity, participatory trust
        string safeguard;   // accountability, transparency, resilience
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => LeadershipPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string principle, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs leadership principle
    function logPrinciple(string calldata principle, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        principles[codexCount] = LeadershipPrinciple({
            id: codexCount,
            principle: principle,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, principle, safeguard, notes);
    }

    /// @notice Citizens can view leadership principles
    function viewPrinciple(uint256 id) external view returns (LeadershipPrinciple memory) {
        return principles[id];
    }
}
