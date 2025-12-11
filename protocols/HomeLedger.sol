// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HomeLedger: register households and their housing status
contract HomeLedger {
    struct Home {
        uint256 id;
        address household;
        string unitURI;      // docs: address, contract, utility proofs
        bool secured;        // has stable housing
        uint256 monthlyDue;  // if any; 0 means none
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Home) public homes;
    mapping(address => bool) public stewards;

    event HomeRegistered(uint256 indexed id, address household, bool secured);
    event StatusUpdated(uint256 indexed id, bool secured, uint256 monthlyDue);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function register(address household, string calldata unitURI, bool secured, uint256 monthlyDue) external {
        require(stewards[msg.sender], "Only steward");
        homes[nextId] = Home(nextId, household, unitURI, secured, monthlyDue, block.timestamp);
        emit HomeRegistered(nextId, household, secured);
        nextId++;
    }

    function updateStatus(uint256 id, bool secured, uint256 monthlyDue) external {
        require(stewards[msg.sender], "Only steward");
        Home storage h = homes[id];
        h.secured = secured;
        h.monthlyDue = monthlyDue;
        emit StatusUpdated(id, secured, monthlyDue);
    }
}
