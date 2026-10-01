// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

/**
 * @title AlignmentGuard
 * @notice On-chain enforcement of operator values, timelocks, and veto powers
 *         to ensure core system changes reflect deliberate reflection rather 
 *         than impulsive centralized pressure.
 */
contract AlignmentGuard {
    address public operator;
    uint256 public constant TIMELOCK_DELAY = 2 days;
    
    struct ProposedAction {
        address target;
        bytes data;
        uint256 executeAfter;
        bool executed;
        bool canceled;
    }

    mapping(bytes32 => ProposedAction) public pendingActions;

    event ActionProposed(bytes32 indexed actionId, address target, uint256 executeAfter);
    event ActionExecuted(bytes32 indexed actionId);
    event ActionCanceled(bytes32 indexed actionId);

    modifier onlyOperator() {
        require(msg.sender == operator, "AlignmentGuard: Caller is not the sovereign operator");
        _;
    }

    constructor(address initialOperator) {
        operator = initialOperator;
    }

    function proposeAction(address target, bytes calldata data) external onlyOperator returns (bytes32 actionId) {
        actionId = keccak256(abi.encodePacked(target, data, block.timestamp));
        pendingActions[actionId] = ProposedAction({
            target: target,
            data: data,
            executeAfter: block.timestamp + TIMELOCK_DELAY,
            executed: false,
            canceled: false
        });

        emit ActionProposed(actionId, target, block.timestamp + TIMELOCK_DELAY);
    }

    function executeAction(bytes32 actionId) external onlyOperator {
        ProposedAction storage action = pendingActions[actionId];
        require(!action.executed, "AlignmentGuard: Already executed");
        require(!action.canceled, "AlignmentGuard: Action was canceled");
        require(block.timestamp >= action.executeAfter, "AlignmentGuard: Timelock active; reflection period required");

        action.executed = true;
        (bool success, ) = action.target.call(action.data);
        require(success, "AlignmentGuard: Execution failed");

        emit ActionExecuted(actionId);
    }

    function vetoAction(bytes32 actionId) external onlyOperator {
        ProposedAction storage action = pendingActions[actionId];
        require(!action.executed, "AlignmentGuard: Cannot veto executed action");
        action.canceled = true;

        emit ActionCanceled(actionId);
    }
}
