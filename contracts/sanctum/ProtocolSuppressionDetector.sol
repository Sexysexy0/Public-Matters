// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolSuppressionDetector {
    enum SuppressionType { BanAttempt, Throttle, Surveillance, ExchangeFreeze }
    enum SeverityLevel { Low, Medium, High, Critical }

    struct SuppressionSignal {
        uint256 id;
        string protocolName;
        SuppressionType suppressionType;
        SeverityLevel severity;
        string jurisdiction;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => SuppressionSignal) public suppressionRegistry;
    uint256 public signalCount;

    event SuppressionLogged(uint256 id, string protocolName, SuppressionType suppressionType, SeverityLevel severity);
    event SeverityUpdated(uint256 id, SeverityLevel newSeverity);

    function logSuppression(
        string memory protocolName,
        SuppressionType suppressionType,
        SeverityLevel severity,
        string memory jurisdiction,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        suppressionRegistry[signalCount] = SuppressionSignal(
            signalCount,
            protocolName,
            suppressionType,
            severity,
            jurisdiction,
            clauseReference,
            timestamp
        );
        emit SuppressionLogged(signalCount, protocolName, suppressionType, severity);
        signalCount++;
    }

    function updateSeverity(uint256 id, SeverityLevel newSeverity) public {
        require(id < signalCount, "Invalid signal ID");
        suppressionRegistry[id].severity = newSeverity;
        emit SeverityUpdated(id, newSeverity);
    }

    function getSuppression(uint256 id) public view returns (SuppressionSignal memory) {
        return suppressionRegistry[id];
    }
}
