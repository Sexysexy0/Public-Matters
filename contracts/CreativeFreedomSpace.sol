// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CreativeFreedomSpace
/// @notice Covenant to safeguard creative freedom and remove forced lore/fake narratives
contract CreativeFreedomSpace {
    address public oversightCommittee;
    uint256 public spaceCount;

    struct CreativeLane {
        uint256 id;
        string industry;     // e.g. music, movie, anime
        string representation; // self-driven, collective, personal
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => CreativeLane) public lanes;

    event LaneCreated(uint256 indexed id, string industry, string representation, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight creates a creative lane with freedom space
    function createLane(string calldata industry, string calldata representation) external onlyOversight {
        spaceCount++;
        lanes[spaceCount] = CreativeLane({
            id: spaceCount,
            industry: industry,
            representation: representation,
            active: true,
            timestamp: block.timestamp
        });
        emit LaneCreated(spaceCount, industry, representation, true);
    }

    /// @notice Oversight deactivates a lane
    function deactivateLane(uint256 id) external onlyOversight {
        lanes[id].active = false;
        emit LaneCreated(id, lanes[id].industry, lanes[id].representation, false);
    }

    /// @notice Citizens can view creative lanes
    function viewLane(uint256 id) external view returns (CreativeLane memory) {
        return lanes[id];
    }
}
