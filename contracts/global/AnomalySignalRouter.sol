// SPDX-License-Identifier: AnomalySanctum
pragma solidity ^0.8.19;

contract AnomalySignalRouter {
    address public steward;

    struct AnomalySignal {
        string modelTag; // e.g. "GPT-5", "Copilot", "CustomLLM"
        string anomalyType; // e.g. "Prompt Injection", "Malicious Output", "Context Poisoning"
        string severityLevel; // e.g. "Low", "Moderate", "Critical"
        bool routed;
        uint256 timestamp;
    }

    AnomalySignal[] public signals;

    event SignalLogged(string modelTag, string anomalyType, string severityLevel, uint256 timestamp);
    event SignalRouted(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logSignal(
        string memory modelTag,
        string memory anomalyType,
        string memory severityLevel
    ) public {
        signals.push(AnomalySignal(modelTag, anomalyType, severityLevel, false, block.timestamp));
        emit SignalLogged(modelTag, anomalyType, severityLevel, block.timestamp);
    }

    function routeSignal(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].routed = true;
        emit SignalRouted(index, msg.sender);
    }

    function getSignal(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        AnomalySignal memory s = signals[index];
        return (s.modelTag, s.anomalyType, s.severityLevel, s.routed, s.timestamp);
    }

    function totalSignals() public view returns (uint256) {
        return signals.length;
    }
}
