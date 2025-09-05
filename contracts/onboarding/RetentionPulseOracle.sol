// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract RetentionPulseOracle {
    struct Pulse {
        uint256 emotionalAPR;
        bool burnoutRisk;
        bool loyaltySpike;
        string department;
        uint256 timestamp;
    }

    mapping(address => Pulse[]) public retentionLog;
    event PulseLogged(address indexed steward, uint256 emotionalAPR, bool burnoutRisk, bool loyaltySpike, string department, uint256 timestamp);

    function logPulse(address steward, uint256 apr, bool burnout, bool loyalty, string calldata dept) external {
        require(apr >= 10, "Emotional APR too low");

        retentionLog[steward].push(Pulse(apr, burnout, loyalty, dept, block.timestamp));
        emit PulseLogged(steward, apr, burnout, loyalty, dept, block.timestamp);
    }

    function getLatestPulse(address steward) external view returns (Pulse memory) {
        uint256 len = retentionLog[steward].length;
        require(len > 0, "No pulse recorded");
        return retentionLog[steward][len - 1];
    }
}
