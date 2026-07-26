// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameArtRegistryArc {
    event ArtRegistered(string gameId, string artHash, address contributor, uint256 timestamp);
    event ReputationEarned(address indexed contributor, uint256 points);
    event ArtVerified(string gameId, string artHash, bool verified);

    mapping(string => string) public gameArt;
    mapping(address => uint256) public reputation;

    function registerArt(string memory gameId, string memory artHash) external {
        gameArt[gameId] = artHash;
        emit ArtRegistered(gameId, artHash, msg.sender, block.timestamp);
        reputation[msg.sender] += 10;
        emit ReputationEarned(msg.sender, 10);
    }

    function verifyArt(string memory gameId, string memory artHash) external view returns (bool) {
        bool verified = keccak256(bytes(gameArt[gameId])) == keccak256(bytes(artHash));
        emit ArtVerified(gameId, artHash, verified);
        return verified;
    }

    function getReputation(address contributor) external view returns (uint256) {
        return reputation[contributor];
    }
}
