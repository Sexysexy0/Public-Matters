// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title AIAgentSunsetProtocol
 * @notice Graceful decommissioning of AI agents. Not a kill switch —
 *         planned retirement with grace period for handoff.
 */
contract AIAgentSunsetProtocol {
    OperatorPrivilegesV2 public privileges;

    uint256 public constant MIN_GRACE = 1 hours;
    uint256 public constant MAX_GRACE = 30 days;

    enum SunsetStatus {
        NONE,
        SCHEDULED,
        COMPLETED,
        CANCELLED
    }

    struct Sunset {
        bytes32 agentId;
        SunsetStatus status;
        uint256 scheduledAt;
        uint256 completesAt;
        string reason;
        address scheduledBy;
        address completedBy;
    }

    mapping(bytes32 => Sunset) internal _sunsets;
    bytes32[] public sunsetAgents;

    event SunsetScheduled(bytes32 indexed agentId, uint256 completesAt, string reason);
    event SunsetCancelled(bytes32 indexed agentId, address cancelledBy);
    event SunsetCompleted(bytes32 indexed agentId, address completedBy);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    function scheduleSunset(bytes32 agentId, uint256 gracePeriod, string calldata reason) external onlyOperator {
        require(_sunsets[agentId].status != SunsetStatus.SCHEDULED, "Already scheduled");
        require(gracePeriod >= MIN_GRACE && gracePeriod <= MAX_GRACE, "Invalid grace period");

        _sunsets[agentId] = Sunset({
            agentId: agentId,
            status: SunsetStatus.SCHEDULED,
            scheduledAt: block.timestamp,
            completesAt: block.timestamp + gracePeriod,
            reason: reason,
            scheduledBy: msg.sender,
            completedBy: address(0)
        });

        sunsetAgents.push(agentId);
        emit SunsetScheduled(agentId, block.timestamp + gracePeriod, reason);
    }

    function cancelSunset(bytes32 agentId) external onlyOperator {
        require(_sunsets[agentId].status == SunsetStatus.SCHEDULED, "Not scheduled");
        _sunsets[agentId].status = SunsetStatus.CANCELLED;
        emit SunsetCancelled(agentId, msg.sender);
    }

    function completeSunset(bytes32 agentId) external onlyOperator {
        Sunset storage s = _sunsets[agentId];
        require(s.status == SunsetStatus.SCHEDULED, "Not scheduled");
        require(block.timestamp >= s.completesAt, "Grace period not passed");

        s.status = SunsetStatus.COMPLETED;
        s.completedBy = msg.sender;

        emit SunsetCompleted(agentId, msg.sender);
    }

    function getSunset(bytes32 agentId) external view returns (Sunset memory) {
        return _sunsets[agentId];
    }

    function isPending(bytes32 agentId) external view returns (bool) {
        return _sunsets[agentId].status == SunsetStatus.SCHEDULED;
    }

    function totalSunsets() external view returns (uint256) {
        return sunsetAgents.length;
    }
}
