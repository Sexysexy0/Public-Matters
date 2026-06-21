// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PersonalLegacyCodex
/// @notice Codex covenant to encode Vinvin's personal milestones and achievements
contract PersonalLegacyCodex {
    address public overseer;
    uint256 public milestoneCount;

    struct MilestoneRecord {
        uint256 id;
        string nickname;   // Unknown, No Name, Unlocked Character
        string achievement; // industry, university, leadership, business expansion
        string source;     // institution, company, project
        string safeguard;  // authorship clause, equity clause
        uint256 timestamp;
    }

    mapping(uint256 => MilestoneRecord) public records;

    event MilestoneLogged(uint256 indexed id, string nickname, string achievement);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs personal milestone record
    function logMilestone(string calldata nickname, string calldata achievement, string calldata source, string calldata safeguard) external onlyOverseer {
        milestoneCount++;
        records[milestoneCount] = MilestoneRecord({
            id: milestoneCount,
            nickname: nickname,
            achievement: achievement,
            source: source,
            safeguard: safeguard,
            timestamp: block.timestamp
        });
        emit MilestoneLogged(milestoneCount, nickname, achievement);
    }

    /// @notice Citizens can view milestone records
    function viewMilestone(uint256 id) external view returns (MilestoneRecord memory) {
        return records[id];
    }
}
