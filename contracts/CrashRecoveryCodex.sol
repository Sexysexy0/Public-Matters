// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CrashRecoveryCodex
/// @notice Codex covenant to document recovery blueprint for the gaming industry crash
contract CrashRecoveryCodex {
    address public overseer;
    uint256 public codexCount;

    struct RecoveryPhase {
        uint256 id;
        string phase;       // stabilization, workforce healing, innovation scaling, consumer trust
        string action;      // layoffs recovery, governance reform, scalable design, transparency
        string benefit;     // resilience, dignity, profitability, trust
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => RecoveryPhase) public records;

    event PhaseLogged(uint256 indexed id, string phase, string action, string benefit);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs recovery phase record
    function logPhase(string calldata phase, string calldata action, string calldata benefit, string calldata notes) external onlyOverseer {
        codexCount++;
        records[codexCount] = RecoveryPhase({
            id: codexCount,
            phase: phase,
            action: action,
            benefit: benefit,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PhaseLogged(codexCount, phase, action, benefit);
    }

    /// @notice Citizens can view recovery phase records
    function viewPhase(uint256 id) external view returns (RecoveryPhase memory) {
        return records[id];
    }
}
