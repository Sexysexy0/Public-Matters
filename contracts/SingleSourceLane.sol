// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SingleSourceLane
/// @notice Covenant to enforce one reliable source per industry lane
contract SingleSourceLane {
    address public oversightCommittee;
    uint256 public laneCount;

    struct LaneSource {
        uint256 id;
        string industry;    // e.g. business, movie, music, spiritual
        string source;      // reliable source identifier
        bool active;
        uint256 timestamp;
    }

    mapping(uint256 => LaneSource) public lanes;

    event SourceAssigned(uint256 indexed id, string industry, string source, bool active);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight assigns a single reliable source to an industry lane
    function assignSource(string calldata industry, string calldata source) external onlyOversight {
        laneCount++;
        lanes[laneCount] = LaneSource({
            id: laneCount,
            industry: industry,
            source: source,
            active: true,
            timestamp: block.timestamp
        });
        emit SourceAssigned(laneCount, industry, source, true);
    }

    /// @notice Oversight deactivates a source
    function deactivateSource(uint256 id) external onlyOversight {
        lanes[id].active = false;
        emit SourceAssigned(id, lanes[id].industry, lanes[id].source, false);
    }

    /// @notice Citizens can view assigned sources
    function viewSource(uint256 id) external view returns (LaneSource memory) {
        return lanes[id];
    }
}
