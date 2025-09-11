// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract JusticeChainSanctifier {
    struct ActorTrace {
        string name;
        string role;
        string decisionSummary;
        uint256 timestamp;
        bool linkedToRepeatHarm;
        bool verified;
    }

    mapping(uint256 => ActorTrace) public justiceLedger;
    uint256 public traceCount;

    event ActorSanctified(uint256 id, string name, string role);

    function logActor(
        string memory name,
        string memory role,
        string memory decisionSummary,
        uint256 timestamp,
        bool linkedToRepeatHarm
    ) public {
        justiceLedger[traceCount] = ActorTrace(
            name,
            role,
            decisionSummary,
            timestamp,
            linkedToRepeatHarm,
            false
        );
        emit ActorSanctified(traceCount, name, role);
        traceCount++;
    }

    function verifyActor(uint256 id) public {
        justiceLedger[id].verified = true;
    }

    function getActor(uint256 id) public view returns (ActorTrace memory) {
        return justiceLedger[id];
    }
}
