// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AgentPermissionsManager
 * @notice On-chain firewall for AI Agents. Restricts the financial/state 
 *         impact an agent can have over a specific timeframe.
 */
contract AgentPermissionsManager {
    OperatorPrivileges public immutable privileges;

    struct AgentLimits {
        uint256 maxPerTx;
        uint256 maxPerDay;
        uint256 currentDaySpent;
        uint256 lastResetTime;
        bool isRegistered;
    }

    mapping(address => AgentLimits) public limits;

    event AgentRegistered(address indexed agent, uint256 maxPerTx, uint256 maxPerDay);
    event AgentLimitsUpdated(address indexed agent, uint256 maxPerTx, uint256 maxPerDay);
    event AgentDeregistered(address indexed agent);
    event ActionValidated(address indexed agent, uint256 amount);
    event AgentBlocked(address indexed agent, uint256 requested, uint256 allowed);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function setAgentLimits(address agent, uint256 maxPerTx, uint256 maxPerDay) external onlyOperator {
        require(agent != address(0), "agent=0");
        limits[agent] = AgentLimits({
            maxPerTx: maxPerTx,
            maxPerDay: maxPerDay,
            currentDaySpent: 0,
            lastResetTime: block.timestamp,
            isRegistered: true
        });
        emit AgentRegistered(agent, maxPerTx, maxPerDay);
    }

    function removeAgent(address agent) external onlyOperator {
        require(limits[agent].isRegistered, "Agent not registered");
        delete limits[agent];
        emit AgentDeregistered(agent);
    }

    /**
     * @notice Called before an agent executes a high-impact action (e.g. transfer).
     * @dev Reverts if the agent exceeds its daily or per-tx limits.
     */
    function validateAction(address agent, uint256 amount) external {
        AgentLimits storage al = limits[agent];
        require(al.isRegistered, "Agent not registered");

        // Reset daily limit if 24 hours have passed
        if (block.timestamp >= al.lastResetTime + 24 hours) {
            al.currentDaySpent = 0;
            al.lastResetTime = block.timestamp;
        }

        if (amount > al.maxPerTx) {
            emit AgentBlocked(agent, amount, al.maxPerTx);
            revert("Exceeds max per-tx limit");
        }

        if (al.currentDaySpent + amount > al.maxPerDay) {
            emit AgentBlocked(agent, al.currentDaySpent + amount, al.maxPerDay);
            revert("Exceeds max daily limit");
        }

        al.currentDaySpent += amount;
        emit ActionValidated(agent, amount);
    }

    function getAgentLimits(address agent) external view returns (AgentLimits memory) {
        return limits[agent];
    }

    function getAgentStatus(address agent) external view returns (uint256 spent, uint256 remaining) {
        AgentLimits memory al = limits[agent];
        if (!al.isRegistered) return (0, 0);
        
        uint256 currentSpent = al.currentDaySpent;
        if (block.timestamp >= al.lastResetTime + 24 hours) {
            currentSpent = 0;
        }
        return (currentSpent, al.maxPerDay - currentSpent);
    }
}
