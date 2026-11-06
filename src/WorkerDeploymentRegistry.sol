// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title WorkerDeploymentRegistry
 * @notice Prevents hidden worker caps and vanishing NPCs. Tracks all NPCs
 *         permanently. Optimization moves them to UNASSIGNED but never deletes them.
 */
contract WorkerDeploymentRegistry {
    OperatorPrivileges public immutable privileges;

    enum WorkerStatus { UNKNOWN, IDLE, WORKING, UNASSIGNED, QUEST_LOCKED }

    struct Worker {
        bytes32 id;
        bytes32 npcDataHash; // race, class, stats
        bytes32 currentFacility;
        bytes32 questHash; // if locked to a quest
        WorkerStatus status;
        uint256 lastUpdated;
    }

    mapping(bytes32 => Worker) public workers;
    mapping(bytes32 => bytes32[]) public workersByFacility; // FacilityHash => WorkerIds
    mapping(bytes32 => uint256) public activeWorkerCount;   // FacilityHash => count

    event WorkerRegistered(bytes32 indexed workerId, bytes32 npcDataHash);
    event WorkerAssigned(bytes32 indexed workerId, bytes32 indexed facility);
    event WorkerUnassigned(bytes32 indexed workerId, bytes32 reasonHash);
    event WorkerQuestLocked(bytes32 indexed workerId, bytes32 questHash);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function registerWorker(bytes32 workerId, bytes32 npcDataHash) external onlyOperator {
        require(workers[workerId].lastUpdated == 0, "Worker exists");
        workers[workerId] = Worker({
            id: workerId,
            npcDataHash: npcDataHash,
            currentFacility: bytes32(0),
            questHash: bytes32(0),
            status: WorkerStatus.IDLE,
            lastUpdated: block.timestamp
        });
        emit WorkerRegistered(workerId, npcDataHash);
    }

    function assignToFacility(bytes32 workerId, bytes32 facilityHash) external onlyOperator {
        Worker storage w = workers[workerId];
        require(w.lastUpdated != 0, "Worker not found");
        require(w.status != WorkerStatus.QUEST_LOCKED, "Locked to quest");

        // Remove from old facility if any
        if (w.currentFacility != bytes32(0)) {
            activeWorkerCount[w.currentFacility]--;
        }

        w.currentFacility = facilityHash;
        w.status = WorkerStatus.WORKING;
        w.lastUpdated = block.timestamp;
        
        activeWorkerCount[facilityHash]++;
        workersByFacility[facilityHash].push(workerId);

        emit WorkerAssigned(workerId, facilityHash);
    }

    function unassignWorker(bytes32 workerId, bytes32 reasonHash) external onlyOperator {
        Worker storage w = workers[workerId];
        require(w.lastUpdated != 0, "Worker not found");
        
        if (w.currentFacility != bytes32(0)) {
            activeWorkerCount[w.currentFacility]--;
        }

        w.currentFacility = bytes32(0);
        w.status = WorkerStatus.UNASSIGNED; // NOT DELETED
        w.lastUpdated = block.timestamp;

        emit WorkerUnassigned(workerId, reasonHash);
    }

    function lockForQuest(bytes32 workerId, bytes32 questHash) external onlyOperator {
        Worker storage w = workers[workerId];
        w.status = WorkerStatus.QUEST_LOCKED;
        w.questHash = questHash;
        w.lastUpdated = block.timestamp;
        emit WorkerQuestLocked(workerId, questHash);
    }

    function getFacilityWorkers(bytes32 facilityHash) external view returns (bytes32[] memory) {
        return workersByFacility[facilityHash];
    }
}
