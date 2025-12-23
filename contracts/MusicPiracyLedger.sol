// contracts/MusicPiracyLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MusicPiracyLedger
 * @notice Logs piracy claims, dataset sizes, and communal impact.
 */
contract MusicPiracyLedger {
    address public admin;

    struct Claim {
        string source;       // "PirateGroupX"
        uint256 datasetSize; // in terabytes
        string status;       // "Claimed", "Verified", "Disputed"
        uint256 timestamp;
    }

    Claim[] public claims;

    event ClaimLogged(string source, uint256 datasetSize, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logClaim(string calldata source, uint256 datasetSize, string calldata status) external onlyAdmin {
        claims.push(Claim(source, datasetSize, status, block.timestamp));
        emit ClaimLogged(source, datasetSize, status, block.timestamp);
    }

    function totalClaims() external view returns (uint256) { return claims.length; }

    function getClaim(uint256 id) external view returns (Claim memory) {
        require(id < claims.length, "Invalid id");
        return claims[id];
    }
}
