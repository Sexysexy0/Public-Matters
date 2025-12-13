// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PartsRegistry: record manufactured spare parts
contract PartsRegistry {
    struct Part {
        uint256 id;
        string name;        // "Brake Pad", "Chain", "Piston"
        string category;    // "Engine", "Body", "Electrical"
        uint256 price;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Part) public parts;
    mapping(address => bool) public stewards;

    event PartLogged(uint256 indexed id, string name, string category, uint256 price);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logPart(string calldata name, string calldata category, uint256 price) external {
        require(stewards[msg.sender], "Only steward");
        parts[nextId] = Part(nextId, name, category, price, block.timestamp);
        emit PartLogged(nextId, name, category, price);
        nextId++;
    }
}
