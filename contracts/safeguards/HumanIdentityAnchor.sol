// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HumanIdentityAnchor
 * @notice Decentralized identity infrastructure providing tamper-proof humanity verification to distinguish real human agents from automated AI bot syndicates.
 */
contract HumanIdentityAnchor {
    event HumanRegistered(address indexed humanAddress, string biometricProofHash, uint256 anchorBlock);
    event HumanityVouched(address indexed targetHuman, address indexed voucherHuman, uint256 currentVouchCount);
    event VerificationRevoked(address indexed maliciousBotAddress, string reason);
    event AnchorStewardUpdated(address indexed newSteward);

    address public anchorSteward;
    uint256 public totalVerifiedHumans;
    uint256 public constant REQUIRED_VOUCHES = 3; // Kailangan ng 3 kapwa-tao para maging fully certified human

    struct HumanProfile {
        string biometricProofHash; // Encrypted IPFS reference to decentralized identity proofs (e.g., zero-knowledge video pass)
        uint256 registrationBlock;
        uint256 vouchCount;
        bool isCertifiedHuman;
        bool initialized;
    }

    // Master identity grid tracking validated human profiles
    mapping(address => HumanProfile) public identityGrid;
    // Track references to prevent duplicate vouching signatures
    mapping(address => mapping(address => bool)) public peerVouchMatrix;

    constructor() {
        anchorSteward = msg.sender;
        
        // Iselyo ang steward bilang unang certified human para masimulan ang network trust chain
        identityGrid[msg.sender] = HumanProfile({
            biometricProofHash: "GENESIS_NODE_HUMAN_PROOF",
            registrationBlock: block.number,
            vouchCount: REQUIRED_VOUCHES,
            isCertifiedHuman: true,
            initialized: true
        });
        totalVerifiedHumans = 1;
    }

    modifier onlySteward() {
        require(msg.sender == anchorSteward, "Access Denied: Master steward signature validation failure");
        _;
    }

    modifier onlyCertifiedHuman() {
        require(identityGrid[msg.sender].isCertifiedHuman, "Access Denied: Caller identity not authenticated as verified human");
        _;
    }

    /**
     * @notice Allows a new human applicant to initiate their profile with zero-knowledge proof or verification hashes.
     */
    function requestHumanAnchoring(string calldata _proofHash) external {
        require(!identityGrid[msg.sender].initialized, "Collision Intercept: Wallet address already initialized in grid");
        bytes memory proofCheck = bytes(_proofHash);
        require(proofCheck.length > 0, "Parameter Error: Biometric verification fingerprint cannot be blank");

        identityGrid[msg.sender] = HumanProfile({
            biometricProofHash: _proofHash,
            registrationBlock: block.number,
            vouchCount: 0,
            isCertifiedHuman: false,
            initialized: true
        });

        emit HumanRegistered(msg.sender, _proofHash, block.number);
    }

    /**
     * @notice Certified human nodes vouch for an applicant's humanity signature to fight off automated AI sybil accounts.
     */
    function vouchForPeerHumanity(address _targetHuman) external onlyCertifiedHuman {
        HumanProfile storage applicant = identityGrid[_targetHuman];
        require(applicant.initialized, "Registry Exception: Target identity trace is uninstantiated");
        require(!applicant.isCertifiedHuman, "State Error: Targeted profile is already certified human-made");
        require(msg.sender != _targetHuman, "Access Denied: Self-vouching telemetry loops are strictly prohibited");
        require(!peerVouchMatrix[_targetHuman][msg.sender], "Access Denied: Vouching signature already logged from this node");

        peerVouchMatrix[_targetHuman][msg.sender] = true;
        applicant.vouchCount += 1;

        emit HumanityVouched(_targetHuman, msg.sender, applicant.vouchCount);

        // Kapag naabot ang minimum vouching signature thresholds, ia-upgrade ang profile
        if (applicant.vouchCount >= REQUIRED_VOUCHES) {
            applicant.isCertifiedHuman = true;
            totalVerifiedHumans += 1;
        }
    }

    /**
     * @notice Emergency boundary protocol to revoke status if a verified address is taken over by an autonomous AI bot script.
     */
    function flagAndRevokeIdentity(address _botAddress, string calldata _reason) external onlySteward {
        HumanProfile storage profile = identityGrid[_botAddress];
        require(profile.initialized, "Registry Exception: Target profile does not exist");
        require(profile.isCertifiedHuman, "State Error: Targeted profile is not currently certified human");

        profile.isCertifiedHuman = false;
        totalVerifiedHumans -= 1;

        emit VerificationRevoked(_botAddress, _reason);
    }

    /**
     * @notice High-speed on-chain gatekeeper function for outside dApps, voting dApps, or launchpads to verify human presence.
     */
    function isWalletVerifiedHuman(address _wallet) external view returns (bool) {
        return identityGrid[_wallet].isCertifiedHuman;
    }
}
