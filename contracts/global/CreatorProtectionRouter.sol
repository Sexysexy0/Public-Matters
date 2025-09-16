// SPDX-License-Identifier: CreatorSanctum
pragma solidity ^0.8.19;

contract CreatorProtectionRouter {
    struct ProtectionSignal {
        string creatorID;
        string creationType; // e.g., "Invention", "Design", "Protocol", "Media"
        string IPTag;        // e.g., "NFT", "License", "Watermark", "Timestamp"
        bool verified;
        string stewardNote;
    }

    mapping(string => ProtectionSignal) public protectionRegistry;

    event ProtectionTagged(string creatorID, string creationType);
    event ProtectionVerified(string creatorID);

    function tagProtection(string memory creatorID, string memory creationType, string memory IPTag, string memory stewardNote) public {
        protectionRegistry[creatorID] = ProtectionSignal(creatorID, creationType, IPTag, false, stewardNote);
        emit ProtectionTagged(creatorID, creationType);
    }

    function verifyProtection(string memory creatorID) public {
        require(bytes(protectionRegistry[creatorID].creatorID).length > 0, "Creator not tagged");
        protectionRegistry[creatorID].verified = true;
        emit ProtectionVerified(creatorID);
    }

    function getProtectionStatus(string memory creatorID) public view returns (ProtectionSignal memory) {
        return protectionRegistry[creatorID];
    }
}
