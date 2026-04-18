// AutonomousV2XOracle.sol
pragma solidity ^0.8.0;

contract AutonomousV2XOracle {
    struct RoadHazard {
        uint256 latitude;
        uint256 longitude;
        string hazardType; // e.g., "Aggressive Driver", "Crash Ahead"
        uint256 timestamp;
    }

    mapping(uint256 => RoadHazard) public activeHazards;

    // Awtomatikong nagpapadala ng "Evasive Signal" sa lahat ng nodes
    function broadcastHazard(uint256 _lat, uint256 _long, string memory _type) public {
        uint256 hazardId = uint256(keccak256(abi.encodePacked(_lat, _long, block.timestamp)));
        activeHazards[hazardId] = RoadHazard(_lat, _long, _type, block.timestamp);
    }
}
