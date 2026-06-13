// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RespectSpaceBridge
/// @notice Bridge covenant to allocate respectable creative space per lane
contract RespectSpaceBridge {
    address public oversightCommittee;
    uint256 public bridgeCount;

    struct CreativeSpace {
        uint256 id;
        string industry;       // e.g. music, movie, anime
        string representation; // self-driven, collective, hybrid
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => CreativeSpace) public spaces;

    event SpaceAllocated(uint256 indexed id, string industry, string representation, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight allocates respectable space for creative lane
    function allocateSpace(string calldata industry, string calldata representation) external onlyOversight {
        bridgeCount++;
        spaces[bridgeCount] = CreativeSpace({
            id: bridgeCount,
            industry: industry,
            representation: representation,
            active: true,
            timestamp: block.timestamp
        });
        emit SpaceAllocated(bridgeCount, industry, representation, true);
    }

    /// @notice Oversight deactivates a creative space
    function deactivateSpace(uint256 id) external onlyOversight {
        spaces[id].active = false;
        emit SpaceAllocated(id, spaces[id].industry, spaces[id].representation, false);
    }

    /// @notice Citizens can view creative spaces
    function viewSpace(uint256 id) external view returns (CreativeSpace memory) {
        return spaces[id];
    }
}
