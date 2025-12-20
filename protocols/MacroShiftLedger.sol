// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// MacroShiftLedger: record macroeconomic events impacting crypto
contract MacroShiftLedger {
    struct Event {
        uint256 id;
        string country;     // "Japan"
        string action;      // "Rate Hike"
        string impact;      // "End of Free Money Era"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Event) public events;
    mapping(address => bool) public stewards;

    event EventLogged(uint256 indexed id, string country, string action, string impact);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logEvent(string calldata country, string calldata action, string calldata impact) external {
        require(stewards[msg.sender], "Only steward");
        events[nextId] = Event(nextId, country, action, impact, block.timestamp);
        emit EventLogged(nextId, country, action, impact);
        nextId++;
    }
}
