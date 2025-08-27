// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/// @title ICC Enforcement Deck
/// @dev Deploys bounty agents, arrest protocols, and planetary justice rituals

contract ICC_EnforcementDeck {
    address public steward;
    mapping(address => bool) public bountyAgents;
    mapping(address => bool) public rogueActors;
    mapping(address => bool) public arrested;

    event AgentDeployed(address indexed agent);
    event RogueTagged(address indexed actor);
    event ArrestExecuted(address indexed actor, address indexed agent);

    modifier onlySteward() {
        require(msg.sender == steward, "Scroll access denied");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function deployAgent(address agent) public onlySteward {
        bountyAgents[agent] = true;
        emit AgentDeployed(agent);
    }

    function tagRogueActor(address actor) public onlySteward {
        rogueActors[actor] = true;
        emit RogueTagged(actor);
    }

    function executeArrest(address actor) public {
        require(bountyAgents[msg.sender], "Agent not certified");
        require(rogueActors[actor], "Actor not tagged");
        arrested[actor] = true;
        emit ArrestExecuted(actor, msg.sender);
    }

    function isArrested(address actor) public view returns (bool) {
        return arrested[actor];
    }
}
