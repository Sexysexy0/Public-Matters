// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SovereignDecentralizedID
/// @notice Safeguard contract to anchor sovereign identities, verify decentralized credentials, and eliminate inconsistent regulatory profiling
contract SovereignDecentralizedID {
    event IdentityAnchored(address indexed subjectNode, bytes32 indexed didDocumentHash);
    event CredentialAttested(address indexed subjectNode, bytes32 indexed claimType, bytes32 metadataHash);
    event CredentialRevoked(address indexed subjectNode, bytes32 indexed claimType, string revocationReason);
    event IdentityStewardTransferred(address indexed oldSteward, address indexed newSteward);

    address public identitySteward;
    bool public structuralAttestationEnforced;
    uint256 public totalIdentitiesAnchored;

    struct IdentityProfile {
        bytes32 didDocumentHash; // Cryptographic pointer to the off-chain secure identity schema
        uint256 registeredAtBlock;
        uint256 cumulativeClaimsCount;
        bool identityCleared;
        bool exists;
    }

    struct CryptographicClaim {
        bytes32 claimType;        // Identifier for the type of credential (e.g., Skill, Degree, Permit)
        bytes32 metadataHash;     // Secure fingerprint of the credential data
        uint256 issuedAtBlock;
        bool isClaimValid;
    }

    // Mapping from unique identity address to global profile structures
    mapping(address => IdentityProfile) public identityRegistry;
    // Mapping from explicit address and claim hash to credential records
    mapping(address => mapping(bytes32 => CryptographicClaim)) public claimsVault;

    constructor() {
        identitySteward = msg.sender;
        structuralAttestationEnforced = true;
    }

    modifier onlySteward() {
        require(msg.sender == identitySteward, "Unauthorized: Identity Steward verification check failed");
        _;
    }

    /// @notice Anchor a clean decentralized identity (DID) document signature for an authorized node or user
    /// @param _subject The target address profile being registered in the system
    /// @param _didDoc Cryptographic layout pointer identifying the verified identity fields
    function anchorIdentity(address _subject, bytes32 _didDoc) external onlySteward {
        require(_subject != address(0) && _didDoc != bytes32(0), "Invalid tracking node coordinate configurations");
        require(!identityRegistry[_subject].exists, "Identity Collision: Selected node identity already anchored");

        identityRegistry[_subject] = IdentityProfile({
            didDocumentHash: _didDoc,
            registeredAtBlock: block.number,
            cumulativeClaimsCount: 0,
            identityCleared: true,
            exists: true
        });

        totalIdentitiesAnchored += 1;
        emit IdentityAnchored(_subject, _didDoc);
    }

    /// @notice Attest and sign an official cryptographic credential claim bypassing human discretion loops
    /// @param _subject Target address profile receiving the verified credential
    /// @param _claimType Identifier code representing the specific metric type (e.g., Keccak256("CERTIFICATE"))
    /// @param _metadata Cryptographic fingerprint profile tracking credential data authenticity parameters
    /// @param _isValidClaims True if objective system checks verify data consistency before assignment
    function issueIdentityCredential(
        address _subject,
        bytes32 _claimType,
        bytes32 _metadata,
        bool _isValidClaims
    ) external onlySteward {
        IdentityProfile storage profile = identityRegistry[_subject];
        require(profile.exists, "Access Denied: Subject identity structure must be anchored first");
        require(profile.identityCleared, "Security Block: Target identity pathway is currently isolated inside quarantine");

        // Anti-Nepotism Guard: Automatically rejects unverified claims attempting entry into the ledger framework
        if (structuralAttestationEnforced && !_isValidClaims) {
            revert("Inconsistent Application: Credential data failed to pass deterministic validation metrics");
        }

        claimsVault[_subject][_claimType] = CryptographicClaim({
            claimType: _claimType,
            metadataHash: _metadata,
            issuedAtBlock: block.number,
            isClaimValid: true
        });

        profile.cumulativeClaimsCount += 1;
        emit CredentialAttested(_subject, _claimType, _metadata);
    }

    /// @notice Revoke an identity claim or credential instantly due to behavior variance or validation faults
    function revokeCredential(address _subject, bytes32 _claimType, string calldata _reason) external onlySteward {
        require(claimsVault[_subject][_claimType].isClaimValid, "Credential Status: Selected claim track is already inactive");
        
        claimsVault[_subject][_claimType].isClaimValid = false;
        emit CredentialRevoked(_subject, _claimType, _reason);
    }

    /// @notice Isolate or clear an entire identity profile block from active interaction queries
    function configureIdentityClearance(address _subject, bool _status) external onlySteward {
        require(identityRegistry[_subject].exists, "Target network identity profile does not exist");
        identityRegistry[_subject].identityCleared = _status;
    }

    /// @notice Toggle the automated continuous timeline verification rules across active system entries
    function toggleAttestationEnforcement(bool _status) external onlySteward {
        structuralAttestationEnforced = _status;
    }

    /// @notice Upgrade or shift the central identity proxy control block to an updated security coordinator node
    function transferIdentityStewardship(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid deployment destination tracking parameters");
        identitySteward = _newSteward;
        emit IdentityStewardTransferred(msg.sender, _newSteward);
    }
}
