// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OvertimeLedger: record overtime hours and required premium pay
contract OvertimeLedger {
    struct Overtime {
        uint256 id;
        address worker;
        uint256 hours;
        uint256 premiumRate; // percent above base
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Overtime) public overtimes;
    mapping(address => bool) public stewards;

    event OvertimeLogged(uint256 indexed id, address worker, uint256 hours, uint256 premiumRate);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logOvertime(address worker, uint256 hours, uint256 premiumRate) external {
        require(stewards[msg.sender], "Only steward");
        overtimes[nextId] = Overtime(nextId, worker, hours, premiumRate, block.timestamp);
        emit OvertimeLogged(nextId, worker, hours, premiumRate);
        nextId++;
    }
}
