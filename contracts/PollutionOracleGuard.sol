// PollutionOracleGuard.sol
pragma solidity ^0.8.0;

contract PollutionOracleGuard {
    uint256 public toxicityThreshold = 75; // 75% toxicity limit
    bool public operationalPermitStatus = true;

    event CriticalPollutionDetected(uint256 level, string location);

    function syncSensorData(uint256 currentLevel) public {
        if (currentLevel > toxicityThreshold) {
            operationalPermitStatus = false;
            emit CriticalPollutionDetected(currentLevel, "Industrial Zone A");
        } else {
            operationalPermitStatus = true;
        }
    }
}
