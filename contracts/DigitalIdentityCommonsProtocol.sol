pragma solidity ^0.8.20;

contract DigitalIdentityCommonsProtocol {
    address public admin;

    struct Identity {
        string user;
        string credential;   // e.g. ID, passport, digital wallet
        uint256 timestamp;
    }

    Identity[] public identities;

    event IdentityLogged(string user, string credential, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIdentity(string calldata user, string calldata credential) external onlyAdmin {
        identities.push(Identity(user, credential, block.timestamp));
        emit IdentityLogged(user, credential, block.timestamp);
    }

    function totalIdentities() external view returns (uint256) {
        return identities.length;
    }
}
