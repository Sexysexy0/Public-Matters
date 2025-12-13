// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// SurplusLedger: record surplus containers
contract SurplusLedger {
    struct Container {
        uint256 id;
        string location;   // "US", "Europe"
        string size;       // "20ft", "40ft"
        bool available;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Container) public containers;
    mapping(address => bool) public stewards;

    event ContainerLogged(uint256 indexed id, string location, string size);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logContainer(string calldata location, string calldata size, bool available) external {
        require(stewards[msg.sender], "Only steward");
        containers[nextId] = Container(nextId, location, size, available, block.timestamp);
        emit ContainerLogged(nextId, location, size);
        nextId++;
    }
}
