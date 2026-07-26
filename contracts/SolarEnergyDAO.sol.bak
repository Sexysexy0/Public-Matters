// SolarEnergyDAO.sol
pragma solidity ^0.8.0;

contract SolarEnergyDAO {
    struct Plant {
        uint256 id;
        string zone;     // e.g. "Desert Solar Farm Beta"
        uint256 capacity; // e.g. 200 MW
        bool operational;
    }

    uint256 public plantCount;
    mapping(uint256 => Plant) public plants;

    event PlantOperational(uint256 id, string zone, uint256 capacity);

    function setOperational(string memory zone, uint256 capacity) public {
        plantCount++;
        plants[plantCount] = Plant(plantCount, zone, capacity, true);
        emit PlantOperational(plantCount, zone, capacity);
    }
}
