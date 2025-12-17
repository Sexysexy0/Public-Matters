// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NEPRegistry: record items included in the National Expenditure Program
contract NEPRegistry {
    struct Entry {
        uint256 id;
        string agency;
        string item;
        uint256 amount;
        string status;      // "Included", "Excluded"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Entry) public entries;
    mapping(address => bool) public stewards;

    event EntryLogged(uint256 indexed id, string agency, string item, uint256 amount, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logEntry(string calldata agency, string calldata item, uint256 amount, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        entries[nextId] = Entry(nextId, agency, item, amount, status, block.timestamp);
        emit EntryLogged(nextId, agency, item, amount, status);
        nextId++;
    }
}
