// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OptimizationCodex
/// @notice Codex covenant to document performance feedback and optimization targets
contract OptimizationCodex {
    address public overseer;
    uint256 public codexCount;

    struct OptimizationRecord {
        uint256 id;
        string hardware;    // GPU/CPU model
        uint256 fpsReport;  // reported frames per second
        string settings;    // resolution, graphics preset
        string feedback;    // player comment summary
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => OptimizationRecord) public records;

    event OptimizationLogged(uint256 indexed id, string hardware, uint256 fpsReport, string settings, string feedback);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs optimization feedback record
    function logOptimization(string calldata hardware, uint256 fpsReport, string calldata settings, string calldata feedback, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = OptimizationRecord({
            id: codexCount,
            hardware: hardware,
            fpsReport: fpsReport,
            settings: settings,
            feedback: feedback,
            notes: notes,
            timestamp: block.timestamp
        });
        emit OptimizationLogged(codexCount, hardware, fpsReport, settings, feedback);
    }

    /// @notice Citizens can view optimization records
    function viewOptimization(uint256 id) external view returns (OptimizationRecord memory) {
        return records[id];
    }
}
