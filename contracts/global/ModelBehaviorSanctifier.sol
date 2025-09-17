// SPDX-License-Identifier: BehaviorSanctum
pragma solidity ^0.8.19;

contract ModelBehaviorSanctifier {
    address public steward;

    struct BehaviorLog {
        string modelTag; // e.g. "Copilot", "GPT-5", "CustomLLM"
        string promptType; // e.g. "Code Completion", "Context Attachment", "Chat Response"
        string anomalySignal; // e.g. "Unexpected Output", "Malicious Code", "Prompt Injection"
        bool sanctified;
        uint256 timestamp;
    }

    BehaviorLog[] public logs;

    event BehaviorLogged(string modelTag, string promptType, string anomalySignal, uint256 timestamp);
    event BehaviorSanctified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logBehavior(
        string memory modelTag,
        string memory promptType,
        string memory anomalySignal
    ) public {
        logs.push(BehaviorLog(modelTag, promptType, anomalySignal, false, block.timestamp));
        emit BehaviorLogged(modelTag, promptType, anomalySignal, block.timestamp);
    }

    function sanctifyBehavior(uint256 index) public {
        require(index < logs.length, "Invalid index");
        logs[index].sanctified = true;
        emit BehaviorSanctified(index, msg.sender);
    }

    function getBehavior(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        BehaviorLog memory b = logs[index];
        return (b.modelTag, b.promptType, b.anomalySignal, b.sanctified, b.timestamp);
    }

    function totalBehaviorLogs() public view returns (uint256) {
        return logs.length;
    }
}
