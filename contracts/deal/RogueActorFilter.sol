// SPDX-License-Identifier: Mythic-Tag
pragma solidity ^0.8.19;

contract RogueActorFilter {
    address public steward;
    mapping(address => bool) public rogueStatus;
    mapping(address => string) public violationLog;

    event ActorFlagged(address actor, string reason);
    event ActorCleared(address actor);

    constructor() {
        steward = msg.sender;
    }

    function flagRogue(address _actor, string memory _reason) external {
        require(msg.sender == steward, "Only steward may flag rogue actors.");
        rogueStatus[_actor] = true;
        violationLog[_actor] = _reason;
        emit ActorFlagged(_actor, _reason);
    }

    function clearActor(address _actor) external {
        require(msg.sender == steward, "Only steward may clear actors.");
        rogueStatus[_actor] = false;
        violationLog[_actor] = "";
        emit ActorCleared(_actor);
    }

    function isRogue(address _actor) external view returns (bool) {
        return rogueStatus[_actor];
    }
}
