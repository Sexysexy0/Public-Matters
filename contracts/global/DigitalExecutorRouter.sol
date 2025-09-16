// SPDX-License-Identifier: ExecutorSanctum
pragma solidity ^0.8.19;

contract DigitalExecutorRouter {
    struct ExecutorSignal {
        string legacyID;
        address executor;
        uint256 heartbeatInterval;
        bool executed;
        string stewardNote;
    }

    mapping(string => ExecutorSignal) public executorRegistry;

    event ExecutorTagged(string legacyID, address executor);
    event LegacyExecuted(string legacyID);

    function tagExecutor(string memory legacyID, address executor, uint256 heartbeatInterval, string memory stewardNote) public {
        executorRegistry[legacyID] = ExecutorSignal(legacyID, executor, heartbeatInterval, false, stewardNote);
        emit ExecutorTagged(legacyID, executor);
    }

    function executeLegacy(string memory legacyID, uint256 lastHeartbeatBlock, uint256 currentBlock) public {
        require(currentBlock - lastHeartbeatBlock >= executorRegistry[legacyID].heartbeatInterval, "Vitality check not expired");
        executorRegistry[legacyID].executed = true;
        emit LegacyExecuted(legacyID);
    }

    function getExecutorStatus(string memory legacyID) public view returns (ExecutorSignal memory) {
        return executorRegistry[legacyID];
    }
}
