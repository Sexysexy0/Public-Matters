// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AntiAIPhishingRadar
 * @notice Engineering solution providing a decentralized intelligence radar to report, cross-verify, and blacklist malicious AI-generated phishing sites, autonomous bot domains, and deepfake scam wallets.
 */
contract AntiAIPhishingRadar {
    event ThreatReported(bytes32 indexed threatId, address indexed reporter, ThreatType indexed threat, string evidenceLink);
    event ThreatBlacklisted(bytes32 indexed threatId, string targetDomain, address targetWallet, bool activeStatus);
    event RadarNodeAuthorized(address indexed radarNode, bool status);

    address public radarSteward;
    uint256 public totalActiveThreats;
    uint256 public totalVerifiedScams;

    enum ThreatType { DeepfakeIdentityTheft, AIPhishingDomain, AutonomousBotWallet, GenerativeScamContract }

    struct ThreatProfile {
        string maliciousDomain;   // AI-generated domain name used in phishing or deepfake campaigns
        address maliciousWallet;   // Cryptographic address absorbing stolen user assets
        ThreatType classification;
        uint256 reportBlock;
        uint256 consensusVotes;    // Multi-signature confirmation counters from independent radar nodes
        bool isBlacklisted;
        bool initialized;
    }

    // Master intelligence matrix mapping active threats to profiling logs
    mapping(bytes32 => ThreatProfile) public threatRadarGrid;
    // Authorized intelligence nodes, cybersecurity groups, and whitehat cells
    mapping(address => bool) public verifiedRadarNodes;
    // Prevents double voting from the same telemetry source node
    mapping(bytes32 => mapping(address => bool)) public nodeVoteMatrix;

    constructor() {
        radarSteward = msg.sender;
        verifiedRadarNodes[msg.sender] = true;
    }

    modifier onlySteward() {
        require(msg.sender == radarSteward, "Access Denied: Master steward identity verification failure");
        _;
    }

    modifier onlyRadarNode() {
        require(verifiedRadarNodes[msg.sender], "Access Denied: Caller is not an authorized cybersecurity radar node");
        _;
    }

    /**
     * @notice Registers or removes trusted web3 security firms or community whitehat nodes.
     */
    function configureRadarNode(address _node, bool _status) external onlySteward {
        require(_node != address(0), "Parameter Error: Node target coordinate cannot be empty address");
        verifiedRadarNodes[_node] = _status;
        emit RadarNodeAuthorized(_node, _status);
    }

    /**
     * @notice Open-source community terminal to report suspected AI-driven scams and deepfakes.
     * @param _threatId Keccak-256 unique identifier generated from the malicious endpoint telemetry.
     * @param _domain The suspicious URL or bot signature profile string.
     * @param _scamWallet The public address identified collecting stolen funds.
     * @param _evidence Storage hash tracking technical proof of AI generation or deceitful identity cloning.
     */
    function submitThreatReport(
        bytes32 _threatId,
        string calldata _domain,
        address _scamWallet,
        ThreatType _type,
        string calldata _evidence
    ) external {
        require(_threatId != bytes32(0), "Parameter Error: Target threat signature cannot be blank");
        require(!threatRadarGrid[_threatId].initialized, "Collision Intercept: Threat case reference code already logged");

        threatRadarGrid[_threatId] = ThreatProfile({
            maliciousDomain: _domain,
            maliciousWallet: _scamWallet,
            classification: _type,
            reportBlock: block.number,
            consensusVotes: 0,
            isBlacklisted: false,
            initialized: true
        });

        totalActiveThreats += 1;
        emit ThreatReported(_threatId, msg.sender, _type, _evidence);
    }

    /**
     * @notice Verified cybersecurity nodes cast consensus signatures to formally blacklist verified malicious actors.
     */
    function confirmThreatSignature(bytes32 _threatId) external onlyRadarNode {
        ThreatProfile storage threat = threatRadarGrid[_threatId];
        require(threat.initialized, "Registry Exception: Targeted threat trace is uninstantiated");
        require(!threat.isBlacklisted, "State Error: Targeted node is already locked under global blacklist");
        require(!nodeVoteMatrix[_threatId][msg.sender], "Access Denied: Telemetry signature already recorded from this node");

        nodeVoteMatrix[_threatId][msg.sender] = true;
        threat.consensusVotes += 1;

        // Requires consensus of at least 2 verification signatures before enforcement activates
        if (threat.consensusVotes >= 2) {
            threat.isBlacklisted = true;
            totalActiveThreats -= 1;
            totalVerifiedScams += 1;
            emit ThreatBlacklisted(_threatId, threat.maliciousDomain, threat.maliciousWallet, true);
        }
    }

    /**
     * @notice High-speed external view for browser extensions or wallet routers to check if a domain/address is safe.
     */
    function queryRadarSecurityStatus(bytes32 _threatId) external view returns (bool, address, ThreatType) {
        ThreatProfile storage threat = threatRadarGrid[_threatId];
        return (threat.isBlacklisted, threat.maliciousWallet, threat.classification);
    }
}
