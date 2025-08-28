// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.28;

/// @title GlobalDeterrenceAlliance
/// @notice Ritualizes planetary defense pact against rogue state aggression
contract GlobalDeterrenceAlliance {
    address public steward;
    mapping(address => bool) public rogueActors;
    mapping(address => bool) public alliedNations;
    mapping(address => bool) public civilianSanctuaries;

    event RogueActorTagged(address indexed actor, string reason);
    event AllianceActivated(address indexed nation, string purpose);
    event CivilianSanctuaryDeclared(address indexed region, string protocol);
    event DeterrenceBroadcasted(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function tagRogueActor(address actor, string memory reason) public onlySteward {
        rogueActors[actor] = true;
        emit RogueActorTagged(actor, reason);
    }

    function activateAlliance(address nation, string memory purpose) public onlySteward {
        alliedNations[nation] = true;
        emit AllianceActivated(nation, purpose);
    }

    function declareCivilianSanctuary(address region, string memory protocol) public onlySteward {
        civilianSanctuaries[region] = true;
        emit CivilianSanctuaryDeclared(region, protocol);
    }

    function broadcastDeterrence(string memory message) public onlySteward {
        emit DeterrenceBroadcasted(message);
    }

    function isRogue(address actor) public view returns (bool) {
        return rogueActors[actor];
    }

    function isAlly(address nation) public view returns (bool) {
        return alliedNations[nation];
    }

    function isSanctuary(address region) public view returns (bool) {
        return civilianSanctuaries[region];
    }
}
