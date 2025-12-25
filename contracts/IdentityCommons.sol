// contracts/IdentityCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IdentityCommons
 * @notice Logs communal digital identity initiatives and equity in access.
 */
contract IdentityCommons {
    address public admin;

    struct Identity {
        string holder;      // "Citizen", "Worker", "Student"
        string type;        // "NationalID", "BlockchainID"
        string status;      // "Active", "Pending", "Revoked"
        uint256 timestamp;
    }

    Identity[] public identities;

    event IdentityLogged(string holder, string type, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIdentity(string calldata holder, string calldata type, string calldata status) external onlyAdmin {
        identities.push(Identity(holder, type, status, block.timestamp));
        emit IdentityLogged(holder, type, status, block.timestamp);
    }

    function totalIdentities() external view returns (uint256) { return identities.length; }

    function getIdentity(uint256 id) external view returns (Identity memory) {
        require(id < identities.length, "Invalid id");
        return identities[id];
    }
}
