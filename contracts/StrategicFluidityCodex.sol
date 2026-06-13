// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title StrategicFluidityCodex
/// @notice Codex covenant to safeguard adaptive strategy and mental creativity
contract StrategicFluidityCodex {
    address public overseer;
    uint256 public codexCount;

    struct StrategyPrinciple {
        uint256 id;
        string concept;      // e.g. Do Not Fight Last War, Grand Strategy, Emotion Control
        string safeguard;    // adaptability, detachment, rationality
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => StrategyPrinciple) public principles;

    event PrincipleLogged(uint256 indexed id, string concept, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs strategic principle
    function logPrinciple(string calldata concept, string calldata safeguard, string calldata notes) external onlyOverseer {
        codexCount++;
        principles[codexCount] = StrategyPrinciple({
            id: codexCount,
            concept: concept,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PrincipleLogged(codexCount, concept, safeguard, notes);
    }

    /// @notice Citizens can view strategic principles
    function viewPrinciple(uint256 id) external view returns (StrategyPrinciple memory) {
        return principles[id];
    }
}
