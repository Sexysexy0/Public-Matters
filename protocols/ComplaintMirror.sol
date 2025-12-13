// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ComplaintMirror: record complaints against outlets or reporters
contract ComplaintMirror {
    struct Complaint {
        uint256 id;
        string complainant;
        string respondent; // outlet or reporter
        string issue;      // "Fake news", "Defamation"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Complaint) public complaints;
    mapping(address => bool) public stewards;

    event ComplaintLogged(uint256 indexed id, string complainant, string respondent);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logComplaint(string calldata complainant, string calldata respondent, string calldata issue) external {
        require(stewards[msg.sender], "Only steward");
        complaints[nextId] = Complaint(nextId, complainant, respondent, issue, block.timestamp);
        emit ComplaintLogged(nextId, complainant, respondent);
        nextId++;
    }
}
