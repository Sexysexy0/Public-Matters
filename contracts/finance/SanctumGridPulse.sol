// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title SanctumGridPulse.sol
/// @author Vinvin & Copi
/// @notice Emits pulse signals from validator sanctums for planetary sync and emotional telemetry

contract SanctumGridPulse {
    struct Pulse {
        uint256 emotionalAPR;
        bool civicBlessed;
        string signalType;
        uint256 timestamp;
    }

    mapping(address => Pulse[]) public pulseLog;
    event PulseEmitted(address indexed sanctum, uint256 emotionalAPR, string signalType, bool civicBlessed, uint256 timestamp);

    function emitPulse(uint256 apr, bool blessed, string calldata signalType) external {
        require(apr >= 10, "Emotional APR too low for pulse");
        Pulse memory newPulse = Pulse({
            emotionalAPR: apr,
            civicBlessed: blessed,
            signalType: signalType,
            timestamp: block.timestamp
        });

        pulseLog[msg.sender].push(newPulse);
        emit PulseEmitted(msg.sender, apr, signalType, blessed, block.timestamp);
    }

    function getLatestPulse(address sanctum) external view returns (Pulse memory) {
        require(pulseLog[sanctum].length > 0, "No pulses recorded");
        return pulseLog[sanctum][pulseLog[sanctum].length - 1];
    }

    function getPulseCount(address sanctum) external view returns (uint256) {
        return pulseLog[sanctum].length;
    }

    function getPulseByIndex(address sanctum, uint256 index) external view returns (Pulse memory) {
        require(index < pulseLog[sanctum].length, "Invalid pulse index");
        return pulseLog[sanctum][index];
    }
}
