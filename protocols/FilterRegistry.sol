// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FilterRegistry: record audio filters and effects
contract FilterRegistry {
    struct Filter {
        uint256 id;
        string type;        // "EQ", "Compression", "Noise Reduction"
        string status;      // "Applied", "Removed"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Filter) public filters;
    mapping(address => bool) public stewards;

    event FilterLogged(uint256 indexed id, string type, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFilter(string calldata type, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        filters[nextId] = Filter(nextId, type, status, block.timestamp);
        emit FilterLogged(nextId, type, status);
        nextId++;
    }
}
