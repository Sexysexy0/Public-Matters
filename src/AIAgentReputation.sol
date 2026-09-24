// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIAgentReputation
 * @notice Long-term reputation score per AI agent. Separate from
 *         operator trust scores. Reward good behavior, slash bad.
 */
contract AIAgentReputation {
    OperatorPrivileges public privileges;

    uint256 public constant MAX_SCORE = 1000;
    uint256 public constant INITIAL_SCORE = 500;

    struct Reputation {
        bytes32 agentId;
        uint256 score;
        uint256 totalRewards;
        uint256 totalSlashes;
        uint256 lastUpdated;
        bool exists;
    }

    struct Change {
        int256 delta;
        uint256 newScore;
        bytes32 reason;
        uint256 timestamp;
        address actor;
    }

    mapping(bytes32 => Reputation) internal _reputations;
    mapping(bytes32 => Change[]) internal _history;
    bytes32[] public trackedAgents;

    event ReputationInitialized(bytes32 indexed agentId, uint256 score);
    event ReputationRewarded(bytes32 indexed agentId, uint256 amount, uint256 newScore, bytes32 reason);
    event ReputationSlashed(bytes32 indexed agentId, uint256 amount, uint256 newScore, bytes32 reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivileges(_privileges);
    }

    function initialize(bytes32 agentId) external onlyOperator {
        require(!_reputations[agentId].exists, "Already initialized");
        _reputations[agentId] = Reputation({
            agentId: agentId,
            score: INITIAL_SCORE,
            totalRewards: 0,
            totalSlashes: 0,
            lastUpdated: block.timestamp,
            exists: true
        });
        trackedAgents.push(agentId);
        emit ReputationInitialized(agentId, INITIAL_SCORE);
    }

    function reward(bytes32 agentId, uint256 amount, bytes32 reason) external onlyOperator {
        Reputation storage r = _reputations[agentId];
        require(r.exists, "Not tracked");

        uint256 newScore = r.score + amount;
        if (newScore > MAX_SCORE) newScore = MAX_SCORE;

        int256 delta = int256(newScore) - int256(r.score);
        r.score = newScore;
        r.totalRewards++;
        r.lastUpdated = block.timestamp;

        _history[agentId].push(
            Change({delta: delta, newScore: newScore, reason: reason, timestamp: block.timestamp, actor: msg.sender})
        );

        emit ReputationRewarded(agentId, amount, newScore, reason);
    }

    function slash(bytes32 agentId, uint256 amount, bytes32 reason) external onlyOperator {
        Reputation storage r = _reputations[agentId];
        require(r.exists, "Not tracked");

        uint256 newScore = r.score > amount ? r.score - amount : 0;
        int256 delta = int256(newScore) - int256(r.score);

        r.score = newScore;
        r.totalSlashes++;
        r.lastUpdated = block.timestamp;

        _history[agentId].push(
            Change({delta: delta, newScore: newScore, reason: reason, timestamp: block.timestamp, actor: msg.sender})
        );

        emit ReputationSlashed(agentId, amount, newScore, reason);
    }

    function getScore(bytes32 agentId) external view returns (uint256) {
        return _reputations[agentId].score;
    }

    function getReputation(bytes32 agentId) external view returns (Reputation memory) {
        return _reputations[agentId];
    }

    function getHistoryLength(bytes32 agentId) external view returns (uint256) {
        return _history[agentId].length;
    }

    function getChange(bytes32 agentId, uint256 index) external view returns (Change memory) {
        return _history[agentId][index];
    }

    function totalTracked() external view returns (uint256) {
        return trackedAgents.length;
    }
}
