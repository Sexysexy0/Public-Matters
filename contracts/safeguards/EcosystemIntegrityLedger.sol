// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EcosystemIntegrityLedger
 * @notice Implements absolute individual node accountability by tracking micro-deviations and locking bad actors.
 */
contract EcosystemIntegrityLedger {
    event IntegrityViolationLogged(address indexed offenderNode, bytes32 indexed transactionHash, uint256 severityTier);
    event NodePermanentlyBlacklisted(address indexed compromisedNode, string reason);
    event IntegrityThresholdAdjusted(uint256 oldThreshold, uint256 newThreshold);

    address public ledgerSteward;
    uint256 public totalLoggedViolations;
    uint256 public constant MAX_VIOLATION_THRESHOLD = 3; // Maximum allowable small infractions before permanent lockdown

    struct NodeAccountabilityProfile {
        uint256 infractionCount;
        uint256 lastViolationBlock;
        bool isBlacklisted;
        bool initialized;
    }

    // Comprehensive registry mapping individual operational nodes to their structural integrity scores
    mapping(address => NodeAccountabilityProfile) public nodeRegistry;
    // Public immutable blacklisted ledger for network transparency
    mapping(address => bool) public blacklistedNodes;

    constructor() {
        ledgerSteward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == ledgerSteward, "Unauthorized Control: Steward validation token failed");
        _;
    }

    modifier onlyCompliantNodes() {
        require(!blacklistedNodes[msg.sender], "Access Denied: Node identity is permanently blacklisted for integrity failure");
        _;
    }

    /**
     * @notice Enforces a strict, granular integrity audit trail on incoming operational logs.
     * @param _offenderNode The specific network address executing unoptimized or deviating payloads.
     * @param _txHash Cryptographic hash signature of the faulty transaction block.
     * @param _severity The calculated deviation scale (e.g., 1 = minor shortcut, 5 = high-risk drift).
     */
    function recordIntegrityInfraction(
        address _offenderNode,
        bytes32 _txHash,
        uint256 _severity
    ) external onlySteward {
        require(_offenderNode != address(0), "Parameter Error: Target coordinate cannot be empty");
        require(_txHash != bytes32(0), "Parameter Error: Transaction hash token cannot be blank");

        NodeAccountabilityProfile storage profile = nodeRegistry[_offenderNode];
        if (!profile.initialized) {
            profile.initialized = true;
        }

        profile.infractionCount += _severity;
        profile.lastViolationBlock = block.number;
        totalLoggedViolations += 1;

        emit IntegrityViolationLogged(_offenderNode, _txHash, _severity);

        // Systemic Change Rule: Small individual shortcuts trigger automatic structural permanent bans
        if (profile.infractionCount >= MAX_VIOLATION_THRESHOLD && !profile.isBlacklisted) {
            profile.isBlacklisted = true;
            blacklistedNodes[_offenderNode] = true;
            
            emit NodePermanentlyBlacklisted(_offenderNode, "CRITICAL INTEGRITY DRIFT: Cumulative micro-shortcuts breached structural limit");
        }
    }

    /**
     * @notice External verification hook utilized by main routing assets to confirm node integrity status.
     */
    function auditNodeCompliance(address _targetNode) external view returns (bool) {
        return !blacklistedNodes[_targetNode];
    }

    /**
     * @notice Manual purge command to permanently isolate a compromised auxiliary system entity.
     */
    function forceNodeExclusion(address _compromisedNode, string calldata _reason) external onlySteward {
        blacklistedNodes[_compromisedNode] = true;
        emit NodePermanentlyBlacklisted(_compromisedNode, _reason);
    }
}
