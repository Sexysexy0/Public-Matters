// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PenaltyMirror: record penalties for late contributions
contract PenaltyMirror {
    struct Penalty {
        uint256 id;
        string contributor;
        uint256 amount;
        string reason;      // "Late Payment", "Incomplete Requirements"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Penalty) public penalties;
    mapping(address => bool) public stewards;

    event PenaltyLogged(uint256 indexed id, string contributor, uint256 amount, string reason);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPenalty(string calldata contributor, uint256 amount, string calldata reason) external {
        require(stewards[msg.sender], "Only steward");
        penalties[nextId] = Penalty(nextId, contributor, amount, reason, block.timestamp);
        emit PenaltyLogged(nextId, contributor, amount, reason);
        nextId++;
    }
}
