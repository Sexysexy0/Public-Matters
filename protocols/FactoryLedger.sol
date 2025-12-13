// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FactoryLedger: record container processing factories
contract FactoryLedger {
    struct Factory {
        uint256 id;
        string name;
        string location;
        string specialization; // "Remodel", "Processing", "Modification"
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Factory) public factories;
    mapping(address => bool) public stewards;

    event FactoryLogged(uint256 indexed id, string name, string specialization);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logFactory(string calldata name, string calldata location, string calldata specialization, bool active) external {
        require(stewards[msg.sender], "Only steward");
        factories[nextId] = Factory(nextId, name, location, specialization, active, block.timestamp);
        emit FactoryLogged(nextId, name, specialization);
        nextId++;
    }
}
