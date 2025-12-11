// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// RestPeriodGuard: enforce rest breaks and weekly day-off
contract RestPeriodGuard {
    struct Rest {
        uint256 id;
        address worker;
        string type;       // e.g., "Meal break", "Weekly rest"
        uint256 duration;  // minutes or hours
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Rest) public rests;
    mapping(address => bool) public stewards;

    event RestLogged(uint256 indexed id, address worker, string type, uint256 duration);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRest(address worker, string calldata type, uint256 duration) external {
        require(stewards[msg.sender], "Only steward");
        rests[nextId] = Rest(nextId, worker, type, duration, block.timestamp);
        emit RestLogged(nextId, worker, type, duration);
        nextId++;
    }
}
