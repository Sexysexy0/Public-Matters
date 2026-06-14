// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OptimizationWarsCodex
/// @notice Codex covenant to document scalable design strategies in response to rising hardware costs
contract OptimizationWarsCodex {
    address public overseer;
    uint256 public codexCount;

    struct StrategyRecord {
        uint256 id;
        string approach;    // scalable engine, cross-platform optimization, modular assets
        string target;      // PC, Switch 2, PS5, Xbox Series
        string benefit;     // accessibility, performance stability, consumer reach
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => StrategyRecord) public records;

    event StrategyLogged(uint256 indexed id, string approach, string target, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs optimization strategy record
    function logStrategy(string calldata approach, string calldata target, string calldata benefit, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = StrategyRecord({
            id: codexCount,
            approach: approach,
            target: target,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit StrategyLogged(codexCount, approach, target, benefit);
    }

    /// @notice Citizens can view optimization strategy records
    function viewStrategy(uint256 id) external view returns (StrategyRecord memory) {
        return records[id];
    }
}
