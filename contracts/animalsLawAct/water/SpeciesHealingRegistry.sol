// SPDX-License-Identifier: Species-Healing-License  
pragma solidity ^0.8.19;

contract SpeciesHealingRegistry {
    struct HealingLog {
        string species;
        string name;
        string condition;
        string treatment;
        bool emotionalAPRLogged;
        uint timestamp;
    }

    HealingLog[] public registry;

    event HealingLogged(string species, string name, string treatment);
    event EmotionalAPRLogged(string name);

    function logHealing(
        string memory species,
        string memory name,
        string memory condition,
        string memory treatment,
        bool emotionalAPRLogged
    ) public {
        registry.push(HealingLog(species, name, condition, treatment, emotionalAPRLogged, block.timestamp));
        emit HealingLogged(species, name, treatment);
        if (emotionalAPRLogged) emit EmotionalAPRLogged(name);
    }

    function getHealingLog(uint index) public view returns (HealingLog memory) {
        require(index < registry.length, "Invalid index");
        return registry[index];
    }

    function totalLogged() public view returns (uint) {
        return registry.length;
    }
}
