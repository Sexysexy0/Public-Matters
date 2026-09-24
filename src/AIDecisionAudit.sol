// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title AIDecisionAudit
 * @notice Immutable audit of AI agent decisions.
 *
 * Each decision is recorded as a triple of hashes:
 *   inputHash     - hash of the input context
 *   reasoningHash - hash of the chain-of-thought / rationale
 *   outputHash    - hash of the resulting decision/action
 *
 * Mistakes cannot be deleted - only superseded. The original decision
 * remains on-chain forever, with a pointer to its correction. This
 * makes concealment and fabrication detectable by construction.
 *
 * Maps to:
 *   - Stop Rogue AI Act: real-time monitoring + auditable decisions
 *   - AI Kill Switch Act: decision-level revocation via supersede
 */
contract AIDecisionAudit {
    OperatorPrivileges public privileges;

    struct Decision {
        bytes32 decisionId;
        bytes32 agentId;
        bytes32 inputHash;
        bytes32 reasoningHash;
        bytes32 outputHash;
        uint8 confidence; // 0-100
        uint256 timestamp;
        address reportedBy;
        bool superseded;
        bytes32 supersededBy;
        string supersededReason;
    }

    mapping(bytes32 => Decision) public decisions;
    mapping(bytes32 => bytes32[]) public agentDecisions; // agentId => decisionIds
    bytes32[] public allDecisions;
    uint256 public totalDecisions;

    event DecisionRecorded(
        bytes32 indexed decisionId,
        bytes32 indexed agentId,
        bytes32 inputHash,
        bytes32 outputHash,
        uint8 confidence,
        address reportedBy,
        uint256 timestamp
    );

    event DecisionSuperseded(
        bytes32 indexed oldDecisionId,
        bytes32 indexed newDecisionId,
        bytes32 indexed agentId,
        string reason,
        address supersededBy
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier decisionExists(bytes32 decisionId) {
        require(decisions[decisionId].timestamp != 0, "Decision not found");
        _;
    }

    modifier notSuperseded(bytes32 decisionId) {
        require(!decisions[decisionId].superseded, "Decision already superseded");
        _;
    }

    constructor(address _privileges) {
        privileges = OperatorPrivileges(_privileges);
    }

    /**
     * @notice Record a new AI decision on-chain
     */
    function recordDecision(
        bytes32 agentId,
        bytes32 inputHash,
        bytes32 reasoningHash,
        bytes32 outputHash,
        uint8 confidence
    ) external onlyOperator returns (bytes32) {
        require(confidence <= 100, "Confidence must be 0-100");

        bytes32 decisionId =
            keccak256(abi.encodePacked(agentId, inputHash, reasoningHash, outputHash, block.timestamp, totalDecisions));
        require(decisions[decisionId].timestamp == 0, "Decision already exists");

        decisions[decisionId] = Decision({
            decisionId: decisionId,
            agentId: agentId,
            inputHash: inputHash,
            reasoningHash: reasoningHash,
            outputHash: outputHash,
            confidence: confidence,
            timestamp: block.timestamp,
            reportedBy: msg.sender,
            superseded: false,
            supersededBy: bytes32(0),
            supersededReason: ""
        });

        agentDecisions[agentId].push(decisionId);
        allDecisions.push(decisionId);
        totalDecisions++;

        emit DecisionRecorded(decisionId, agentId, inputHash, outputHash, confidence, msg.sender, block.timestamp);

        return decisionId;
    }

    /**
     * @notice Supersede a prior decision with a corrected one.
     *         The original remains on-chain, marked as superseded.
     */
    function supersedeDecision(bytes32 oldDecisionId, bytes32 newDecisionId, string calldata reason)
        external
        onlyOperator
        decisionExists(oldDecisionId)
        notSuperseded(oldDecisionId)
    {
        require(decisions[newDecisionId].timestamp != 0, "New decision not found");
        require(decisions[newDecisionId].agentId == decisions[oldDecisionId].agentId, "Agent mismatch");

        decisions[oldDecisionId].superseded = true;
        decisions[oldDecisionId].supersededBy = newDecisionId;
        decisions[oldDecisionId].supersededReason = reason;

        emit DecisionSuperseded(oldDecisionId, newDecisionId, decisions[oldDecisionId].agentId, reason, msg.sender);
    }

    // ─────────────────────────────────────────────────────────────
    // VIEWS
    // ─────────────────────────────────────────────────────────────

    function getDecision(bytes32 decisionId) external view decisionExists(decisionId) returns (Decision memory) {
        return decisions[decisionId];
    }

    function getDecisionsByAgent(bytes32 agentId) external view returns (bytes32[] memory) {
        return agentDecisions[agentId];
    }

    function getDecisionCount(bytes32 agentId) external view returns (uint256) {
        return agentDecisions[agentId].length;
    }

    function getAllDecisions() external view returns (bytes32[] memory) {
        return allDecisions;
    }

    /**
     * @notice Verify a claimed decision matches on-chain record
     */
    function verifyDecision(bytes32 decisionId, bytes32 inputHash, bytes32 reasoningHash, bytes32 outputHash)
        external
        view
        decisionExists(decisionId)
        returns (bool)
    {
        Decision storage d = decisions[decisionId];
        return (d.inputHash == inputHash && d.reasoningHash == reasoningHash && d.outputHash == outputHash);
    }

    /**
     * @notice Compute a decision hash off-chain the same way the contract does
     */
    function computeDecisionHash(
        bytes32 agentId,
        bytes32 inputHash,
        bytes32 reasoningHash,
        bytes32 outputHash,
        uint256 timestamp,
        uint256 index
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(agentId, inputHash, reasoningHash, outputHash, timestamp, index));
    }
}
