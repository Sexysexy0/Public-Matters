// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PeaceContinuity Covenant
/// @notice Encodes humanitarian continuity safeguards during conflict & aid collapse
contract PeaceContinuity {
    address public admin;
    mapping(address => bool) public reliefAgents;

    event AidDistributed(address indexed agent, uint256 amount);
    event AgentAuthorized(address indexed agent);

    constructor() {
        admin = msg.sender;
    }

    function authorizeAgent(address agent) external {
        require(msg.sender == admin, "Only admin");
        reliefAgents[agent] = true;
        emit AgentAuthorized(agent);
    }

    function distributeAid(address agent, uint256 amount) external {
        require(reliefAgents[agent], "Not authorized");
        emit AidDistributed(agent, amount);
    }
}
