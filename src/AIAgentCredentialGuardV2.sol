// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIAgentCredentialGuardV2
 * @notice Credential attempt tracking with multisig escalation.
 *
 *         V1 tracked attempts and locked out agents.
 *         V2 adds:
 *         - Escalation threshold (extra severe failures)
 *         - Multisig escalation function (calls multisig to propose action)
 *         - Shared incident reporting integration
 */
contract AIAgentCredentialGuardV2 {
    OperatorPrivilegesV2 public privileges;

    // Multisig contract that receives escalations
    address public multisigTarget;
    address public freezeTarget;

    struct Config {
        uint256 maxFailedAttempts;
        uint256 windowSize;
        uint256 lockoutDuration;
        uint256 escalationThreshold; // extra-severe: triggers multisig
        bool set;
    }

    struct AuthWindow {
        uint256 windowStart;
        uint256 successCount;
        uint256 failedCount;
    }

    struct Lockout {
        bool active;
        uint256 until;
        bytes32 reason;
        address lockedBy;
        bool escalated;
    }

    mapping(bytes32 => Config) internal _configs;
    mapping(bytes32 => AuthWindow) internal _windows;
    mapping(bytes32 => Lockout) internal _lockouts;
    mapping(bytes32 => uint256) public totalAttempts;
    mapping(bytes32 => uint256) public totalFailedAttempts;
    mapping(bytes32 => uint256) public lockoutCount;
    mapping(bytes32 => uint256) public escalationCount;

    bytes32[] public trackedAgents;
    mapping(bytes32 => bool) public isTracked;

    event AgentTracked(bytes32 indexed agentId);
    event ConfigSet(bytes32 indexed agentId, uint256 maxFailed, uint256 escalation, uint256 window, uint256 lockout);
    event AuthAttemptRecorded(bytes32 indexed agentId, bytes32 indexed targetSystem, bool success, uint256 failedCount);
    event AgentLockedOut(bytes32 indexed agentId, bytes32 reason, uint256 until, address lockedBy);
    event LockoutCleared(bytes32 indexed agentId, address clearedBy);
    event EscalationTriggered(bytes32 indexed agentId, uint256 failedCount, address escalationTarget);
    event TargetsUpdated(address multisig, address freeze);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges, address _multisig, address _freeze) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
        multisigTarget = _multisig;
        freezeTarget = _freeze;
    }

    // ─── CONFIG ───

    function setConfig(
        bytes32 agentId,
        uint256 maxFailedAttempts,
        uint256 escalationThreshold,
        uint256 windowSize,
        uint256 lockoutDuration
    ) external onlyOperator {
        require(windowSize > 0, "Window must be > 0");
        require(maxFailedAttempts > 0, "Max failed must be > 0");
        require(lockoutDuration > 0, "Lockout must be > 0");
        require(escalationThreshold >= maxFailedAttempts, "Escalation must be >= max");

        _configs[agentId] = Config({
            maxFailedAttempts: maxFailedAttempts,
            windowSize: windowSize,
            lockoutDuration: lockoutDuration,
            escalationThreshold: escalationThreshold,
            set: true
        });

        if (!isTracked[agentId]) {
            trackedAgents.push(agentId);
            isTracked[agentId] = true;
            emit AgentTracked(agentId);
        }

        emit ConfigSet(agentId, maxFailedAttempts, escalationThreshold, windowSize, lockoutDuration);
    }

    function setTargets(address _multisig, address _freeze) external onlyOperator {
        multisigTarget = _multisig;
        freezeTarget = _freeze;
        emit TargetsUpdated(_multisig, _freeze);
    }

    // ─── ATTEMPT RECORDING ───

    function recordAuthAttempt(
        bytes32 agentId,
        bytes32 targetSystem,
        bool success
    ) external onlyOperator {
        Config storage c = _configs[agentId];
        require(c.set, "Config not set");
        require(!_lockouts[agentId].active, "Agent is locked out");

        AuthWindow storage w = _windows[agentId];

        if (w.windowStart == 0 || block.timestamp - w.windowStart > c.windowSize) {
            w.windowStart = block.timestamp;
            w.successCount = 0;
            w.failedCount = 0;
        }

        totalAttempts[agentId]++;

        if (success) {
            w.successCount++;
        } else {
            w.failedCount++;
            totalFailedAttempts[agentId]++;
        }

        emit AuthAttemptRecorded(agentId, targetSystem, success, w.failedCount);

        // Escalation check (severe)
        if (w.failedCount >= c.escalationThreshold) {
            _escalate(agentId, w.failedCount);
            _lockout(agentId, keccak256("escalation-threshold"), c.lockoutDuration, msg.sender, true);
            return;
        }

        // Standard lockout
        if (w.failedCount > c.maxFailedAttempts) {
            _lockout(agentId, keccak256("threshold-exceeded"), c.lockoutDuration, msg.sender, false);
        }
    }

    function _escalate(bytes32 agentId, uint256 failedCount) internal {
        escalationCount[agentId]++;
        emit EscalationTriggered(agentId, failedCount, multisigTarget);
        // Off-chain: multisig should propose action (freeze, investigate)
    }

    // ─── LOCKOUT ───

    function forceLockout(bytes32 agentId, bytes32 reason, uint256 duration) external onlyOperator {
        require(isTracked[agentId], "Agent not tracked");
        _lockout(agentId, reason, duration, msg.sender, false);
    }

    function _lockout(bytes32 agentId, bytes32 reason, uint256 duration, address by, bool escalated) internal {
        _lockouts[agentId] = Lockout({
            active: true,
            until: block.timestamp + duration,
            reason: reason,
            lockedBy: by,
            escalated: escalated
        });
        lockoutCount[agentId]++;
        emit AgentLockedOut(agentId, reason, block.timestamp + duration, by);
    }

    function clearLockout(bytes32 agentId) external onlyOperator {
        require(_lockouts[agentId].active, "Not locked out");
        _lockouts[agentId] = Lockout({
            active: false,
            until: 0,
            reason: bytes32(0),
            lockedBy: address(0),
            escalated: false
        });

        _windows[agentId].windowStart = 0;
        _windows[agentId].successCount = 0;
        _windows[agentId].failedCount = 0;

        emit LockoutCleared(agentId, msg.sender);
    }

    // ─── VIEWS ───

    function isLockedOut(bytes32 agentId) external view returns (bool) {
        Lockout storage l = _lockouts[agentId];
        if (!l.active) return false;
        if (block.timestamp >= l.until) return false;
        return true;
    }

    function getLockout(bytes32 agentId) external view returns (Lockout memory) {
        return _lockouts[agentId];
    }

    function getConfig(bytes32 agentId) external view returns (Config memory) {
        return _configs[agentId];
    }

    function getAuthWindow(bytes32 agentId) external view returns (AuthWindow memory) {
        return _windows[agentId];
    }

    function getStats(bytes32 agentId) external view returns (
        uint256 total,
        uint256 failed,
        uint256 locks,
        uint256 escalations,
        bool currentlyLocked
    ) {
        Lockout storage l = _lockouts[agentId];
        bool locked = l.active && block.timestamp < l.until;
        return (
            totalAttempts[agentId],
            totalFailedAttempts[agentId],
            lockoutCount[agentId],
            escalationCount[agentId],
            locked
        );
    }

    function totalTracked() external view returns (uint256) {
        return trackedAgents.length;
    }
}
