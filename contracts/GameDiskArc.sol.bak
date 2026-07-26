// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GameDiskArc {
    event DiskInserted(address indexed player, string gameId, string artHash, uint256 timestamp);
    event ArtRegistered(string gameId, string artHash, string contributor);
    event ReputationEarned(address indexed contributor, uint256 points);

    mapping(string => string) public gameArt;
    mapping(address => uint256) public reputation;

    function registerArt(string memory gameId, string memory artHash, string memory contributor) external {
        gameArt[gameId] = artHash;
        emit ArtRegistered(gameId, artHash, contributor);
        reputation[msg.sender] += 10;
        emit ReputationEarned(msg.sender, 10);
    }

    function insertDisk(string memory gameId) external {
        string memory artHash = gameArt[gameId];
        emit DiskInserted(msg.sender, gameId, artHash, block.timestamp);
        // ARC: Ritualized launch via Steam URL + art display integration.
    }
}
