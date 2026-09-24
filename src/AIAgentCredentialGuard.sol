// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIAgentCredentialGuard
 * @notice On-chain tracking of authentication attempts per AI agent.
 *         Enforces rate limits and automatic lockout when thresholds
 *         are exceeded.
 *
 *         Directly addresses: Gemini credential guessing attack (2026-09-19)
 *
 *         Every login attempt is logged. Failed attempts in a rolling
 *         window trigger lockout. Lockout requires operator intervention
 *         to clear.
 */
contract AIAgentCredentialGuard {
    OperatorPrivilegesV2 public privileges;

    struct Config {
        uint256 maxFailedAttempts;
        uint256 windowSize;
        uint256 lockoutDuration;
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
    }

    mapping(bytes32 => Config) internal _configs;
    mapping(bytes32 => AuthWindow) internal _windows;
    mapping(bytes32 => Lockout) internal _lockouts;
    mapping(bytes32 => uint256) public totalAttempts;
    mapping(bytes32 => uint256) public totalFailedAttempts;
    mapping(bytes32 => uint256) public lockoutCount;

    bytes32[] public trackedAgents;
    mapping(bytes32 => bool) public isTracked;

    event AgentTracked(bytes32 indexed agentId);
    event ConfigSet(bytes32 indexed agentId, uint256 maxFailed, uint256 windowSize, uint256 lockoutDuration);
    event AuthAttemptRecorded(
        bytes32 indexed agentId,
        bytes32 indexed targetSystem,
        bool success,
        uint256 failedThisWindow,
        uint256 successThisWindow
    );
    event AgentLockedOut(bytes32 indexed agentId, bytes32 reason, uint256 until, address lockedBy);
    event LockoutCleared(bytes32 indexed agentId, address clearedBy);
    event ThresholdExceeded(bytes32 indexed agentId, uint256 failedCount, uint256 maxAllowed);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── CONFIG ───

    function setConfig(bytes32 agentId, uint256 maxFailedAttempts, uint256 windowSize, uint256 lockoutDuration)
        external
        onlyOperator
    {
        require(windowSize > 0, "Window must be > 0");
        require(maxFailedAttempts > 0, "Max failed must be > 0");
        require(lockoutDuration > 0, "Lockout duration must be > 0");

        _configs[agentId] = Config({
            maxFailedAttempts: maxFailedAttempts, windowSize: windowSize, lockoutDuration: lockoutDuration, set: true
        });

        if (!isTracked[agentId]) {
            trackedAgents.push(agentId);
            isTracked[agentId] = true;
            emit AgentTracked(agentId);
        }

        emit ConfigSet(agentId, maxFailedAttempts, windowSize, lockoutDuration);
    }

    // ─── ATTEMPT RECORDING ───

    function recordAuthAttempt(bytes32 agentId, bytes32 targetSystem, bool success) external onlyOperator {
        Config storage c = _configs[agentId];
        require(c.set, "Config not set");
        require(!_lockouts[agentId].active, "Agent is locked out");

        AuthWindow storage w = _windows[agentId];

        // Reset window if expired
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

        emit AuthAttemptRecorded(agentId, targetSystem, success, w.failedCount, w.successCount);

        // Check threshold
        if (w.failedCount > c.maxFailedAttempts) {
            emit ThresholdExceeded(agentId, w.failedCount, c.maxFailedAttempts);
            _lockout(agentId, keccak256("threshold exceeded"), c.lockoutDuration, msg.sender);
        }
    }

    // ─── LOCKOUT ───

    function forceLockout(bytes32 agentId, bytes32 reason, uint256 duration) external onlyOperator {
        require(isTracked[agentId], "Agent not tracked");
        _lockout(agentId, reason, duration, msg.sender);
    }

    function _lockout(bytes32 agentId, bytes32 reason, uint256 duration, address by) internal {
        _lockouts[agentId] = Lockout({active: true, until: block.timestamp + duration, reason: reason, lockedBy: by});
        lockoutCount[agentId]++;
        emit AgentLockedOut(agentId, reason, block.timestamp + duration, by);
    }

    function clearLockout(bytes32 agentId) external onlyOperator {
        require(_lockouts[agentId].active, "Not locked out");
        _lockouts[agentId].active = false;
        _lockouts[agentId].until = 0;
        _lockouts[agentId].reason = bytes32(0);
        _lockouts[agentId].lockedBy = address(0);

        // Reset window
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

    function getFailedAttemptsThisWindow(bytes32 agentId) external view returns (uint256) {
        return _windows[agentId].failedCount;
    }

    function getStats(bytes32 agentId)
        external
        view
        returns (uint256 total, uint256 failed, uint256 locks, bool currentlyLocked)
    {
        Lockout storage l = _lockouts[agentId];
        bool locked = l.active && block.timestamp < l.until;
        return (totalAttempts[agentId], totalFailedAttempts[agentId], lockoutCount[agentId], locked);
    }

    function totalTracked() external view returns (uint256) {
        return trackedAgents.length;
    }
}
