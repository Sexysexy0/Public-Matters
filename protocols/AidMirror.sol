// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AidMirror: record aid requests and government responses
contract AidMirror {
    struct Aid {
        uint256 id;
        string claimant;
        string purpose;     // "Hospital Bill", "Disaster Relief"
        string status;      // "Pending", "Approved", "Denied"
        uint256 amount;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Aid) public aids;
    mapping(address => bool) public stewards;

    event AidLogged(uint256 indexed id, string claimant, string purpose, string status, uint256 amount);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAid(string calldata claimant, string calldata purpose, string calldata status, uint256 amount) external {
        require(stewards[msg.sender], "Only steward");
        aids[nextId] = Aid(nextId, claimant, purpose, status, amount, block.timestamp);
        emit AidLogged(nextId, claimant, purpose, status, amount);
        nextId++;
    }
}
