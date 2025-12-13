// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OutletLedger: record media outlets and their franchise status
contract OutletLedger {
    struct Outlet {
        uint256 id;
        string name;       // e.g., "MSNBC"
        string type;       // "Broadcast", "Print", "Online"
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Outlet) public outlets;
    mapping(address => bool) public stewards;

    event OutletLogged(uint256 indexed id, string name, string type);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logOutlet(string calldata name, string calldata type, bool active) external {
        require(stewards[msg.sender], "Only steward");
        outlets[nextId] = Outlet(nextId, name, type, active, block.timestamp);
        emit OutletLogged(nextId, name, type);
        nextId++;
    }

    function setActive(uint256 id, bool active) external {
        require(stewards[msg.sender], "Only steward");
        outlets[id].active = active;
    }
}
