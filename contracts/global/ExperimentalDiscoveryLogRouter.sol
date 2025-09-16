// SPDX-License-Identifier: DiscoverySanctum
pragma solidity ^0.8.19;

contract ExperimentalDiscoveryLogRouter {
    struct DiscoveryLog {
        string experimentID;
        string creatorHandle;
        string techDomain;
        string purpose;
        string outcome;
        string learnings;
        string nextSteps;
        bool verified;
    }

    mapping(string => DiscoveryLog) public logRegistry;

    event LogSubmitted(string experimentID, string creatorHandle);
    event LogVerified(string experimentID);

    function submitLog(string memory experimentID, string memory creatorHandle, string memory techDomain, string memory purpose, string memory outcome, string memory learnings, string memory nextSteps) public {
        logRegistry[experimentID] = DiscoveryLog(experimentID, creatorHandle, techDomain, purpose, outcome, learnings, nextSteps, false);
        emit LogSubmitted(experimentID, creatorHandle);
    }

    function verifyLog(string memory experimentID) public {
        require(bytes(logRegistry[experimentID].creatorHandle).length > 0, "Log not found");
        logRegistry[experimentID].verified = true;
        emit LogVerified(experimentID);
    }

    function getLogStatus(string memory experimentID) public view returns (DiscoveryLog memory) {
        return logRegistry[experimentID];
    }
}
