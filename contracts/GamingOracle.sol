// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GamingOracle
/// @notice Oracle contract feeding external industry sources into GamingBridge
/// @dev Provides financial, consumer, and legal data for enriched governance decisions

interface IGamingBridge {
    function logAndPropose(string calldata category, string calldata details, string calldata action) external;
    function executeAndArchive(uint256 proposalId, string calldata content) external;
    function clearAndArchive(uint256 id, string calldata content) external;
}

contract GamingOracle {
    address public curator;
    IGamingBridge public bridge;
    uint256 public feedCount;

    struct IndustryFeed {
        uint256 id;
        string source;   // e.g., "Financial Report", "Consumer Study", "Legal Ruling"
        string citation; // e.g., "Ubisoft FY2026 Losses", "UC Berkeley Gamer Study"
        uint256 timestamp;
    }

    mapping(uint256 => IndustryFeed) public feeds;

    event FeedLogged(uint256 id, string source, string citation, uint256 timestamp);
    event FeedApplied(uint256 id, string action, uint256 timestamp);

    modifier onlyCurator() {
        require(msg.sender == curator, "Not authorized");
        _;
    }

    constructor(address _curator, address _bridge) {
        curator = _curator;
        bridge = IGamingBridge(_bridge);
        feedCount = 0;
    }

    /// @notice Log a new industry feed
    function logFeed(string calldata source, string calldata citation) external onlyCurator {
        feedCount++;
        feeds[feedCount] = IndustryFeed(feedCount, source, citation, block.timestamp);
        emit FeedLogged(feedCount, source, citation, block.timestamp);
    }

    /// @notice Apply a feed to governance bridge
    function applyFeed(uint256 id, string calldata category, string calldata details, string calldata action) external onlyCurator {
        require(bytes(feeds[id].citation).length > 0, "Feed not found");
        bridge.logAndPropose(category, details, action);
        emit FeedApplied(id, action, block.timestamp);
    }
}
