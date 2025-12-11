// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AgencyLiabilityMirror: record joint liability of agency and principal employer
contract AgencyLiabilityMirror {
    struct Liability {
        uint256 id;
        address agency;
        address principal;
        string caseURI;    // documentation of violation
        bool resolved;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Liability) public liabilities;
    mapping(address => bool) public stewards;

    event LiabilityLogged(uint256 indexed id, address agency, address principal);
    event LiabilityResolved(uint256 indexed id);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logLiability(address agency, address principal, string calldata caseURI) external {
        require(stewards[msg.sender], "Only steward");
        liabilities[nextId] = Liability(nextId, agency, principal, caseURI, false, block.timestamp);
        emit LiabilityLogged(nextId, agency, principal);
        nextId++;
    }

    function resolve(uint256 id) external {
        require(stewards[msg.sender], "Only steward");
        liabilities[id].resolved = true;
        emit LiabilityResolved(id);
    }
}
