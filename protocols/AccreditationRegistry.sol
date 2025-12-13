// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AccreditationRegistry: record reporter accreditations
contract AccreditationRegistry {
    struct Reporter {
        uint256 id;
        string name;
        string outlet;
        bool accredited;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Reporter) public reporters;
    mapping(address => bool) public stewards;

    event ReporterLogged(uint256 indexed id, string name, string outlet);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logReporter(string calldata name, string calldata outlet, bool accredited) external {
        require(stewards[msg.sender], "Only steward");
        reporters[nextId] = Reporter(nextId, name, outlet, accredited, block.timestamp);
        emit ReporterLogged(nextId, name, outlet);
        nextId++;
    }

    function setAccredited(uint256 id, bool accredited) external {
        require(stewards[msg.sender], "Only steward");
        reporters[id].accredited = accredited;
    }
}
