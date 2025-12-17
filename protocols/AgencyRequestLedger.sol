// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AgencyRequestLedger: record agency budget requests
contract AgencyRequestLedger {
    struct Request {
        uint256 id;
        string agency;      // "DOH", "DepEd"
        string item;        // "Medical Supplies", "Classrooms"
        uint256 amount;
        string status;      // "Requested", "Missing in NEP"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Request) public requests;
    mapping(address => bool) public stewards;

    event RequestLogged(uint256 indexed id, string agency, string item, uint256 amount, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRequest(string calldata agency, string calldata item, uint256 amount, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        requests[nextId] = Request(nextId, agency, item, amount, status, block.timestamp);
        emit RequestLogged(nextId, agency, item, amount, status);
        nextId++;
    }
}
