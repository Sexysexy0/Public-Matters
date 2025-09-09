// SPDX-License-Identifier: WorkerReentryContinuity-License
pragma solidity ^0.8.0;

contract WorkerReentryContinuityRouter {
    address public steward;

    struct ReentrySignal {
        string workerID;
        string region;
        bool reentryConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    ReentrySignal[] public signals;

    event ReentryRouted(string workerID, string region, bool reentryConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeReentry(string memory workerID, string memory region, bool reentryConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ReentrySignal(workerID, region, reentryConfirmed, clauseType, block.timestamp));
        emit ReentryRouted(workerID, region, reentryConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ReentrySignal memory s = signals[index];
        return (s.workerID, s.region, s.reentryConfirmed, s.clauseType, s.timestamp);
    }
}
