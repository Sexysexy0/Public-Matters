// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HeritageMirror: record heritage defense and communal resistance
contract HeritageMirror {
    struct Defense {
        uint256 id;
        string community;   // "Vendor Association", "Tourist Group"
        string action;      // "Petition", "Protest", "Heritage Declaration"
        string status;      // "Ongoing", "Succeeded", "Failed"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Defense) public defenses;
    mapping(address => bool) public stewards;

    event DefenseLogged(uint256 indexed id, string community, string action, string status);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logDefense(string calldata community, string calldata action, string calldata status) external {
        require(stewards[msg.sender], "Only steward");
        defenses[nextId] = Defense(nextId, community, action, status, block.timestamp);
        emit DefenseLogged(nextId, community, action, status);
        nextId++;
    }
}
