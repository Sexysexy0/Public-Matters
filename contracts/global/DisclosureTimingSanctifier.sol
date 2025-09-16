// SPDX-License-Identifier: TimingSanctum
pragma solidity ^0.8.19;

contract DisclosureTimingSanctifier {
    struct TimingSignal {
        string entityName;
        string timingType; // e.g., "After-Hours", "Pre-Market", "Delayed"
        string riskLevel; // e.g., "Low", "Moderate", "High"
        bool verified;
        string stewardNote;
    }

    mapping(string => TimingSignal) public timingRegistry;

    event TimingTagged(string entityName, string timingType);
    event RiskVerified(string entityName);

    function tagTiming(string memory entityName, string memory timingType, string memory riskLevel, string memory stewardNote) public {
        timingRegistry[entityName] = TimingSignal(entityName, timingType, riskLevel, false, stewardNote);
        emit TimingTagged(entityName, timingType);
    }

    function verifyRisk(string memory entityName) public {
        require(bytes(timingRegistry[entityName].timingType).length > 0, "Entity not tagged");
        timingRegistry[entityName].verified = true;
        emit RiskVerified(entityName);
    }

    function getTimingStatus(string memory entityName) public view returns (TimingSignal memory) {
        return timingRegistry[entityName];
    }
}
