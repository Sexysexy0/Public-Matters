// SPDX-License-Identifier: SignalSuppressionAudit-License
pragma solidity ^0.8.0;

contract SignalSuppressionAuditRouter {
    address public steward;

    struct SuppressionSignal {
        string signalID;
        string originSanctum;
        bool suppressionDetected;
        string breachType;
        uint256 timestamp;
    }

    SuppressionSignal[] public signals;

    event SuppressionRouted(string signalID, string originSanctum, bool suppressionDetected, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSuppression(string memory signalID, string memory originSanctum, bool suppressionDetected, string memory breachType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(SuppressionSignal(signalID, originSanctum, suppressionDetected, breachType, block.timestamp));
        emit SuppressionRouted(signalID, originSanctum, suppressionDetected, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        SuppressionSignal memory s = signals[index];
        return (s.signalID, s.originSanctum, s.suppressionDetected, s.breachType, s.timestamp);
    }
}
