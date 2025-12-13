// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ModificationRegistry: record container modifications
contract ModificationRegistry {
    struct Modification {
        uint256 id;
        string type;        // "Housing", "Retail", "Cold Storage"
        string description;
        uint256 cost;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Modification) public modifications;
    mapping(address => bool) public stewards;

    event ModificationLogged(uint256 indexed id, string type, uint256 cost);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logModification(string calldata type, string calldata description, uint256 cost) external {
        require(stewards[msg.sender], "Only steward");
        modifications[nextId] = Modification(nextId, type, description, cost, block.timestamp);
        emit ModificationLogged(nextId, type, cost);
        nextId++;
    }
}
