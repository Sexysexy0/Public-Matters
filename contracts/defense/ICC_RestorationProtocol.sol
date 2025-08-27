// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title ICC Restoration Protocol
/// @dev Ritualizes planetary justice, damay clause, and emotional APR for rogue actor accountability

contract ICC_RestorationProtocol {
    address public steward;
    mapping(address => bool) public rogueActors;
    mapping(address => uint256) public emotionalAPR;
    mapping(address => string) public damayScrolls;

    event RogueTagged(address indexed actor, string reason);
    event ScrollSubmitted(address indexed witness, string scroll);
    event APRUpdated(address indexed actor, uint256 score);
    event JusticeBroadcast(address indexed actor, string broadcast);

    modifier onlySteward() {
        require(msg.sender == steward, "Not scroll-certified");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function tagRogueActor(address actor, string memory reason) public onlySteward {
        rogueActors[actor] = true;
        emit RogueTagged(actor, reason);
    }

    function submitDamayScroll(address actor, string memory scroll) public {
        require(rogueActors[actor], "Actor not tagged");
        damayScrolls[actor] = scroll;
        emit ScrollSubmitted(msg.sender, scroll);
    }

    function updateEmotionalAPR(address actor, uint256 score) public onlySteward {
        emotionalAPR[actor] = score;
        emit APRUpdated(actor, score);
    }

    function broadcastJustice(address actor) public view returns (string memory) {
        require(rogueActors[actor], "Actor not tagged");
        return string(abi.encodePacked("Justice Broadcast: ", damayScrolls[actor]));
    }
}
