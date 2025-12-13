// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CustomMirror: record customization projects using spare parts
contract CustomMirror {
    struct Custom {
        uint256 id;
        string project;     // "Cafe Racer Build", "Scooter Upgrade"
        string baseModel;   // "Honda Click", "Suzuki Raider"
        string description;
        uint256 cost;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Custom) public customs;
    mapping(address => bool) public stewards;

    event CustomLogged(uint256 indexed id, string project, string baseModel);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logCustom(string calldata project, string calldata baseModel, string calldata description, uint256 cost) external {
        require(stewards[msg.sender], "Only steward");
        customs[nextId] = Custom(nextId, project, baseModel, description, cost, block.timestamp);
        emit CustomLogged(nextId, project, baseModel);
        nextId++;
    }
}
