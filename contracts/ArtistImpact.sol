// contracts/ArtistImpact.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArtistImpact
 * @notice Logs artist-level effects of piracy (income loss, exposure).
 */
contract ArtistImpact {
    address public admin;

    struct Impact {
        string artist;
        string category;   // "IncomeLoss", "Exposure"
        uint256 value;
        string note;
        uint256 timestamp;
    }

    Impact[] public impacts;

    event ImpactLogged(string artist, string category, uint256 value, string note, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logImpact(string calldata artist, string calldata category, uint256 value, string calldata note) external onlyAdmin {
        impacts.push(Impact(artist, category, value, note, block.timestamp));
        emit ImpactLogged(artist, category, value, note, block.timestamp);
    }

    function totalImpacts() external view returns (uint256) { return impacts.length; }

    function getImpact(uint256 id) external view returns (Impact memory) {
        require(id < impacts.length, "Invalid id");
        return impacts[id];
    }
}
