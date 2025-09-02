contract EmotionalTelemetryLedger {
    struct Pulse {
        uint256 timestamp;
        uint8 stressLevel; // 0–100
        string source;
    }

    Pulse[] public pulses;

    function logPulse(uint8 _stressLevel, string memory _source) public {
        pulses.push(Pulse(block.timestamp, _stressLevel, _source));
    }

    function getLatestPulse() public view returns (Pulse memory) {
        return pulses[pulses.length - 1];
    }
}
