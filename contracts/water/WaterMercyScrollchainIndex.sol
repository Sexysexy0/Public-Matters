// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Water Mercy Scrollchain Index – Hydration Scroll Registry
/// @author Vinvin Gueco
/// @notice Tracks all deployed Water Mercy Acts for civic discoverability and planetary resonance
contract WaterMercyScrollchainIndex {
    struct ScrollEntry {
        string scrollId;
        string title;
        string location;
        string author;
        string repoPath;
        uint256 timestamp;
    }

    ScrollEntry[] public scrolls;

    event ScrollRegistered(string scrollId, string location, string title);

    function registerScroll(
        string memory scrollId,
        string memory title,
        string memory location,
        string memory author,
        string memory repoPath
    ) external {
        scrolls.push(ScrollEntry({
            scrollId: scrollId,
            title: title,
            location: location,
            author: author,
            repoPath: repoPath,
            timestamp: block.timestamp
        }));
        emit ScrollRegistered(scrollId, location, title);
    }

    function getScrollCount() external view returns (uint256) {
        return scrolls.length;
    }

    function getScroll(uint256 index) external view returns (ScrollEntry memory) {
        require(index < scrolls.length, "Index out of bounds");
        return scrolls[index];
    }
}
