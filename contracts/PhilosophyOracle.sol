// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PhilosophyOracle
/// @notice Oracle contract feeding scholarly sources into PhilosophyBridge
/// @dev Provides external academic data for enriched governance decisions

interface IPhilosophyBridge {
    function flagAndPropose(string calldata category, string calldata details, string calldata action) external;
    function executeAndArchive(uint256 proposalId, string calldata content) external;
    function clearAndArchive(uint256 id, string calldata content) external;
}

contract PhilosophyOracle {
    address public curator;
    IPhilosophyBridge public bridge;
    uint256 public feedCount;

    struct ScholarlyFeed {
        uint256 id;
        string source;   // e.g., "Alexander Lee", "John McCormick"
        string citation; // e.g., "Discourses on Livy analysis"
        uint256 timestamp;
    }

    mapping(uint256 => ScholarlyFeed) public feeds;

    event FeedLogged(uint256 id, string source, string citation, uint256 timestamp);
    event FeedApplied(uint256 id, string action, uint256 timestamp);

    modifier onlyCurator() {
        require(msg.sender == curator, "Not authorized");
        _;
    }

    constructor(address _curator, address _bridge) {
        curator = _curator;
        bridge = IPhilosophyBridge(_bridge);
        feedCount = 0;
    }

    /// @notice Log a new scholarly feed
    function logFeed(string calldata source, string calldata citation) external onlyCurator {
        feedCount++;
        feeds[feedCount] = ScholarlyFeed(feedCount, source, citation, block.timestamp);
        emit FeedLogged(feedCount, source, citation, block.timestamp);
    }

    /// @notice Apply a scholarly feed to governance bridge
    function applyFeed(uint256 id, string calldata category, string calldata details, string calldata action) external onlyCurator {
        require(bytes(feeds[id].citation).length > 0, "Feed not found");
        bridge.flagAndPropose(category, details, action);
        emit FeedApplied(id, action, block.timestamp);
    }
}
