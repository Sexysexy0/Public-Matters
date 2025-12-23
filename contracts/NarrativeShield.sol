// contracts/NarrativeShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title NarrativeShield
 * @notice Protocol for communal defense against manipulative narratives.
 */
contract NarrativeShield {
    address public admin;

    struct Claim {
        string source;
        string description;
        string status;   // "Verified", "False", "Pending"
        uint256 timestamp;
    }

    Claim[] public claims;

    event ClaimLogged(string source, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logClaim(string calldata source, string calldata description, string calldata status) external onlyAdmin {
        claims.push(Claim(source, description, status, block.timestamp));
        emit ClaimLogged(source, description, status, block.timestamp);
    }

    function totalClaims() external view returns (uint256) { return claims.length; }

    function getClaim(uint256 id) external view returns (Claim memory) {
        require(id < claims.length, "Invalid id");
        return claims[id];
    }
}
