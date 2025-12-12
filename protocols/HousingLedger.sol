// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HousingLedger: record relocation housing units
contract HousingLedger {
    struct Unit {
        uint256 id;
        string site;        // e.g., "Northville 8"
        string type;        // "Rowhouse", "Apartment"
        uint256 families;   // capacity
        bool occupied;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Unit) public units;
    mapping(address => bool) public stewards;

    event UnitLogged(uint256 indexed id, string site, string type, uint256 families);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logUnit(string calldata site, string calldata type, uint256 families, bool occupied) external {
        require(stewards[msg.sender], "Only steward");
        units[nextId] = Unit(nextId, site, type, families, occupied, block.timestamp);
        emit UnitLogged(nextId, site, type, families);
        nextId++;
    }
}
