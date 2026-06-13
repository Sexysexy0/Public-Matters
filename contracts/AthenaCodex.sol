// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AthenaCodex
/// @notice Codex covenant to document detached wisdom principles of grand strategy
contract AthenaCodex {
    address public overseer;
    uint256 public codexCount;

    struct WisdomPrinciple {
        uint256 id;
        string principle;    // e.g. detachment, clarity, campaign vision
        string safeguard;    // avoid visceral reactions, maintain perspective
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => WisdomPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string principle, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs wisdom principle
    function logPrinciple(string calldata principle, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        principles[codexCount] = WisdomPrinciple({
            id: codexCount,
            principle: principle,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, principle, safeguard, notes);
    }

    /// @notice Citizens can view wisdom principles
    function viewPrinciple(uint256 id) external view returns (WisdomPrinciple memory) {
        return principles[id];
    }
}
