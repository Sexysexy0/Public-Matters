// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// MemberRightsGuard: record and enforce rights—no interest on member-funded loans, timely release of benefits
contract MemberRightsGuard {
    struct Right {
        uint256 id;
        string name;         // e.g., "Zero-interest on member-funded loans"
        string policyURI;    // rules or resolutions
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Right) public rights;
    mapping(address => bool) public stewards;

    event RightSet(uint256 indexed id, string name, bool active);
    event RightToggled(uint256 indexed id, bool active);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setRight(string calldata name, string calldata policyURI, bool active) external {
        require(stewards[msg.sender], "Only steward");
        rights[nextId] = Right(nextId, name, policyURI, active, block.timestamp);
        emit RightSet(nextId, name, active);
        nextId++;
    }

    function toggle(uint256 id, bool active) external {
        require(stewards[msg.sender], "Only steward");
        rights[id].active = active;
        emit RightToggled(id, active);
    }
}
