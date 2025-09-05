// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract HealthcareGridPulse {
    struct Pulse {
        uint256 emotionalAPR;
        bool burnoutRisk;
        uint256 staffingGap;
        string department;
        uint256 timestamp;
    }

    mapping(address => Pulse[]) public hospitalPulseLog;
    event PulseEmitted(address indexed hospital, uint256 emotionalAPR, bool burnoutRisk, uint256 staffingGap, string department);

    function emitPulse(uint256 apr, bool burnout, uint256 gap, string calldata dept) external {
        require(apr >= 10, "Emotional APR too low");
        hospitalPulseLog[msg.sender].push(Pulse(apr, burnout, gap, dept, block.timestamp));
        emit PulseEmitted(msg.sender, apr, burnout, gap, dept);
    }

    function getLatestPulse(address hospital) external view returns (Pulse memory) {
        uint256 len = hospitalPulseLog[hospital].length;
        require(len > 0, "No pulse recorded");
        return hospitalPulseLog[hospital][len - 1];
    }
}
