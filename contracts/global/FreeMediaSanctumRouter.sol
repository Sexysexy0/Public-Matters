// SPDX-License-Identifier: FreeSanctum
pragma solidity ^0.8.19;

contract FreeMediaSanctumRouter {
    struct MediaContent {
        string platform;
        string contentType; // e.g., "Reel", "Livestream", "Short Film"
        string title;
        string url;
        bool verified;
        bool civicTagged;
    }

    mapping(bytes32 => MediaContent) public mediaRegistry;

    event ContentRegistered(string platform, string title);
    event ContentVerified(string title);
    event CivicTagged(string title);

    function registerContent(string memory platform, string memory contentType, string memory title, string memory url) public {
        bytes32 contentId = keccak256(abi.encodePacked(platform, title, block.timestamp));
        mediaRegistry[contentId] = MediaContent(platform, contentType, title, url, false, false);
        emit ContentRegistered(platform, title);
    }

    function verifyContent(string memory platform, string memory title) public {
        bytes32 contentId = keccak256(abi.encodePacked(platform, title, block.timestamp));
        mediaRegistry[contentId].verified = true;
        emit ContentVerified(title);
    }

    function tagCivicContent(string memory platform, string memory title) public {
        bytes32 contentId = keccak256(abi.encodePacked(platform, title, block.timestamp));
        mediaRegistry[contentId].civicTagged = true;
        emit CivicTagged(title);
    }

    function getContentStatus(string memory platform, string memory title) public view returns (MediaContent memory) {
        bytes32 contentId = keccak256(abi.encodePacked(platform, title, block.timestamp));
        return mediaRegistry[contentId];
    }
}
