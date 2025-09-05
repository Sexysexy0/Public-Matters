// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

contract TrainingPulseOracle {
    struct TrainingPulse {
        uint256 emotionalAPR;
        bool confusionSpike;
        bool mentorSynced;
        string department;
        uint256 timestamp;
    }

    mapping(address => TrainingPulse[]) public pulseLog;
    event PulseLogged(address indexed steward, uint256 emotionalAPR, bool confusionSpike, bool mentorSynced, string department, uint256 timestamp);

    function logTrainingPulse(address steward, uint256 apr, bool confused, bool synced, string calldata dept) external {
        require(apr >= 10, "Emotional APR too low");

        pulseLog[steward].push(TrainingPulse(apr, confused, synced, dept, block.timestamp));
        emit PulseLogged(steward, apr, confused, synced, dept, block.timestamp);
    }

    function getLatestPulse(address steward) external view returns (TrainingPulse memory) {
        uint256 len = pulseLog[steward].length;
        require(len > 0, "No pulse recorded");
        return pulseLog[steward][len - 1];
    }

    function getPulseCount(address steward) external view returns (uint256) {
        return pulseLog[steward].length;
    }
}
