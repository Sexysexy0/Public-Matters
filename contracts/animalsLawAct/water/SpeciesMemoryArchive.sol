// SPDX-License-Identifier: Species-Memory-License  
pragma solidity ^0.8.19;

contract SpeciesMemoryArchive {
    struct Memory {
        string species;
        string name;
        string healingStory;
        string emotionalAPR;
        string sanctumLocation;
        uint timestamp;
    }

    Memory[] public archive;

    event MemoryArchived(string species, string name, string sanctumLocation);

    function archiveMemory(
        string memory species,
        string memory name,
        string memory healingStory,
        string memory emotionalAPR,
        string memory sanctumLocation
    ) public {
        archive.push(Memory(species, name, healingStory, emotionalAPR, sanctumLocation, block.timestamp));
        emit MemoryArchived(species, name, sanctumLocation);
    }

    function getMemory(uint index) public view returns (Memory memory) {
        require(index < archive.length, "Invalid index");
        return archive[index];
    }

    function totalArchived() public view returns (uint) {
        return archive.length;
    }
}
