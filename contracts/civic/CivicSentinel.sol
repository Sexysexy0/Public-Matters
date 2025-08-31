// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CivicSentinel {
    struct RegionFeed {
        string regionName;
        string barangay;
        string climateStatus;
        string newsHeadline;
        uint256 timestamp;
        uint256 emotionalAPR; // Emotional resonance index
    }

    mapping(bytes32 => RegionFeed) public feeds;
    event FeedUpdated(bytes32 indexed regionId, string headline, string climateStatus, uint256 emotionalAPR);

    function updateFeed(
        string memory regionName,
        string memory barangay,
        string memory climateStatus,
        string memory newsHeadline,
        uint256 emotionalAPR
    ) public {
        bytes32 regionId = keccak256(abi.encodePacked(regionName, barangay));
        feeds[regionId] = RegionFeed(regionName, barangay, climateStatus, newsHeadline, block.timestamp, emotionalAPR);
        emit FeedUpdated(regionId, newsHeadline, climateStatus, emotionalAPR);
    }

    function getFeed(string memory regionName, string memory barangay) public view returns (RegionFeed memory) {
        bytes32 regionId = keccak256(abi.encodePacked(regionName, barangay));
        return feeds[regionId];
    }
}
