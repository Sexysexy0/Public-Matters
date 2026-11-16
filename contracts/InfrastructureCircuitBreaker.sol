// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "../src/OperatorPrivileges.sol";

contract InfrastructureCircuitBreaker {
    OperatorPrivileges public immutable privileges;
    bool public systemHalted;
    mapping(bytes32 => bool) public nodeHealthStatus;

    event SystemHaltTriggered(string reason);
    event SystemResumed();
    event NodeStatusUpdated(bytes32 indexed nodeId, bool healthy);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
        systemHalted = false;
    }

    function triggerEmergencyHalt(string calldata reason) external onlyOperator {
        systemHalted = true;
        emit SystemHaltTriggered(reason);
    }

    function resumeSystem() external onlyOperator {
        systemHalted = false;
        emit SystemResumed();
    }

    function updateNodeHealth(bytes32 nodeId, bool healthy) external onlyOperator {
        nodeHealthStatus[nodeId] = healthy;
        emit NodeStatusUpdated(nodeId, healthy);
    }
}
