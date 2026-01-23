pragma solidity ^0.8.20;

contract MissionShiftProtocol {
    address public admin;

    struct Mission {
        string era;           // e.g. Obama, Trump, Biden
        string shift;         // e.g. covert ops, reduced missions, domestic focus
        string consequence;   // e.g. weakened CIA, talent drain
        uint256 timestamp;
    }

    Mission[] public missions;

    event MissionLogged(string era, string shift, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMission(string calldata era, string calldata shift, string calldata consequence) external onlyAdmin {
        missions.push(Mission(era, shift, consequence, block.timestamp));
        emit MissionLogged(era, shift, consequence, block.timestamp);
    }

    function totalMissions() external view returns (uint256) {
        return missions.length;
    }
}
