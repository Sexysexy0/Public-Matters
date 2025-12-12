// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// PulseTimetableMirror: record synchronized timetable slots
contract PulseTimetableMirror {
    struct Slot {
        uint256 id;
        string hub;
        uint256 minuteMark; // e.g., 0 or 30 for clockface
        string direction;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Slot) public slots;
    mapping(address => bool) public stewards;

    event SlotLogged(uint256 indexed id, string hub, uint256 minuteMark);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logSlot(string calldata hub, uint256 minuteMark, string calldata direction) external {
        require(stewards[msg.sender], "Only steward");
        slots[nextId] = Slot(nextId, hub, minuteMark, direction, block.timestamp);
        emit SlotLogged(nextId, hub, minuteMark);
        nextId++;
    }
}
