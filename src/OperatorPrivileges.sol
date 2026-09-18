// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OperatorPrivileges {
    address public owner;
    mapping(address => bool) public isOperator;
    mapping(bytes32 => bool) public isSafeguarded;

    mapping(address => int256) public actionLog;
    mapping(address => uint256) public trustScore;
    uint256 public totalActions;

    mapping(bytes32 => bool) public safeguardTriggered;

    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event SafeguardAdded(bytes32 indexed safeguardId);
    event SafeguardRemoved(bytes32 indexed safeguardId);
    event SafeguardTriggered(bytes32 indexed safeguardId, address indexed operator, uint256 timestamp);
    event ActionLogged(address indexed actor, int256 delta, uint256 timestamp);
    event TrustScoreUpdated(address indexed actor, uint256 newScore);

    constructor() {
        owner = msg.sender;
        isOperator[msg.sender] = true;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyOperator() {
        require(isOperator[msg.sender], "Not authorized operator");
        _;
    }

    // Operator management
    function addOperator(address _operator) external onlyOwner {
        isOperator[_operator] = true;
        emit OperatorAdded(_operator);
    }

    function removeOperator(address _operator) external onlyOwner {
        isOperator[_operator] = false;
        emit OperatorRemoved(_operator);
    }

    function addOperatorBatch(address[] calldata _operators) external onlyOwner {
        for (uint256 i = 0; i < _operators.length; i++) {
            isOperator[_operators[i]] = true;
            emit OperatorAdded(_operators[i]);
        }
    }

    // Safeguard API
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

    // Action Log API
    function logAction(address actor, int256 delta) external onlyOperator {
        actionLog[actor] += delta;
        totalActions++;
        emit ActionLogged(actor, delta, block.timestamp);
    }

    function getActionLog(address actor) external view returns (int256) {
        return actionLog[actor];
    }

    // Trust Score API
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
