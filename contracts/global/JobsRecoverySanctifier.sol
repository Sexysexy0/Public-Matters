// SPDX-License-Identifier: LaborSanctum
pragma solidity ^0.8.19;

contract JobsRecoverySanctifier {
    struct Worker {
        string name;
        string sector;
        bool displaced;
        bool retrainingActivated;
        uint256 grantAmount;
    }

    mapping(address => Worker) public workers;

    event WorkerTagged(address indexed steward, string sector);
    event RetrainingActivated(address indexed steward, uint256 grantAmount);

    function tagDisplacedWorker(string memory name, string memory sector) public {
        workers[msg.sender] = Worker(name, sector, true, false, 0);
        emit WorkerTagged(msg.sender, sector);
    }

    function activateRetraining(address steward, uint256 grantAmount) public {
        require(workers[steward].displaced, "Worker must be tagged first");
        workers[steward].retrainingActivated = true;
        workers[steward].grantAmount = grantAmount;
        emit RetrainingActivated(steward, grantAmount);
    }

    function getWorkerStatus(address steward) public view returns (Worker memory) {
        return workers[steward];
    }
}
