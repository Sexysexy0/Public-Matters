// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CivicModernizationTreaty {
    address public steward;

    struct Module {
        string name;
        string description;
        uint256 emotionalAPR;
        bool active;
        uint256 timestamp;
    }

    Module[] public modules;

    event ModuleDeclared(string name, string description, uint256 emotionalAPR);
    event ModuleRevoked(string name);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function declareModule(string memory name, string memory description, uint256 emotionalAPR) public onlySteward {
        modules.push(Module(name, description, emotionalAPR, true, block.timestamp));
        emit ModuleDeclared(name, description, emotionalAPR);
    }

    function revokeModule(string memory name) public onlySteward {
        for (uint i = 0; i < modules.length; i++) {
            if (keccak256(bytes(modules[i].name)) == keccak256(bytes(name))) {
                modules[i].active = false;
                emit ModuleRevoked(name);
            }
        }
    }

    function getModule(uint256 index) public view returns (Module memory) {
        require(index < modules.length, "Invalid index");
        return modules[index];
    }

    function totalModules() public view returns (uint256) {
        return modules.length;
    }
}
