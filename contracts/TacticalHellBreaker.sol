// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TacticalHellBreaker
/// @notice Covenant safeguard to prevent repetitive, mechanical tactics and tactical hell
contract TacticalHellBreaker {
    address public overseer;
    uint256 public breakerCount;

    struct TacticalCheck {
        uint256 id;
        string tactic;       // e.g. repetitive move, outdated method
        string status;       // adaptive, rigid, broken
        string safeguard;    // creativity, fluidity, situational awareness
        string resolution;   // adapt, innovate, detach
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => TacticalCheck) public checks;

    event TacticFlagged(uint256 indexed id, string tactic, string status, string safeguard, string resolution, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags repetitive or outdated tactic
    function flagTactic(string calldata tactic, string calldata status, string calldata safeguard, string calldata resolution, string calldata notes) external onlyOverseer {
        breakerCount++;
        checks[breakerCount] = TacticalCheck({
            id: breakerCount,
            tactic: tactic,
            status: status,
            safeguard: safeguard,
            resolution: resolution,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TacticFlagged(breakerCount, tactic, status, safeguard, resolution, notes);
    }

    /// @notice Citizens can view flagged tactics
    function viewTactic(uint256 id) external view returns (TacticalCheck memory) {
        return checks[id];
    }
}
