// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title GlobalEmergencyFreeze
 * @notice Global halt for all AI operations. Requires 2-of-N operator
 *         approval to lift, preventing unilateral abuse.
 */
contract GlobalEmergencyFreeze {
    OperatorPrivileges public privileges;

    bool public frozen;
    uint256 public frozenAt;
    bytes32 public freezeReason;
    address public frozenBy;

    uint256 public constant LIFT_THRESHOLD = 2;
    uint256 public currentLiftApprovals;

    mapping(address => bool) public liftApprovals;

    event GlobalFreezeTriggered(bytes32 indexed reason, address triggeredBy, uint256 timestamp);
    event FreezeLiftProposed(address indexed operator, uint256 approvalsSoFar);
    event GlobalFreezeLifted(address liftedBy, uint256 timestamp);
    event LiftApprovalRevoked(address indexed operator);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function triggerGlobalFreeze(bytes32 reason) external onlyOperator {
        require(!frozen, "Already frozen");
        frozen = true;
        frozenAt = block.timestamp;
        freezeReason = reason;
        frozenBy = msg.sender;
        currentLiftApprovals = 0;

        emit GlobalFreezeTriggered(reason, msg.sender, block.timestamp);
    }

    function proposeLift() external onlyOperator {
        require(frozen, "Not frozen");
        require(!liftApprovals[msg.sender], "Already approved");

        liftApprovals[msg.sender] = true;
        currentLiftApprovals++;

        emit FreezeLiftProposed(msg.sender, currentLiftApprovals);

        if (currentLiftApprovals >= LIFT_THRESHOLD) {
            frozen = false;
            frozenAt = 0;
            freezeReason = bytes32(0);
            frozenBy = address(0);
            currentLiftApprovals = 0;

            emit GlobalFreezeLifted(msg.sender, block.timestamp);
        }
    }

    function revokeLiftApproval() external onlyOperator {
        require(liftApprovals[msg.sender], "No approval to revoke");
        liftApprovals[msg.sender] = false;
        currentLiftApprovals--;
        emit LiftApprovalRevoked(msg.sender);
    }

    function isFrozen() external view returns (bool) {
        return frozen;
    }

    function getFreezeInfo()
        external
        view
        returns (bool isCurrentlyFrozen, uint256 timestamp, bytes32 reason, address triggeredBy, uint256 approvals)
    {
        return (frozen, frozenAt, freezeReason, frozenBy, currentLiftApprovals);
    }
}
