// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// OilLedger: record seized oil cargoes
contract OilLedger {
    struct Cargo {
        uint256 id;
        string origin;      // "Venezuela", "Iran"
        string destination; // "Cuba", "China"
        uint256 barrels;
        bool seized;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Cargo) public cargos;
    mapping(address => bool) public stewards;

    event CargoLogged(uint256 indexed id, string origin, string destination, uint256 barrels);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCargo(string calldata origin, string calldata destination, uint256 barrels, bool seized) external {
        require(stewards[msg.sender], "Only steward");
        cargos[nextId] = Cargo(nextId, origin, destination, barrels, seized, block.timestamp);
        emit CargoLogged(nextId, origin, destination, barrels);
        nextId++;
    }
}
