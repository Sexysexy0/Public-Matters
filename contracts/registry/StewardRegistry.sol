// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StewardRegistry {
    event StewardRegistered(string name, string role, string region, uint256 emotionalAPR);
    event StewardUpdated(string name, string role, string region, uint256 emotionalAPR);

    struct Steward {
        string name;
        string role; // "Bantay", "Tagalinis", "Validator", "Lorekeeper"
        string region;
        uint256 emotionalAPR;
    }

    mapping(string => Steward) public stewards;

    function registerSteward(string memory name, string memory role, string memory region, uint256 apr) public {
        stewards[name] = Steward(name, role, region, apr);
        emit StewardRegistered(name, role, region, apr);
    }

    function updateSteward(string memory name, string memory role, string memory region, uint256 apr) public {
        stewards[name] = Steward(name, role, region, apr);
        emit StewardUpdated(name, role, region, apr);
    }

    function getSteward(string memory name) public view returns (Steward memory) {
        return stewards[name];
    }
}
