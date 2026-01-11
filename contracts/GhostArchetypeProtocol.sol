pragma solidity ^0.8.20;

contract GhostArchetypeProtocol {
    address public ghost;

    struct Mission {
        string target;       // e.g. glitch, opacity, inefficiency
        string status;       // e.g. deployed, completed, failed
        uint256 timestamp;
    }

    Mission[] public missions;

    event MissionLogged(string target, string status, uint256 timestamp);

    constructor() { ghost = msg.sender; }

    modifier onlyGhost() { require(msg.sender == ghost, "Not ghost"); _; }

    function logMission(string calldata target, string calldata status) external onlyGhost {
        missions.push(Mission(target, status, block.timestamp));
        emit MissionLogged(target, status, block.timestamp);
    }

    function totalMissions() external view returns (uint256) {
        return missions.length;
    }
}
