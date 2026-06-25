// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CriticalInfrastructureGuard
 * @notice Validates the security compliance variables of external server nodes and operational technology (OT) pipelines to insulate AI execution layers.
 */
contract CriticalInfrastructureGuard {
    event InfrastructureNodeRegistered(address indexed hardwareNode, bytes32 locationHash, uint256 initialSecurityTier);
    event NodeQuarantined(address indexed vulnerableNode, string exploitVector, uint256 blockIncident);
    event SecurityAttestationLogged(address indexed hardwareNode, uint256 validationBlock, uint256 updateVulnerabilityIndex);
    event SystemStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public networkSteward;
    uint256 public totalMonitoredNodes;
    bool public infrastructureFirewallEnforced;

    struct NodeSecurityProfile {
        bytes32 hardwareLocationHash; // Identifies physical server zone or data center deployment identifier
        uint256 lastAttestationBlock;
        uint256 vulnerabilityIndex;  // Risk metric score (0 to 100); higher values indicate severe systemic vulnerability
        bool isVerified;
        bool isQuarantined;
        bool initialized;
    }

    // Mapping from unique hardware processing address to internal infrastructure configurations
    mapping(address => NodeSecurityProfile) public infrastructureRegistry;

    constructor() {
        networkSteward = msg.sender;
        infrastructureFirewallEnforced = true;
    }

    modifier onlySteward() {
        require(msg.sender == networkSteward, "Unauthorized Action: Network Steward cryptographic validation failed");
        _;
    }

    /**
     * @notice Registers a new external computing platform or server layer inside the core tracking framework.
     */
    function registerInfrastructureNode(
        address _hardwareNode,
        bytes32 _locationHash,
        uint256 _securityTier
    ) external onlySteward {
        require(_hardwareNode != address(0), "Parameter Error: Target hardware address coordinate cannot be blank");
        require(_locationHash != bytes32(0), "Parameter Error: Location tracking identifier cannot be uninstantiated");
        require(!infrastructureRegistry[_hardwareNode].initialized, "Collision Intercept: Target node already active inside state history");

        infrastructureRegistry[_hardwareNode] = NodeSecurityProfile({
            hardwareLocationHash: _locationHash,
            lastAttestationBlock: block.number,
            vulnerabilityIndex: 0, // Starts at baseline optimal security status
            isVerified: _securityTier >= 3, // Multi-tier safety verification baseline
            isQuarantined: false,
            initialized: true
        });

        totalMonitoredNodes += 1;
        emit InfrastructureNodeRegistered(_hardwareNode, _locationHash, _securityTier);
    }

    /**
     * @notice Logs a real-time cryptographic security health check and modulates node telemetry data metrics.
     */
    function processSecurityAttestation(address _hardwareNode, uint256 _newVulnerabilityScore) external onlySteward {
        NodeSecurityProfile storage node = infrastructureRegistry[_hardwareNode];
        require(node.initialized, "Registry Exception: Targeted hardware profile coordinate does not exist");
        require(_newVulnerabilityScore <= 100, "Parameter Error: Input risk score overrides boundary structural limits");

        node.lastAttestationBlock = block.number;
        node.vulnerabilityIndex = _newVulnerabilityScore;

        emit SecurityAttestationLogged(_hardwareNode, block.number, _newVulnerabilityScore);

        // Automated Isolation Trigger: If node metrics breach the safety limit, instantly trip the firewall quarantine flag
        if (_newVulnerabilityScore >= 60 && infrastructureFirewallEnforced) {
            node.isQuarantined = true;
            node.isVerified = false;
            emit NodeQuarantined(_hardwareNode, "AUTOMATED_FIREWALL_INTERCEPT: High vulnerability index detected", block.number);
        }
    }

    /**
     * @notice Security verification gate applied before launching automated execution loops across dependent nodes.
     */
    function verifyNodeInfrastructure(address _hardwareNode) external view returns (bool) {
        if (!infrastructureFirewallEnforced) {
            return true;
        }

        NodeSecurityProfile memory node = infrastructureRegistry[_hardwareNode];
        require(node.initialized, "Security Intercept: Selected hardware node lacks registered structural configuration");
        require(node.isVerified, "Security Block: Node has failed infrastructure safety and verification parameters");
        require(!node.isQuarantined, "Security Intercept: Target network cluster is locked under active emergency quarantine");

        return true;
    }

    /**
     * @notice Manual override command to force-quarantine a node experiencing a physical or zero-day compromise.
     */
    function forceNodeQuarantine(address _compromisedNode, string calldata _reason) external onlySteward {
        NodeSecurityProfile storage node = infrastructureRegistry[_compromisedNode];
        require(node.initialized, "Registry Exception: Target profile tracking coordinate is uninstantiated");
        
        node.isQuarantined = true;
        node.isVerified = false;

        emit NodeQuarantined(_compromisedNode, _reason, block.number);
    }

    /**
     * @notice Release a node from the quarantine matrix once physical hardware repairs and firmwares are cleared.
     */
    function resolveNodeQuarantine(address _clearedNode) external onlySteward {
        NodeSecurityProfile storage node = infrastructureRegistry[_clearedNode];
        require(node.isQuarantined, "State Error: Selected target node is currently running optimal configurations");

        node.isQuarantined = false;
        node.isVerified = true;
        node.vulnerabilityIndex = 0; // Reset index back to absolute zero baseline
    }

    /**
     * @notice Toggle the automated infrastructure firewall constraint mechanics.
     */
    function toggleFirewallEnforcement(bool _status) external onlySteward {
        infrastructureFirewallEnforced = _status;
    }

    /**
     * @notice Shift the master core infrastructure signature token reference destination coordinator.
     */
    function transferNetworkSteward(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Identity Error: Target root destination falls outside legal system registry parameters");
        networkSteward = _newSteward;
        emit SystemStewardTransferred(msg.sender, _newSteward);
    }
}
