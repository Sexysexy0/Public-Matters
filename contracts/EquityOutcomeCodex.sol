// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title EquityOutcomeCodex
/// @notice Codex covenant to document equity principles in fiscal governance
contract EquityOutcomeCodex {
    address public overseer;
    uint256 public codexCount;

    struct EquityPrinciple {
        uint256 id;
        string principle;   // e.g. fair burden, service justice, transparency
        string safeguard;   // dignity, accountability, resilience
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => EquityPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string principle, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs equity principle
    function logPrinciple(string calldata principle, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        principles[codexCount] = EquityPrinciple({
            id: codexCount,
            principle: principle,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, principle, safeguard, notes);
    }

    /// @notice Citizens can view equity principles
    function viewPrinciple(uint256 id) external view returns (EquityPrinciple memory) {
        return principles[id];
    }
}
