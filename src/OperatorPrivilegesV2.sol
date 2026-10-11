// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title OperatorPrivilegesV2
 * @notice OperatorPrivileges + 2-step ownership transfer.
 *         Allows ownership to be moved to a multisig for production security.
 *         All V1 functions preserved.
 */
contract OperatorPrivilegesV2 {
    address public owner;
    address public pendingOwner;

    mapping(address => bool) public isOperator;
    mapping(bytes32 => bool) public isSafeguarded;
    mapping(bytes32 => bool) public safeguardTriggered;
    mapping(address => int256) public actionLog;
    mapping(address => uint256) public trustScore;
    uint256 public totalActions;

    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event SafeguardAdded(bytes32 indexed safeguardId);
    event SafeguardRemoved(bytes32 indexed safeguardId);
    event SafeguardTriggered(bytes32 indexed safeguardId, address indexed operator, uint256 timestamp);
    event ActionLogged(address indexed actor, int256 delta, uint256 timestamp);
    event TrustScoreUpdated(address indexed actor, uint256 newScore);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferCancelled(address indexed cancelledBy);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyOperator() {
        require(isOperator[msg.sender], "Not authorized operator");
        _;
    }

    constructor() {
        owner = msg.sender;
        isOperator[msg.sender] = true;
    }

    // ─── 2-STEP OWNERSHIP ───

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid new owner");
        require(newOwner != owner, "Already owner");
        pendingOwner = newOwner;
        emit OwnershipTransferStarted(owner, newOwner);
    }

    function acceptOwnership() external {
        require(msg.sender == pendingOwner, "Not pending owner");
        address old = owner;
        // OwnershipTransferred emitted immediately after; lint cannot correlate.
        // forge-lint: disable-next-line(missing-events-access-control)
        owner = pendingOwner;
        pendingOwner = address(0);
        // forge-lint: disable-next-line(missing-events-access-control)
        isOperator[owner] = true;
        emit OwnershipTransferred(old, owner);
    }

    function cancelOwnershipTransfer() external onlyOwner {
        pendingOwner = address(0);
        emit OwnershipTransferCancelled(msg.sender);
    }

    // ─── OPERATOR MANAGEMENT ───

    function addOperator(address _operator) external onlyOwner {
        // Event emitted on next line; lint cannot correlate the pair.
        // forge-lint: disable-next-line(missing-events-access-control)
        isOperator[_operator] = true;
        emit OperatorAdded(_operator);
    }

    function removeOperator(address _operator) external onlyOwner {
        // Event emitted on next line; lint cannot correlate the pair.
        // forge-lint: disable-next-line(missing-events-access-control)
        isOperator[_operator] = false;
        emit OperatorRemoved(_operator);
    }

    function addOperatorBatch(address[] calldata _operators) external onlyOwner {
        for (uint256 i = 0; i < _operators.length; i++) {
            // Event emitted on next line; lint cannot correlate the pair.
            // forge-lint: disable-next-line(missing-events-access-control)
            isOperator[_operators[i]] = true;
            emit OperatorAdded(_operators[i]);
        }
    }

    // ─── SAFEGUARD API ───

    function addSafeguard(bytes32 safeguardId) external onlyOperator {
        isSafeguarded[safeguardId] = true;
        emit SafeguardAdded(safeguardId);
    }

    function removeSafeguard(bytes32 safeguardId) external onlyOperator {
        isSafeguarded[safeguardId] = false;
        emit SafeguardRemoved(safeguardId);
    }

    function triggerSafeguard(bytes32 safeguardId, address operator) external onlyOperator {
        isSafeguarded[safeguardId] = true;
        safeguardTriggered[safeguardId] = true;
        emit SafeguardTriggered(safeguardId, operator, block.timestamp);
    }

    // ─── ACTION LOG ───

    function logAction(address actor, int256 delta) external onlyOperator {
        actionLog[actor] += delta;
        totalActions++;

        if (delta >= 0) {
            trustScore[actor] += uint256(delta);
        } else {
            uint256 decrease = uint256(-delta);
            if (trustScore[actor] < decrease) {
                trustScore[actor] = 0;
            } else {
                trustScore[actor] -= decrease;
            }
        }

        emit ActionLogged(actor, delta, block.timestamp);
        emit TrustScoreUpdated(actor, trustScore[actor]);
    }

    function getActionLog(address actor) external view returns (int256) {
        return actionLog[actor];
    }

    // ─── TRUST SCORE API ───

    function getTrustScore(address actor) external view returns (uint256) {
        return trustScore[actor];
    }

    function setTrustScore(address actor, uint256 score) external onlyOperator {
        trustScore[actor] = score;
        emit TrustScoreUpdated(actor, score);
    }

    function incrementTrustScore(address actor, uint256 amount) external onlyOperator {
        trustScore[actor] += amount;
        emit TrustScoreUpdated(actor, trustScore[actor]);
    }

    function decrementTrustScore(address actor, uint256 amount) external onlyOperator {
        if (trustScore[actor] < amount) {
            trustScore[actor] = 0;
        } else {
            trustScore[actor] -= amount;
        }
        emit TrustScoreUpdated(actor, trustScore[actor]);
    }
}
