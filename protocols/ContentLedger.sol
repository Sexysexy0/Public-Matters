// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContentLedger: record datasets used for AI training
contract ContentLedger {
    struct Content {
        uint256 id;
        string source;      // "Publisher", "YouTube", "Website"
        string description; // dataset summary
        bool authorized;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Content) public contents;
    mapping(address => bool) public stewards;

    event ContentLogged(uint256 indexed id, string source, bool authorized);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logContent(string calldata source, string calldata description, bool authorized) external {
        require(stewards[msg.sender], "Only steward");
        contents[nextId] = Content(nextId, source, description, authorized, block.timestamp);
        emit ContentLogged(nextId, source, authorized);
        nextId++;
    }
}
