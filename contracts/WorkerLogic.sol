// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WorkerLogic {
    // [Goal: Scalability through Delegation]
    function setWorkerTask(address _worker, string memory _task) external pure returns (string memory) {
        return string(abi.encodePacked("TASK_ASSIGNED: Worker starting ", _task));
    }
}
