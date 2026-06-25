// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TalentSovereigntyLedger
 * @notice Cryptographic infrastructure to attest, log, and protect human intellectual property against un-authorized AI scraping and algorithm generation synthesis.
 */
contract TalentSovereigntyLedger {
    event CreationAttested(bytes32 indexed workHash, address indexed creator, string workTitle, bool isFullyHuman);
    event InfringementLogged(bytes32 indexed workHash, string evidenceUrl, uint256 severityTier);
    event VerificationNodeConfigured(address indexed validatorAddress, bool status);

    address public ledgerSteward;
    uint256 public totalAttestedWorks;
    uint256 public totalInfringementClaims;

    struct WorkAttestation {
        address creator;
        string title;
        uint256 registeredBlock;
        bool verifiedHumanMade;
        bool initialSignatureLock;
    }

    struct InfringementLog {
        bytes32 targetWorkHash;
        uint256 alertBlock;
        string proofLink; // Decentralized link tracking AI model scraping or unlicensed duplication
        bool resolved;
    }

    // Master mapping verifying human creative tokens and hashes
    mapping(bytes32 => WorkAttestation) public sovereigntyRegistry;
    // Infringement tracker protecting registered works
    mapping(bytes32 => InfringementLog) public securityBreachLedger;
    // Trusted copyright boards, creative guilds, or independent human networks
    mapping(address => bool) public humanVerificationNodes;

    constructor() {
        ledgerSteward = msg.sender;
        humanVerificationNodes[msg.sender] = true;
    }

    modifier onlySteward() {
        require(msg.sender == ledgerSteward, "Access Denied: Master steward signature validation fail");
        _;
    }

    modifier onlyVerificationNode() {
        require(humanVerificationNodes[msg.sender], "Access Denied: Caller is not an authorized human verification node");
        _;
    }

    /**
     * @notice Authorizes independent creative unions or technical guilds to verify human authenticity signatures.
     */
    function configureVerificationNode(address _node, bool _status) external onlySteward {
        require(_node != address(0), "Parameter Error: Node identity cannot be blank coordinate");
        humanVerificationNodes[_node] = _status;
        emit VerificationNodeConfigured(_node, _status);
    }

    /**
     * @notice Registers and immutably time-stamps a creation hash to prove human origin.
     * @param _workHash The unique Keccak-256 fingerprint/hash of the text, digital design, or asset source file.
     * @param _title Publicly legible metadata title describing the work.
     */
    function attestHumanCreation(bytes32 _workHash, string calldata _title) external {
        require(_workHash != bytes32(0), "Parameter Error: Target creation fingerprint cannot be blank");
        require(!sovereigntyRegistry[_workHash].initialSignatureLock, "Collision Intercept: Provenance token already registered");
        bytes memory titleCheck = bytes(_title);
        require(titleCheck.length > 0, "Parameter Error: Title coordinate cannot be blank");

        sovereigntyRegistry[_workHash] = WorkAttestation({
            creator: msg.sender,
            title: _title,
            registeredBlock: block.number,
            verifiedHumanMade: false, // Default state until validated by a trusted verification node
            initialSignatureLock: true
        });

        totalAttestedWorks += 1;
        emit CreationAttested(_workHash, msg.sender, _title, false);
    }

    /**
     * @notice Upgrades a work's state to 'Verified Human-Made' following review by a validated verification node.
     */
    function validateHumanProvenance(bytes32 _workHash) external onlyVerificationNode {
        WorkAttestation storage asset = sovereigntyRegistry[_workHash];
        require(asset.initialSignatureLock, "Registry Exception: Targeted asset fingerprint does not exist");
        require(!asset.verifiedHumanMade, "State Error: Provenance signature is already certified human-made");

        asset.verifiedHumanMade = true;
        emit CreationAttested(_workHash, asset.creator, asset.title, true);
    }

    /**
     * @notice Logs public incidents where AI frameworks or unauthorized scrapers copy human intellectual properties.
     * @param _claimId Unique cryptographic tracking key for the active incident file.
     * @param _workHash The original registered asset fingerprint affected by the breach.
     * @param _evidenceUrl IPFS or secure storage link demonstrating the unlicensed training data use.
     */
    function logAIScrapingBreach(
        bytes32 _claimId, 
        bytes32 _workHash, 
        string calldata _evidenceUrl
    ) external {
        require(_claimId != bytes32(0) && _workHash != bytes32(0), "Parameter Error: Invalid structural indicators");
        require(sovereigntyRegistry[_workHash].initialSignatureLock, "Registry Exception: Cannot log breach for unregistered work");
        require(!securityBreachLedger[_claimId].resolved, "Collision Intercept: Breach case code already registered");

        securityBreachLedger[_claimId] = InfringementLog({
            targetWorkHash: _workHash,
            alertBlock: block.number,
            proofLink: _evidenceUrl,
            resolved: false
        });

        totalInfringementClaims += 1;
        emit InfringementLogged(_workHash, _evidenceUrl, block.number);
    }
}
