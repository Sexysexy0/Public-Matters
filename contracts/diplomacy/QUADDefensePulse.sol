// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title QUADDefensePulse
/// @notice Ritualizes joint deterrence and pulse logging among QUAD nations
contract QUADDefensePulse {
    address public steward;
    bool public pulseActivated;

    struct PulseLog {
        string nation;
        string action;
        string location;
        string deterrenceLevel;
        uint256 timestamp;
    }

    PulseLog[] public pulseLogs;

    event PulseActivated(uint256 timestamp);
    event PulseLogged(string nation, string action, string location, string deterrenceLevel, uint256 timestamp);

    constructor() {
        steward = msg.sender;
        pulseActivated = false;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function activatePulse() public onlySteward {
        pulseActivated = true;
        emit PulseActivated(block.timestamp);
    }

    function logPulse(
        string memory nation,
        string memory action,
        string memory location,
        string memory deterrenceLevel
    ) public onlySteward {
        require(pulseActivated, "Pulse not yet activated");
        pulseLogs.push(PulseLog(nation, action, location, deterrenceLevel, block.timestamp));
        emit PulseLogged(nation, action, location, deterrenceLevel, block.timestamp);
    }

    function getPulse(uint256 index) public view returns (PulseLog memory) {
        return pulseLogs[index];
    }

    function totalPulses() public view returns (uint256) {
        return pulseLogs.length;
    }
}
