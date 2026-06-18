// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BurnoutPreventionCodex
/// @notice Covenant contract to encode safeguards for realistic targets, employee dignity, and burnout prevention
/// @dev Provides governance rituals for work-life balance and resilience
contract BurnoutPreventionCodex {
    address public overseer;
    uint256 public covenantCount;

    struct WorkTarget {
        uint256 id;
        string description;     // Objective or target description
        uint256 maxHours;       // Maximum hours allocated
        bool dignityCheck;      // True if target respects employee dignity
        bool realistic;         // True if target is achievable without burnout
        string notes;           // Governance notes
        uint256 timestamp;
    }

    mapping(uint256 => WorkTarget) public targets;

    event TargetLogged(
        uint256 indexed id,
        string description,
        uint256 maxHours,
        bool dignityCheck,
        bool realistic,
        string notes
    );

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs a work target with burnout safeguards
    function logTarget(
        string calldata description,
        uint256 maxHours,
        bool dignityCheck,
        bool realistic,
        string calldata notes
    ) external onlyOverseer {
        covenantCount++;
        targets[covenantCount] = WorkTarget({
            id: covenantCount,
            description: description,
            maxHours: maxHours,
            dignityCheck: dignityCheck,
            realistic: realistic,
            notes: notes,
            timestamp: block.timestamp
        });
        emit TargetLogged(covenantCount, description, maxHours, dignityCheck, realistic, notes);
    }

    /// @notice Governance rule: if maxHours > 60 per week or dignityCheck == false, mark as burnout risk
    function isBurnoutRisk(uint256 id) external view returns (bool) {
        WorkTarget memory t = targets[id];
        return (t.maxHours > 60 || !t.dignityCheck);
    }
}
