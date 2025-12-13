// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RemedyGuard: record remedies applied to complaints
contract RemedyGuard {
    struct Remedy {
        uint256 id;
        uint256 complaintId;
        string action;     // "Retraction", "Suspension", "Fine"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Remedy) public remedies;
    mapping(address => bool) public stewards;

    event RemedyLogged(uint256 indexed id, uint256 complaintId, string action);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRemedy(uint256 complaintId, string calldata action, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        remedies[nextId] = Remedy(nextId, complaintId, action, description, block.timestamp);
        emit RemedyLogged(nextId, complaintId, action);
        nextId++;
    }
}
