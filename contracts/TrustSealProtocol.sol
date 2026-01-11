pragma solidity ^0.8.20;

contract TrustSealProtocol {
    address public admin;

    struct Seal {
        string entity;       // e.g. partner, project, community
        string status;       // e.g. trusted, pending, revoked
        uint256 timestamp;
    }

    Seal[] public seals;

    event SealLogged(string entity, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logSeal(string calldata entity, string calldata status) external onlyAdmin {
        seals.push(Seal(entity, status, block.timestamp));
        emit SealLogged(entity, status, block.timestamp);
    }

    function totalSeals() external view returns (uint256) {
        return seals.length;
    }
}
