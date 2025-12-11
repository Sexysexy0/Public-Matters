// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HazardPayRegistry: log extra payments for heavy/unloading tasks
contract HazardPayRegistry {
    struct HazardPay {
        uint256 id;
        address worker;
        string task;       // e.g., "Unloading truck"
        uint256 amount;    // cash incentive
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => HazardPay) public hazardPays;
    mapping(address => bool) public stewards;

    event HazardPayLogged(uint256 indexed id, address worker, string task, uint256 amount);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logHazardPay(address worker, string calldata task, uint256 amount) external {
        require(stewards[msg.sender], "Only steward");
        hazardPays[nextId] = HazardPay(nextId, worker, task, amount, block.timestamp);
        emit HazardPayLogged(nextId, worker, task, amount);
        nextId++;
    }
}
