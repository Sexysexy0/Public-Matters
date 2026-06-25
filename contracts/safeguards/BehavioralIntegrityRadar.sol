// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title BehavioralIntegrityRadar
 * @notice Cryptographic infrastructure engineered to intercept structural cynicism, intentional mediocrity, and proactive operational negligence within an enterprise node framework.
 */
contract BehavioralIntegrityRadar {
    event ResentmentFlagged(address indexed offendingNode, string department, string description, uint256 violationTier);
    event NodeDecommissioned(address indexed badActorNode, string enforcementReason);
    event IntegrityScoreUpdated(address indexed targetNode, uint256 currentScore);

    address public frameworkGovernor;
    uint256 public totalSanctionedNodes;

    struct BehaviorMatrix {
        uint256 integrityScore; // Starts at 100. Decreases via proactive negligence inputs.
        uint256 consecutiveDelays;
        bool activeLockout;
        bool initialized;
    }

    // Maps system operator or employee addresses directly to their architectural integrity matrix
    mapping(address => BehaviorMatrix) public nodeBehaviorGrid;
    // Authorized independent evaluators, project managers, or compliance auditors
    mapping(address => bool) public authorizedBehaviorAuditors;

    constructor() {
        frameworkGovernor = msg.sender;
        authorizedBehaviorAuditors[msg.sender] = true;
    }

    modifier onlyGovernor() {
        require(msg.sender == frameworkGovernor, "Access Denied: Master governor verification failure");
        _;
    }

    modifier onlyAuditor() {
        require(authorizedBehaviorAuditors[msg.sender], "Access Denied: Caller node is not an authorized behavior auditor");
        _;
    }

    function configureAuditorNode(address _auditor, bool _status) external onlyGovernor {
        authorizedBehaviorAuditors[_auditor] = _status;
    }

    /**
     * @notice Hooks into the operational tracking layers to log active resentment, malicious slacking, or toxic administrative sabotage.
     * @param _offender The wallet address of the node creating a "slice of hell" in the workspace.
     * @param _tier Violation scale: 1 = Passive Gossiping/Delays, 3 = Intentional Quality Degradation, 5 = Severe System Sabotage.
     */
    function logMaliciousNegligence(
        address _offender,
        string calldata _dept,
        string calldata _proofLink,
        uint256 _tier
    ) external onlyAuditor {
        require(_tier >= 1 && _tier <= 5, "Parameter Error: Score bounds restriction overflow");
        
        BehaviorMatrix storage node = nodeBehaviorGrid[_offender];
        if (!node.initialized) {
            node.integrityScore = 100;
            node.initialized = true;
        }

        // Deduct points based on the severity of the architectural resentment
        uint256 penaltyPoints = _tier * 15;
        if (node.integrityScore > penaltyPoints) {
            node.integrityScore -= penaltyPoints;
        } else {
            node.integrityScore = 0;
            node.activeLockout = true;
        }

        emit ResentmentFlagged(_offender, _dept, _proofLink, _tier);
        emit IntegrityScoreUpdated(_offender, node.integrityScore);

        // Immediate lockout if integrity drops below 40% (anti-bad-diner safeguard)
        if (node.integrityScore <= 40 && !node.activeLockout) {
            node.activeLockout = true;
            totalSanctionedNodes += 1;
            emit NodeDecommissioned(_offender, "BEHAVIORAL_REJECTION: Node intentionally architecturalized its own failure state");
        }
    }

    /**
     * @notice High-speed external gatekeeper checking if a node is psychologically and operationally fit to receive client routing.
     */
    function verifyNodeSanity(address _node) external view returns (bool) {
        if (!nodeBehaviorGrid[_node].initialized) return true;
        return !nodeBehaviorGrid[_node].activeLockout;
    }
}
