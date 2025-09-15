// SPDX-License-Identifier: CivicSanctum
pragma solidity ^0.8.19;

contract CivicImaginationRouter {
    struct CivicVision {
        string stewardName;
        string visionTitle;
        string description;
        string domain; // e.g., "Education", "Governance", "Media", "Culture"
        bool tagged;
        bool broadcasted;
    }

    mapping(bytes32 => CivicVision) public visions;

    event VisionRegistered(string stewardName, string visionTitle);
    event VisionTagged(string visionTitle);
    event VisionBroadcasted(string visionTitle);

    function registerVision(string memory stewardName, string memory visionTitle, string memory description, string memory domain) public {
        bytes32 visionId = keccak256(abi.encodePacked(stewardName, visionTitle, block.timestamp));
        visions[visionId] = CivicVision(stewardName, visionTitle, description, domain, false, false);
        emit VisionRegistered(stewardName, visionTitle);
    }

    function tagVision(string memory stewardName, string memory visionTitle) public {
        bytes32 visionId = keccak256(abi.encodePacked(stewardName, visionTitle, block.timestamp));
        visions[visionId].tagged = true;
        emit VisionTagged(visionTitle);
    }

    function broadcastVision(string memory stewardName, string memory visionTitle) public {
        bytes32 visionId = keccak256(abi.encodePacked(stewardName, visionTitle, block.timestamp));
        visions[visionId].broadcasted = true;
        emit VisionBroadcasted(visionTitle);
    }

    function getVisionStatus(string memory stewardName, string memory visionTitle) public view returns (CivicVision memory) {
        bytes32 visionId = keccak256(abi.encodePacked(stewardName, visionTitle, block.timestamp));
        return visions[visionId];
    }
}
