// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ImmutableLicensingEngine
/// @notice Safeguard contract to manage sovereign software licenses, authenticate commercial runtime keys, and protect code interfaces
contract ImmutableLicensingEngine {
    event LicenseIssued(address indexed enterpriseNode, bytes32 indexed licenseHash, uint256 expirationBlock);
    event LicenseRevoked(address indexed restrictedNode, bytes32 indexed licenseHash, string reason);
    event LicenseVerificationPassed(address indexed commercialNode, bytes32 indexed licenseHash);
    event LicensingAuthorityTransferred(address indexed oldSteward, address indexed newSteward);

    address public licensingSteward;
    bool public enforceStrictLicensing;
    uint256 public totalActiveLicenses;

    struct LicenseProfile {
        bytes32 licenseKeyHash;
        uint256 issuedAtBlock;
        uint256 expiresAtBlock;
        uint256 allowedThroughputLimit; // Maximum invocation count limits allowed per context
        uint256 currentInvocationCount;
        bool isLicenseActive;
        bool exists;
    }

    struct UsageSnapshot {
        uint256 verifiedAtBlock;
        uint256 recordedThroughput;
        bool integrityCleared;
    }

    // Mapping from unique license key identification hash to structural business profiles
    mapping(bytes32 => LicenseProfile) public licensesVault;
    // Mapping from explicit corporate target node to active license lookup trackers
    mapping(address => bytes32) public nodeLicenseLookup;
    // Mapping from processing track hash to real-time integration audits history
    mapping(bytes32 => UsageSnapshot) public integrationAuditTrail;

    constructor() {
        licensingSteward = msg.sender;
        enforceStrictLicensing = true;
    }

    modifier onlySteward() {
        require(msg.sender == licensingSteward, "Unauthorized: Licensing Steward signature check failed");
        _;
    }

    /// @notice Grant and sign a commercial or dynamic software runtime key for a verified enterprise node configuration
    /// @param _enterpriseNode The target system or agency node receiving integration parameters
    /// @param _licenseId Unique cryptographic token blueprint for tracking authorization parameters
    /// @param _durationBlocks Number of blocks the license remains fully active before expiration verification triggers
    /// @param _maxCalls Maximum allowed operation metrics permitted inside active lifecycle windows
    function issueSovereignLicense(
        address _enterpriseNode,
        bytes32 _licenseId,
        uint256 _durationBlocks,
        uint256 _maxCalls
    ) external onlySteward {
        require(_enterpriseNode != address(0) && _licenseId != bytes32(0), "Invalid licensing destination tracking parameters");
        require(!licensesVault[_licenseId].exists, "Licensing Collision: Core target key sequence already active inside ledger");
        require(_durationBlocks > 0 && _maxCalls > 0, "Parameter Error: License metrics parameters out of core baseline specifications");

        licensesVault[_licenseId] = LicenseProfile({
            licenseKeyHash: _licenseId,
            issuedAtBlock: block.number,
            expiresAtBlock: block.number + _durationBlocks,
            allowedThroughputLimit: _maxCalls,
            currentInvocationCount: 0,
            isLicenseActive: true,
            exists: true
        });

        nodeLicenseLookup[_enterpriseNode] = _licenseId;
        totalActiveLicenses += 1;

        emit LicenseIssued(_enterpriseNode, _licenseId, block.number + _durationBlocks);
    }

    /// @notice Core zero-trust verification filter to audit license integrity before permitting interface usage
    /// @param _enterpriseNode Computational node address requesting system interface execution access
    /// @param _actionPayloadTrace Fingerprint identifier verification profile tracking integration parameters
    /// @param _signatureVerified True if external cryptographic layer matching confirms license certificate alignment
    function verifyLicenseValidity(
        address _enterpriseNode,
        bytes32 _actionPayloadTrace,
        bool _signatureVerified
    ) external onlySteward {
        bytes32 licenseId = nodeLicenseLookup[_enterpriseNode];
        LicenseProfile storage license = licensesVault[licenseId];

        require(license.exists || !enforceStrictLicensing, "Access Denied: Enterprise target profile lacks a valid registered license");
        
        bool passed = true;

        if (enforceStrictLicensing) {
            // Guard Gate 1: Check signature validity parameters
            if (!_signatureVerified) {
                passed = false;
                emit LicenseRevoked(_enterpriseNode, licenseId, "Signature Check Failure: Cryptographic certificate trace mismatch");
            }
            // Guard Gate 2: Check expiration clocks
            if (block.number > license.expiresAtBlock) {
                passed = false;
                license.isLicenseActive = false;
            }
            // Guard Gate 3: Check usage throughput metrics boundaries
            if (license.currentInvocationCount >= license.allowedThroughputLimit) {
                passed = false;
                license.isLicenseActive = false;
            }
            
            require(passed && license.isLicenseActive, "Security Block: Sovereign license profile is currently expired or restricted");
            license.currentInvocationCount += 1;
        }

        integrationAuditTrail[_actionPayloadTrace] = UsageSnapshot({
            verifiedAtBlock: block.number,
            recordedThroughput: license.currentInvocationCount,
            integrityCleared: passed
        });

        if (passed) {
            emit LicenseVerificationPassed(_enterpriseNode, licenseId);
        }
    }

    /// @notice Manually revoke or cancel an active commercial software runtime license profile
    function administrativeRevoke(bytes32 _licenseId, address _associatedNode, string calldata _reason) external onlySteward {
        require(licensesVault[_licenseId].exists, "Target profile configuration profile does not exist");
        require(licensesVault[_licenseId].isLicenseActive, "License Status: Targeted track is already flagged as inactive");

        licensesVault[_licenseId].isLicenseActive = false;
        if (totalActiveLicenses > 0) {
            totalActiveLicenses -= 1;
        }

        emit LicenseRevoked(_associatedNode, _licenseId, _reason);
    }

    /// @notice Toggle the automated continuous software licensing enforcement constraints across connected frameworks
    function toggleStrictLicensing(bool _status) external onlySteward {
        enforceStrictLicensing = _status;
    }

    /// @notice Upgrade or shift the central licensing authority anchor to an updated coordinator node
    function transferLicensingStewardship(address _newSteward) external onlySteward {
        require(_newSteward != address(0), "Invalid deployment destination tracking coordinates parameters");
        licensingSteward = _newSteward;
        emit LicensingAuthorityTransferred(msg.sender, _newSteward);
    }
}
