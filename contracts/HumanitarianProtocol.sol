// HumanitarianProtocol.sol
pragma solidity ^0.8.0;

contract HumanitarianProtocol {
    struct Mission {
        uint256 id;
        string region;       // e.g. "Flood Zone"
        string description;  // e.g. "Emergency food distribution"
        bool deployed;
        uint256 timestamp;
    }

    uint256 public missionCount;
    mapping(uint256 => Mission) public missions;

    event MissionDeployed(uint256 id, string region, string description);

    function deployMission(string memory region, string memory description) public {
        missionCount++;
        missions[missionCount] = Mission(missionCount, region, description, true, block.timestamp);
        emit MissionDeployed(missionCount, region, description);
    }
}
