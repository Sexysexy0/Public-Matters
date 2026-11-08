// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title AIVetoPowerRegistry
 * @notice Forces human oversight (human-in-the-loop) on AI-proposed destructive actions.
 */
contract AIVetoPowerRegistry {
    OperatorPrivileges public immutable privileges;

    enum ActionStatus { PROPOSED, EXECUTED, VETOED }

    struct VetoableAction {
        bytes32 actionId;
        address aiAgent;
        address target;
        uint256 amount;         // 0 if non-financial (e.g., firing)
        bytes32 reasonHash;
        ActionStatus status;
        address humanApprover;
        uint256 proposedAt;
    }

    mapping(bytes32 => VetoableAction) public actions;
    uint256 public totalProposed;
    uint256 public totalExecuted;
    uint256 public totalVetoed;

    event ActionProposed(bytes32 indexed id, address indexed aiAgent, address indexed target, uint256 amount);
    event ActionApproved(bytes32 indexed id, address indexed humanApprover);
    event ActionVetoed(bytes32 indexed id, address indexed humanApprover);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice AI proposes an action. It does not execute it.
     */
    function proposeAction(
        bytes32 actionId,
        address aiAgent,
        address target,
        uint256 amount,
        bytes32 reasonHash
    ) external onlyOperator {
        require(actions[actionId].proposedAt == 0, "Action exists");

        actions[actionId] = VetoableAction({
            actionId: actionId,
            aiAgent: aiAgent,
            target: target,
            amount: amount,
            reasonHash: reasonHash,
            status: ActionStatus.PROPOSED,
            humanApprover: address(0),
            proposedAt: block.timestamp
        });

        totalProposed++;
        emit ActionProposed(actionId, aiAgent, target, amount);
    }

    /**
     * @notice Human operator approves and executes the AI's proposal.
     */
    function approveAndExecute(bytes32 actionId) external onlyOperator {
        VetoableAction storage a = actions[actionId];
        require(a.status == ActionStatus.PROPOSED, "Not proposed");
        require(msg.sender != a.aiAgent, "AI cannot self-approve");

        a.status = ActionStatus.EXECUTED;
        a.humanApprover = msg.sender;
        totalExecuted++;

        emit ActionApproved(actionId, msg.sender);
        // Actual execution logic (e.g., transferring funds, calling HR contract) happens here or via hook.
    }

    /**
     * @notice Human operator vetoes the AI's proposal.
     */
    function vetoAction(bytes32 actionId) external onlyOperator {
        VetoableAction storage a = actions[actionId];
        require(a.status == ActionStatus.PROPOSED, "Not proposed");

        a.status = ActionStatus.VETOED;
        a.humanApprover = msg.sender;
        totalVetoed++;

        emit ActionVetoed(actionId, msg.sender);
    }

    function getAction(bytes32 actionId) external view returns (VetoableAction memory) {
        return actions[actionId];
    }
}
