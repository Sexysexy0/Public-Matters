// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EcosystemMirror: record ecosystem narrative shifts
contract EcosystemMirror {
    struct Ecosystem {
        uint256 id;
        string chain;       // "Solana", "BNB", "Sui"
        string trend;       // "Growth", "Decline"
        uint256 rank;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Ecosystem) public ecosystems;
    mapping(address => bool) public stewards;

    event EcosystemLogged(uint256 indexed id, string chain, string trend, uint256 rank);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logEcosystem(string calldata chain, string calldata trend, uint256 rank) external {
        require(stewards[msg.sender], "Only steward");
        ecosystems[nextId] = Ecosystem(nextId, chain, trend, rank, block.timestamp);
        emit EcosystemLogged(nextId, chain, trend, rank);
        nextId++;
    }
}
