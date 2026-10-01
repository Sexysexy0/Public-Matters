// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "./AlignmentGuard.sol";

/**
 * @title TimelockBuffer
 * @notice Extends AlignmentGuard to allow dynamic extension of reflection 
 *         periods when complex parameters or external state changes require deeper auditing.
 */
contract TimelockBuffer is AlignmentGuard {
    
    uint256 public constant MAX_EXTENSION = 14 days;

    event TimelockExtended(bytes32 indexed actionId, uint256 newExecuteAfter, string reason);

    constructor(address initialOperator) AlignmentGuard(initialOperator) {}

    function extendTimelock(bytes32 actionId, uint256 additionalDelay, string calldata reason) external onlyOperator {
        ProposedAction storage action = pendingActions[actionId];
        require(!action.executed, "TimelockBuffer: Action already executed");
        require(!action.canceled, "TimelockBuffer: Action was canceled");
        require(additionalDelay <= MAX_EXTENSION, "TimelockBuffer: Extension exceeds max limit");

        action.executeAfter += additionalDelay;

        emit TimelockExtended(actionId, action.executeAfter, reason);
    }
}
