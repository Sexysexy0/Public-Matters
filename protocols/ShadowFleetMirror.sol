// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ShadowFleetMirror: record shadow fleet operations
contract ShadowFleetMirror {
    struct Operation {
        uint256 id;
        string vessel;
        string origin;
        string destination;
        string tactic;      // "Flag change", "Ship-to-ship transfer"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Operation) public operations;
    mapping(address => bool) public stewards;

    event OperationLogged(uint256 indexed id, string vessel, string tactic);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logOperation(string calldata vessel, string calldata origin, string calldata destination, string calldata tactic) external {
        require(stewards[msg.sender], "Only steward");
        operations[nextId] = Operation(nextId, vessel, origin, destination, tactic, block.timestamp);
        emit OperationLogged(nextId, vessel, tactic);
        nextId++;
    }
}
