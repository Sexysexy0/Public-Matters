// contracts/CredentialAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CredentialAudit
 * @notice Tracks credential verification and communal dignity in identity systems.
 */
contract CredentialAudit {
    address public admin;

    struct Credential {
        string owner;
        string credentialType; // "Diploma", "License", "Certificate"
        string verdict;        // "Verified", "Fake"
        uint256 timestamp;
    }

    Credential[] public credentials;

    event CredentialLogged(string owner, string credentialType, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCredential(string calldata owner, string calldata credentialType, string calldata verdict) external onlyAdmin {
        credentials.push(Credential(owner, credentialType, verdict, block.timestamp));
        emit CredentialLogged(owner, credentialType, verdict, block.timestamp);
    }

    function totalCredentials() external view returns (uint256) { return credentials.length; }

    function getCredential(uint256 id) external view returns (Credential memory) {
        require(id < credentials.length, "Invalid id");
        return credentials[id];
    }
}
