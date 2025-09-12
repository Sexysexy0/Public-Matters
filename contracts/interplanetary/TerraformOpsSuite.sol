// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TerraformOpsSuite {
    struct Habitat {
        uint256 id;
        string zone;
        uint256 oxygenLevel;
        uint256 pressureLevel;
        bool integrityStatus;
        uint256 timestamp;
    }

    mapping(uint256 => Habitat) public habitats;
    uint256 public habitatCount;

    event HabitatUpdated(uint256 id, bool integrityStatus);

    function updateHabitat(
        string memory zone,
        uint256 oxygenLevel,
        uint256 pressureLevel,
        bool integrityStatus,
        uint256 timestamp
    ) public {
        habitats[habitatCount] = Habitat(
            habitatCount, zone, oxygenLevel, pressureLevel, integrityStatus, timestamp
        );
        emit HabitatUpdated(habitatCount, integrityStatus);
        habitatCount++;
    }

    function getHabitat(uint256 id) public view returns (Habitat memory) {
        return habitats[id];
    }
}
