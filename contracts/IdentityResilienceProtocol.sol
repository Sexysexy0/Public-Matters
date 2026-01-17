pragma solidity ^0.8.20;

contract IdentityResilienceProtocol {
    address public admin;

    struct Identity {
        string challenge;    // e.g. AI displacement, adversity
        string response;     // e.g. resilience, growth, re-tooling
        uint256 timestamp;
    }

    Identity[] public identities;

    event IdentityLogged(string challenge, string response, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logIdentity(string calldata challenge, string calldata response) external onlyAdmin {
        identities.push(Identity(challenge, response, block.timestamp));
        emit IdentityLogged(challenge, response, block.timestamp);
    }

    function totalIdentities() external view returns (uint256) {
        return identities.length;
    }
}
