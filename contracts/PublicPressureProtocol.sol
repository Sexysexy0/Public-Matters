pragma solidity ^0.8.20;

contract PublicPressureProtocol {
    address public admin;

    struct Pressure {
        string group;        // e.g. consumers, parents, watchdogs
        string demand;       // e.g. AI regulation, child protections
        string outcome;      // e.g. ballot initiative, weakened bill
        uint256 timestamp;
    }

    Pressure[] public pressures;

    event PressureLogged(string group, string demand, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logPressure(string calldata group, string calldata demand, string calldata outcome) external onlyAdmin {
        pressures.push(Pressure(group, demand, outcome, block.timestamp));
        emit PressureLogged(group, demand, outcome, block.timestamp);
    }

    function totalPressures() external view returns (uint256) {
        return pressures.length;
    }
}
