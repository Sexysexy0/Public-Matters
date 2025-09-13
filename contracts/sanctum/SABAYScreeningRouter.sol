// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SABAYScreeningRouter {
    enum ScreeningType { Cognitive, Motor, Sensory, Behavioral }
    enum RiskLevel { Low, Moderate, High }

    struct ScreeningSignal {
        uint256 id;
        ScreeningType screeningType;
        RiskLevel riskLevel;
        string schoolTag;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ScreeningSignal) public signalRegistry;
    uint256 public signalCount;

    event SignalLogged(uint256 id, ScreeningType screeningType, RiskLevel riskLevel);
    event RiskUpdated(uint256 id, RiskLevel newRiskLevel);

    function logSignal(
        ScreeningType screeningType,
        RiskLevel riskLevel,
        string memory schoolTag,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        signalRegistry[signalCount] = ScreeningSignal(
            signalCount,
            screeningType,
            riskLevel,
            schoolTag,
            clauseReference,
            timestamp
        );
        emit SignalLogged(signalCount, screeningType, riskLevel);
        signalCount++;
    }

    function updateRiskLevel(uint256 id, RiskLevel newRiskLevel) public {
        require(id < signalCount, "Invalid signal ID");
        signalRegistry[id].riskLevel = newRiskLevel;
        emit RiskUpdated(id, newRiskLevel);
    }

    function getSignal(uint256 id) public view returns (ScreeningSignal memory) {
        return signalRegistry[id];
    }
}
