pragma solidity ^0.8.20;

contract OwnershipRevocationProtocol {
    address public admin;

    struct Revocation {
        string product;      // e.g. Tesla FSD, video game, textbook
        string change;       // e.g. one-time purchase -> subscription
        string consequence;  // e.g. loss of ownership, perpetual rent
        uint256 timestamp;
    }

    Revocation[] public revocations;

    event RevocationLogged(string product, string change, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logRevocation(string calldata product, string calldata change, string calldata consequence) external onlyAdmin {
        revocations.push(Revocation(product, change, consequence, block.timestamp));
        emit RevocationLogged(product, change, consequence, block.timestamp);
    }

    function totalRevocations() external view returns (uint256) {
        return revocations.length;
    }
}
