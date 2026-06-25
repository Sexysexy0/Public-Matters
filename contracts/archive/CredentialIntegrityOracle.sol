// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CredentialIntegrityOracle
/// @notice Safeguard contract to enforce real-time credential verification, manage zero-trust access tokens, and mitigate structural spoofing threats
contract CredentialIntegrityOracle {
    event CredentialVerified(bytes32 indexed credentialId, address indexed userNode, bytes32 indexed validationHash, uint256 timestamp);
    event AccessTokenRevoked(bytes32 indexed credentialId, string revocationReason);
    event SecurityLeakedFlagged(bytes32 indexed credentialId, address indexed compromisedNode, uint256 threatLevel);
    event OracleAuthorityTransferred(address indexed oldAuthority, address indexed newAuthority);

    address public oracleAuthority;
    bool public strictAccessEnforcement;
    uint256 public constant TOKEN_EXPIRATION_WINDOW = 24 hours; // Temporary structural clearance window

    struct CredentialProfile {
        address assignedNode;
        bool isValid;
        bytes32 cryptographicSignatureHash; // Anchor fingerprint of the post-quantum or certified identity token
        uint256 registeredTimestamp;
    }

    // Mapping from unique cryptographic credential ID to active structural profile records
    mapping(bytes32 => CredentialProfile) public credentialRegistry;
    // Public repository tracking revoked or leaked credential hashes
    mapping(bytes32 => bool) public leakedCredentialsHistory;

    constructor() {
        oracleAuthority = msg.sender;
        strictAccessEnforcement = true;
    }

    modifier onlyAuthority() {
        require(msg.sender == oracleAuthority, "Unauthorized: Oracle Authority cryptographic verification failed");
        _;
    }

    /// @notice Initialize and certify a cryptographic identity credential or digital wallet access token
    /// @param _credentialId Unique cryptographic identifier hash assigned to the specific user instance
    /// @param _userNode The interaction proxy wallet or apparatus node address
    /// @param _signatureHash The base cryptographic token commitment mapping
    function certifyCredential(
        bytes32 _credentialId,
        address _userNode,
        bytes32 _signatureHash
    ) external onlyAuthority {
        require(_credentialId != bytes32(0), "Invalid credential hash configuration");
        require(_userNode != address(0), "Invalid user apparatus coordinates");
        require(!leakedCredentialsHistory[_credentialId], "Access Denied: Credential token listed in permanent compromise history");
        require(!credentialRegistry[_credentialId].isValid, "Credential blueprint instance already active in registry");

        credentialRegistry[_credentialId] = CredentialProfile({
            assignedNode: _userNode,
            isValid: true,
            cryptographicSignatureHash: _signatureHash,
            registeredTimestamp: block.timestamp
        });

        emit CredentialVerified(_credentialId, _userNode, _signatureHash, block.timestamp);
    }

    /// @notice Real-time verification gate for zero-trust endpoint access control
    /// @dev Implements temporal and status validation checking for active network nodes
    function verifyCredentialClearance(bytes32 _credentialId, address _userNode) external view returns (bool) {
        CredentialProfile memory profile = credentialRegistry[_credentialId];
        
        if (!profile.isValid || profile.assignedNode != _userNode) {
            return false;
        }

        if (strictAccessEnforcement) {
            // Temporal access evaluation: Prevent expired session authorization
            if (block.timestamp > profile.registeredTimestamp + TOKEN_EXPIRATION_WINDOW) {
                return false;
            }
        }

        return true;
    }

    /// @notice Instantly flag, freeze, and isolate leaked or compromised system configurations
    /// @param _credentialId Cryptographic verification identity string of the compromised token
    /// @param _node Address of the unverified or exposed interaction node
    /// @param _threat Scale of 1 to 5 describing the security breach severity
    function pushCredentialLeakReport(
        bytes32 _credentialId,
        address _node,
        uint256 _threat
    ) external onlyAuthority {
        require(credentialRegistry[_credentialId].isValid, "Target profile registration not active");
        require(_threat >= 1 && _threat <= 5, "Threat scope boundary exception: must scale 1 to 5");

        credentialRegistry[_credentialId].isValid = false;
        leakedCredentialsHistory[_credentialId] = true;

        emit SecurityLeakedFlagged(_credentialId, _node, _threat);
        emit AccessTokenRevoked(_credentialId, "EMERGENCY_ISOLATION: Token compromised via verified external threat vector");
    }

    /// @notice Revoke active credential status manually during system hardening operations
    function revokeCredentialManually(bytes32 _credentialId, string memory _reason) external onlyAuthority {
        require(credentialRegistry[_credentialId].isValid, "Target instance profile not active");
        credentialRegistry[_credentialId].isValid = false;
        emit AccessTokenRevoked(_credentialId, _reason);
    }

    /// @notice Toggle strict temporal verification parameters across all routing nodes
    function toggleAccessControls(bool _strictMode) external onlyAuthority {
        strictAccessEnforcement = _strictMode;
    }

    /// @notice Upgrade or migrate the central Oracle Authority cryptographic validation block
    function transferOracleAuthority(address _newAuthority) external onlyAuthority {
        require(_newAuthority != address(0), "Invalid upgrade destination coordinates");
        emit OracleAuthorityTransferred(oracleAuthority, _newAuthority);
        oracleAuthority = _newAuthority;
    }
}
