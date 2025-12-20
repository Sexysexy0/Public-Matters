// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TrustMirror: record broader trust perceptions of companies
contract TrustMirror {
    struct Trust {
        uint256 id;
        string user;
        string company;     // "Amazon"
        string perception;  // "Shady Market", "Distrust"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Trust) public trustRecords;
    mapping(address => bool) public stewards;

    event TrustLogged(uint256 indexed id, string user, string company, string perception);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logTrust(string calldata user, string calldata company, string calldata perception) external {
        require(stewards[msg.sender], "Only steward");
        trustRecords[nextId] = Trust(nextId, user, company, perception, block.timestamp);
        emit TrustLogged(nextId, user, company, perception);
        nextId++;
    }
}
