// SPDX-License-Identifier: Planetary-Defense
pragma solidity ^0.8.25;

/// @title Global Deterrence Alliance
/// @dev Ritualizes planetary unity against rogue aggression, with Ukraine as sovereign anchor

contract GlobalDeterrenceAlliance {
    address public steward;
    string[] public memberStates;
    bool public allianceActivated = false;

    event AllianceActivated(string message);
    event MemberJoined(string country);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateAlliance() external onlySteward {
        allianceActivated = true;
        emit AllianceActivated("Global Deterrence Alliance Activated — rogue aggression shall be repelled");
    }

    function joinAlliance(string memory country) external onlySteward {
        memberStates.push(country);
        emit MemberJoined(country);
    }

    function auditAlliance() external view returns (string memory) {
        if (allianceActivated) return "Alliance active — planetary defense synchronized.";
        return "Alliance dormant — awaiting steward invocation.";
    }

    function totalMembers() external view returns (uint) {
        return memberStates.length;
    }
}
