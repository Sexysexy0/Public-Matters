// contracts/SovereignIdentity.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SovereignIdentity
 * @notice Digital ID, communal credentials, mythic verification, and validator-grade privacy.
 */
contract SovereignIdentity {
    address public admin;

    struct Identity {
        address wallet;
        string name;
        string credential;
        bool verified;
        uint256 timestamp;
    }

    Identity[] public identities;

    event IdentityRegistered(address indexed wallet, string name, string credential, bool verified, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerIdentity(address wallet, string calldata name, string calldata credential, bool verified) external onlyAdmin {
        identities.push(Identity(wallet, name, credential, verified, block.timestamp));
        emit IdentityRegistered(wallet, name, credential, verified, block.timestamp);
    }

    function totalIdentities() external view returns (uint256) {
        return identities.length;
    }

    function getIdentity(uint256 id) external view returns (Identity memory) {
        require(id < identities.length, "Invalid id");
        return identities[id];
    }
}
