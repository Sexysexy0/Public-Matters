// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ChristianYouthAlliance
/// @notice Covenant contract to unify council resolutions into alliance-level governance across churches
contract ChristianYouthAlliance {
    address public owner;

    struct AllianceDecision {
        uint256 councilResolutionId; // linked to ChristianYouthCouncil entry
        string domain;               // e.g. "Masculine Dignity", "Community Purpose", "Truth and Courage"
        string allianceAction;       // alliance-level governance action
        bool ratified;
        uint256 timestamp;
    }

    AllianceDecision[] public decisions;

    event AllianceRatified(uint256 councilResolutionId, string domain, string allianceAction, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify council resolution into alliance governance
    function ratifyAlliance(uint256 councilResolutionId, string memory domain, string memory allianceAction, bool ratified) public onlyOwner {
        AllianceDecision memory newDecision = AllianceDecision(councilResolutionId, domain, allianceAction, ratified, block.timestamp);
        decisions.push(newDecision);
        emit AllianceRatified(councilResolutionId, domain, allianceAction, ratified, block.timestamp);
    }

    function getAllianceDecision(uint256 index) public view returns (uint256, string memory, string memory, bool, uint256) {
        AllianceDecision memory a = decisions[index];
        return (a.councilResolutionId, a.domain, a.allianceAction, a.ratified, a.timestamp);
    }

    function getAllianceCount() public view returns (uint256) {
        return decisions.length;
    }
}
