// contracts/CredentialCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CredentialCommons
 * @notice Communal credential registry for validator-grade transparency.
 */
contract CredentialCommons {
    address public admin;

    struct Credential {
        string holder;
        string credentialType;
        string issuer;
        uint256 timestamp;
    }

    Credential[] public credentials;

    event CredentialLogged(string holder, string credentialType, string issuer, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logCredential(string calldata holder, string calldata credentialType, string calldata issuer) external onlyAdmin {
        credentials.push(Credential(holder, credentialType, issuer, block.timestamp));
        emit CredentialLogged(holder, credentialType, issuer, block.timestamp);
    }

    function totalCredentials() external view returns (uint256) {
        return credentials.length;
    }

    function getCredential(uint256 id) external view returns (Credential memory) {
        require(id < credentials.length, "Invalid id");
        return credentials[id];
    }
}
