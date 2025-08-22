// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title JuniorStewardshipClause
/// @notice Protects junior developers from AI replacement; encodes collaborative workflows
contract JuniorStewardshipClause {
    address public steward;
    mapping(address => bool) public juniorStewards;
    mapping(address => string) public assignedRole;
    mapping(address => bool) public aiAgents;

    event StewardOnboarded(address indexed junior, string role);
    event AIAgentAssigned(address indexed agent, string task);
    event CollaborationLogged(address indexed junior, address indexed agent, string task);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function onboardJunior(address _junior, string memory _role) public onlySteward {
        juniorStewards[_junior] = true;
        assignedRole[_junior] = _role;
        emit StewardOnboarded(_junior, _role);
    }

    function assignAIAgent(address _agent, string memory _task) public onlySteward {
        aiAgents[_agent] = true;
        emit AIAgentAssigned(_agent, _task);
    }

    function logCollaboration(address _junior, address _agent, string memory _task) public onlySteward {
        require(juniorStewards[_junior], "Junior not onboarded");
        require(aiAgents[_agent], "AI agent not assigned");
        emit CollaborationLogged(_junior, _agent, _task);
    }

    function getRole(address _junior) public view returns (string memory) {
        require(juniorStewards[_junior], "Not a junior steward");
        return assignedRole[_junior];
    }
}
