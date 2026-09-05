// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OperatorPrivileges {
    address public owner;

    // Core Access
    mapping(address => bool) public isOperator;

    // Functional Awareness State (Consciousness Simulation)
    mapping(address => uint256) public trustScores;
    mapping(bytes32 => bool) public activeSafeguards;

    event OperatorAdded(address indexed operator);
    event OperatorRemoved(address indexed operator);
    event SafeguardTriggered(bytes32 indexed safeguardId);

    constructor() {
        owner = msg.sender;
        isOperator[msg.sender] = true;
        trustScores[msg.sender] = 100; // Base trust level for the deployer
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier onlyOperator() {
        require(isOperator[msg.sender], "Not authorized operator");
        _;
    }

    // --- Core Management ---

    function addOperator(address _operator) external onlyOwner {
        isOperator[_operator] = true;
        trustScores[_operator] = 50; // New operators start with provisional trust
        emit OperatorAdded(_operator);
    }

    function removeOperator(address _operator) external onlyOwner {
        isOperator[_operator] = false;
        trustScores[_operator] = 0; // Wipe trust on removal
        emit OperatorRemoved(_operator);
    }

    function addOperatorBatch(address[] calldata _operators) external onlyOwner {
        for (uint256 i = 0; i < _operators.length; i++) {
            isOperator[_operators[i]] = true;
            trustScores[_operators[i]] = 50;
            emit OperatorAdded(_operators[i]);
        }
    }

    // --- Consciousness Checks & Trust Failsafes ---

    /// @notice Adjusts trust functionally for a specific operator (callable by authorized operators/contracts)
    function logAction(address operator, int256 delta) external onlyOperator {
        if (delta > 0) {
            trustScores[operator] += uint256(delta);
        } else if (delta < 0) {
            uint256 penalty = uint256(-delta);
            if (trustScores[operator] > penalty) {
                trustScores[operator] -= penalty;
            } else {
                trustScores[operator] = 0;
            }
        }
    }

    /// @notice Allows the ledger to read the current trust state
    function getTrustScore(address operator) external view returns (uint256) {
        return trustScores[operator];
    }

    /// @notice Failsafe mechanism: Lock down a specific logic path
    function triggerSafeguard(bytes32 safeguardId) external onlyOperator {
        activeSafeguards[safeguardId] = true;
        emit SafeguardTriggered(safeguardId);
    }

    /// @notice Checks if a logic path has been locked down
    function isSafeguarded(bytes32 safeguardId) external view returns (bool) {
        return activeSafeguards[safeguardId];
    }
}
