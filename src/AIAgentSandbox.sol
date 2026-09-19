// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentSandbox
 * @notice On-chain sandbox isolation for AI agents before production access.
 *         Directly addresses the "agent escaped sandbox" failure mode.
 */
contract AIAgentSandbox {
    OperatorPrivileges public privileges;

    enum SandboxStatus { NONE, TESTING, PASSED, FAILED }

    struct Sandbox {
        bytes32 agentId;
        SandboxStatus status;
        uint256 enteredAt;
        uint256 exitedAt;
        uint256 actionsPerformed;
        uint256 maxActions;
        uint256 maxValue;
        uint256 valueUsed;
        string failureReason;
        address approvedBy;
    }

    mapping(bytes32 => Sandbox) internal _sandboxes;
    bytes32[] public sandboxedAgents;
    mapping(bytes32 => bool) public isTracked;

    event SandboxEntered(bytes32 indexed agentId, uint256 timestamp, uint256 maxActions, uint256 maxValue);
    event SandboxExited(bytes32 indexed agentId, bool passed, string reason, address approver, uint256 timestamp);
    event SandboxLimitsUpdated(bytes32 indexed agentId, uint256 maxActions, uint256 maxValue);
    event SandboxActionRecorded(bytes32 indexed agentId, uint256 totalActions, uint256 valueUsed);
    event SandboxLimitExceeded(bytes32 indexed agentId, string limitType);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function enterSandbox(bytes32 agentId, uint256 maxActions, uint256 maxValue) external onlyOperator {
        require(_sandboxes[agentId].status != SandboxStatus.TESTING, "Agent already in sandbox");
        require(maxActions > 0, "Max actions must be > 0");

        _sandboxes[agentId] = Sandbox({
            agentId: agentId,
            status: SandboxStatus.TESTING,
            enteredAt: block.timestamp,
            exitedAt: 0,
            actionsPerformed: 0,
            maxActions: maxActions,
            maxValue: maxValue,
            valueUsed: 0,
            failureReason: "",
            approvedBy: address(0)
        });

        if (!isTracked[agentId]) {
            sandboxedAgents.push(agentId);
            isTracked[agentId] = true;
        }

        emit SandboxEntered(agentId, block.timestamp, maxActions, maxValue);
    }

    function exitSandbox(bytes32 agentId, bool passed, string calldata reason) external onlyOperator {
        require(_sandboxes[agentId].status == SandboxStatus.TESTING, "Agent not in sandbox");

        Sandbox storage s = _sandboxes[agentId];
        s.status = passed ? SandboxStatus.PASSED : SandboxStatus.FAILED;
        s.exitedAt = block.timestamp;
        s.failureReason = reason;
        s.approvedBy = msg.sender;

        emit SandboxExited(agentId, passed, reason, msg.sender, block.timestamp);
    }

    function recordSandboxAction(bytes32 agentId, uint256 value) external onlyOperator {
        Sandbox storage s = _sandboxes[agentId];
        require(s.status == SandboxStatus.TESTING, "Agent not in sandbox testing");

        s.actionsPerformed++;
        s.valueUsed += value;

        if (s.actionsPerformed > s.maxActions) {
            emit SandboxLimitExceeded(agentId, "actions");
            s.status = SandboxStatus.FAILED;
            s.failureReason = "Exceeded action limit";
            return;
        }

        if (s.maxValue > 0 && s.valueUsed > s.maxValue) {
            emit SandboxLimitExceeded(agentId, "value");
            s.status = SandboxStatus.FAILED;
            s.failureReason = "Exceeded value limit";
            return;
        }

        emit SandboxActionRecorded(agentId, s.actionsPerformed, s.valueUsed);
    }

    function updateSandboxLimits(bytes32 agentId, uint256 maxActions, uint256 maxValue) external onlyOperator {
        require(_sandboxes[agentId].status == SandboxStatus.TESTING, "Agent not in sandbox testing");
        require(maxActions > 0, "Max actions must be > 0");

        _sandboxes[agentId].maxActions = maxActions;
        _sandboxes[agentId].maxValue = maxValue;

        emit SandboxLimitsUpdated(agentId, maxActions, maxValue);
    }

    function isSandboxed(bytes32 agentId) external view returns (bool) {
        return _sandboxes[agentId].status == SandboxStatus.TESTING;
    }

    function hasPassedSandbox(bytes32 agentId) external view returns (bool) {
        return _sandboxes[agentId].status == SandboxStatus.PASSED;
    }

    function getSandbox(bytes32 agentId) external view returns (Sandbox memory) {
        return _sandboxes[agentId];
    }

    function totalSandboxed() external view returns (uint256) {
        return sandboxedAgents.length;
    }
}
