// contracts/MythicVerification.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MythicVerification
 * @notice Validator-grade mythic verification protocol for communal audit.
 */
contract MythicVerification {
    address public admin;

    struct Verification {
        address subject;
        string seal;
        bool status;
        uint256 timestamp;
    }

    Verification[] public verifications;

    event VerificationLogged(address indexed subject, string seal, bool status, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logVerification(address subject, string calldata seal, bool status) external onlyAdmin {
        verifications.push(Verification(subject, seal, status, block.timestamp));
        emit VerificationLogged(subject, seal, status, block.timestamp);
    }

    function totalVerifications() external view returns (uint256) {
        return verifications.length;
    }

    function getVerification(uint256 id) external view returns (Verification memory) {
        require(id < verifications.length, "Invalid id");
        return verifications[id];
    }
}
