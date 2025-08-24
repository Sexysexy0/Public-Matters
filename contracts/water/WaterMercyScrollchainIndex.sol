// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Scrollchain Index – Hydration Scroll Registry (Extended)
/// @author Vinvin Gueco
/// @notice Tracks all deployed Water Mercy Acts for civic discoverability, emotional APR, and planetary resonance

contract WaterMercyScrollchainIndex {
    struct ScrollEntry {
        string scrollId;
        string title;
        string location;
        string author;
        string repoPath;
        string[] tags;
        bool damayClause;
        uint256 timestamp;
    }

    ScrollEntry[] public scrolls;

    event ScrollRegistered(string scrollId, string location, string title, bool damayClause);
    event ScrollTagged(string scrollId, string[] tags);

    function registerScroll(
        string memory scrollId,
        string memory title,
        string memory location,
        string memory author,
        string memory repoPath,
        string[] memory tags,
        bool damayClause
    ) external {
        scrolls.push(ScrollEntry({
            scrollId: scrollId,
            title: title,
            location: location,
            author: author,
            repoPath: repoPath,
            tags: tags,
            damayClause: damayClause,
            timestamp: block.timestamp
        }));
        emit ScrollRegistered(scrollId, location, title, damayClause);
        emit ScrollTagged(scrollId, tags);
    }

    function getScrollCount() external view returns (uint256) {
        return scrolls.length;
    }

    function getScroll(uint256 index) external view returns (ScrollEntry memory) {
        require(index < scrolls.length, "Index out of bounds");
        return scrolls[index];
    }

    function findScrollById(string memory scrollId) external view returns (ScrollEntry memory) {
        for (uint256 i = 0; i < scrolls.length; i++) {
            if (keccak256(bytes(scrolls[i].scrollId)) == keccak256(bytes(scrollId))) {
                return scrolls[i];
            }
        }
        revert("Scroll not found");
    }

    function getAllScrolls() external view returns (ScrollEntry[] memory) {
        return scrolls;
    }
}
