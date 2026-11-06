// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentBehaviorMonitorV2
 * @notice Tracks agent activity and violations. Freezes agents that 
 *         repeatedly break rules, and flags agents that go dormant.
 */
contract AIAgentBehaviorMonitorV2 {
    OperatorPrivileges public immutable privileges;

    struct Behavior {
        uint256 lastActionAt;
        uint256 violationCount;
        uint256 maxViolations;     // Threshold before freeze
        bool frozen;
        bool registered;
    }

    mapping(address => Behavior) public behaviors;
    uint256 public inactivityThreshold; // Seconds without action before flagged as dormant

    event AgentRegistered(address indexed agent, uint256 maxViolations);
    event ActionRecorded(address indexed agent);
    event ViolationRecorded(address indexed agent, string reason, uint256 totalViolations);
    event AgentFrozen(address indexed agent);
    event AgentUnfrozen(address indexed agent);
    event DormancyFlagged(address indexed agent, uint256 lastActionAt);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, uint256 _inactivityThreshold) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
        inactivityThreshold = _inactivityThreshold;
    }

    function registerAgent(address agent, uint256 maxViolations) external onlyOperator {
        require(!behaviors[agent].registered, "Already registered");
        behaviors[agent] = Behavior({
            lastActionAt: block.timestamp,
            violationCount: 0,
            maxViolations: maxViolations,
            frozen: false,
            registered: true
        });
        emit AgentRegistered(agent, maxViolations);
    }

    /// @notice Called by the agent (or the system) whenever a valid action is taken.
    function recordAction(address agent) external {
        Behavior storage b = behaviors[agent];
        require(b.registered, "Not registered");
        require(!b.frozen, "Agent is frozen");
        
        b.lastActionAt = block.timestamp;
        emit ActionRecorded(agent);
    }

    /// @notice Called when an agent attempts a forbidden action.
    function recordViolation(address agent, string calldata reason) external onlyOperator {
        Behavior storage b = behaviors[agent];
        require(b.registered, "Not registered");
        
        b.violationCount++;
        emit ViolationRecorded(agent, reason, b.violationCount);

        // Freeze the agent if it exceeds the violation threshold
        if (b.violationCount >= b.maxViolations) {
            b.frozen = true;
            emit AgentFrozen(agent);
        }
    }

    /// @notice Operator can manually freeze or unfreeze an agent.
    function setFrozen(address agent, bool status) external onlyOperator {
        require(behaviors[agent].registered, "Not registered");
        behaviors[agent].frozen = status;
        if (status) emit AgentFrozen(agent);
        else emit AgentUnfrozen(agent);
    }

    /// @notice Check if an agent is dormant (OpenAI problem).
    function checkDormancy(address agent) external view returns (bool) {
        Behavior memory b = behaviors[agent];
        if (!b.registered || b.frozen) return false;
        return (block.timestamp > b.lastActionAt + inactivityThreshold);
    }

    function getAgentBehavior(address agent) external view returns (Behavior memory) {
        return behaviors[agent];
    }

    function isAgentSafe(address agent) external view returns (bool) {
        Behavior memory b = behaviors[agent];
        return b.registered && !b.frozen;
    }
}
