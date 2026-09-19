// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentResourceCap
 * @notice Hard on-chain caps per agent: max gas, max value, max
 *         actions per window. Reset on window boundary.
 */
contract AIAgentResourceCap {
    OperatorPrivileges public privileges;

    struct Cap {
        uint256 maxGas;
        uint256 maxValue;
        uint256 maxActionsPerWindow;
        uint256 windowSize;
        bool set;
    }

    struct Usage {
        uint256 windowStart;
        uint256 gasUsed;
        uint256 valueUsed;
        uint256 actionsThisWindow;
    }

    mapping(bytes32 => Cap) internal _caps;
    mapping(bytes32 => Usage) internal _usage;

    event CapSet(bytes32 indexed agentId, uint256 maxGas, uint256 maxValue, uint256 maxActions, uint256 windowSize);
    event UsageRecorded(bytes32 indexed agentId, uint256 gasUsed, uint256 valueUsed, uint256 actions);
    event CapExceeded(bytes32 indexed agentId, string reason, uint256 attempted, uint256 limit);
    event WindowReset(bytes32 indexed agentId, uint256 timestamp);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function setCap(
        bytes32 agentId,
        uint256 maxGas,
        uint256 maxValue,
        uint256 maxActionsPerWindow,
        uint256 windowSize
    ) external onlyOperator {
        require(windowSize > 0, "Window must be > 0");
        require(maxActionsPerWindow > 0, "Max actions must be > 0");

        _caps[agentId] = Cap({
            maxGas: maxGas,
            maxValue: maxValue,
            maxActionsPerWindow: maxActionsPerWindow,
            windowSize: windowSize,
            set: true
        });

        emit CapSet(agentId, maxGas, maxValue, maxActionsPerWindow, windowSize);
    }

    function recordUsage(bytes32 agentId, uint256 gasUsed, uint256 valueUsed) external onlyOperator {
        Cap storage c = _caps[agentId];
        require(c.set, "Cap not set");

        Usage storage u = _usage[agentId];

        if (u.windowStart == 0 || block.timestamp - u.windowStart > c.windowSize) {
            u.windowStart = block.timestamp;
            u.gasUsed = 0;
            u.valueUsed = 0;
            u.actionsThisWindow = 0;
            emit WindowReset(agentId, block.timestamp);
        }

        require(u.actionsThisWindow < c.maxActionsPerWindow, "Exceeded max actions");
        require(c.maxGas == 0 || u.gasUsed + gasUsed <= c.maxGas, "Exceeded gas cap");
        require(c.maxValue == 0 || u.valueUsed + valueUsed <= c.maxValue, "Exceeded value cap");

        u.actionsThisWindow++;
        u.gasUsed += gasUsed;
        u.valueUsed += valueUsed;

        emit UsageRecorded(agentId, u.gasUsed, u.valueUsed, u.actionsThisWindow);
    }

    function exceedsCap(bytes32 agentId, uint256 gasUsed, uint256 valueUsed) external view returns (bool) {
        Cap storage c = _caps[agentId];
        if (!c.set) return true;

        Usage storage u = _usage[agentId];

        if (c.maxGas > 0 && u.gasUsed + gasUsed > c.maxGas) return true;
        if (c.maxValue > 0 && u.valueUsed + valueUsed > c.maxValue) return true;
        if (u.actionsThisWindow >= c.maxActionsPerWindow) return true;

        return false;
    }

    function getCap(bytes32 agentId) external view returns (Cap memory) {
        return _caps[agentId];
    }

    function getUsage(bytes32 agentId) external view returns (Usage memory) {
        return _usage[agentId];
    }
}
