// SPDX-License-Identifier: ForkSanctum
pragma solidity ^0.8.19;

contract ForkRiskMitigationRouter {
    struct ForkEvent {
        string forkName;
        string triggerReason; // e.g., "OP_RETURN Expansion", "Taproot Fallout"
        bool replayProtection;
        bool chainSplitOccurred;
        string mitigationStrategy;
        string stakeholderImpact;
        bool postForkAuditComplete;
    }

    mapping(bytes32 => ForkEvent) public events;

    event ForkTagged(string forkName, string triggerReason);
    event MitigationLogged(string forkName);

    function tagFork(string memory forkName, string memory triggerReason, bool replayProtection, bool chainSplitOccurred, string memory mitigationStrategy, string memory stakeholderImpact) public {
        bytes32 eventId = keccak256(abi.encodePacked(forkName, triggerReason, block.timestamp));
        events[eventId] = ForkEvent(forkName, triggerReason, replayProtection, chainSplitOccurred, mitigationStrategy, stakeholderImpact, false);
        emit ForkTagged(forkName, triggerReason);
    }

    function completePostForkAudit(string memory forkName, string memory triggerReason) public {
        bytes32 eventId = keccak256(abi.encodePacked(forkName, triggerReason, block.timestamp));
        events[eventId].postForkAuditComplete = true;
        emit MitigationLogged(forkName);
    }

    function getForkStatus(string memory forkName, string memory triggerReason) public view returns (ForkEvent memory) {
        bytes32 eventId = keccak256(abi.encodePacked(forkName, triggerReason, block.timestamp));
        return events[eventId];
    }
}
