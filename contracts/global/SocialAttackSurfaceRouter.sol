// SPDX-License-Identifier: SocialAudit
pragma solidity ^0.8.19;

contract SocialAttackSurfaceRouter {
    struct UpgradeEvent {
        string upgradeName;
        string developer;
        string vulnerabilityType; // e.g., "Meme Inscriptions", "Protocol Trolling"
        bool exploited;
        string impactSummary;
        bool mitigationProposed;
    }

    mapping(bytes32 => UpgradeEvent) public events;

    event SocialSurfaceTagged(string upgradeName, string vulnerabilityType);
    event MitigationProposed(string upgradeName);

    function tagSurface(string memory upgradeName, string memory developer, string memory vulnerabilityType, bool exploited, string memory impactSummary) public {
        bytes32 eventId = keccak256(abi.encodePacked(upgradeName, vulnerabilityType, block.timestamp));
        events[eventId] = UpgradeEvent(upgradeName, developer, vulnerabilityType, exploited, impactSummary, false);
        emit SocialSurfaceTagged(upgradeName, vulnerabilityType);
    }

    function proposeMitigation(string memory upgradeName, string memory vulnerabilityType) public {
        bytes32 eventId = keccak256(abi.encodePacked(upgradeName, vulnerabilityType, block.timestamp));
        events[eventId].mitigationProposed = true;
        emit MitigationProposed(upgradeName);
    }

    function getSurfaceStatus(string memory upgradeName, string memory vulnerabilityType) public view returns (UpgradeEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(upgradeName, vulnerabilityType, block.timestamp));
        return events[eventId];
    }
}
