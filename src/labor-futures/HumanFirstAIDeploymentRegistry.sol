// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HumanFirstAIDeploymentRegistry
 * @notice Public registry for AI deployments that may affect workers.
 *
 * Principle: AI should automate tasks, not silently replace people.
 * High-impact deployments require a workforce-impact assessment,
 * transition commitment, and worker-council review.
 */
contract HumanFirstAIDeploymentRegistry {
    enum DeploymentStatus {
        NONE,
        WORKER_COUNCIL_REVIEW,
        APPROVED_WITH_TRANSITION_PLAN,
        REJECTED,
        COMPLETED,
        ROLLED_BACK
    }

    struct Deployment {
        bytes32 id;
        string employer;
        string aiSystem;
        bytes32 impactAssessmentHash;
        uint256 affectedWorkers;
        uint256 transitionFundBps;
        uint256 noLayoffUntil;
        bool workerCouncilApproved;
        DeploymentStatus status;
        uint256 proposedAt;
        uint256 updatedAt;
        string notes;
    }

    address public governor;
    address public workerCouncil;

    mapping(bytes32 => Deployment) private deployments;
    bytes32[] private deploymentIds;

    event DeploymentProposed(
        bytes32 indexed id,
        string employer,
        string aiSystem,
        bytes32 impactAssessmentHash,
        uint256 affectedWorkers,
        uint256 transitionFundBps,
        uint256 noLayoffUntil
    );

    event WorkerCouncilDecision(bytes32 indexed id, bool approved, string notes);

    event DeploymentStatusChanged(bytes32 indexed id, DeploymentStatus status, string notes);

    event WorkerCouncilChanged(address indexed previousCouncil, address indexed newCouncil);

    error Unauthorized();
    error ZeroAddress();
    error DeploymentAlreadyExists();
    error DeploymentNotFound();
    error AlreadyDecided();
    error InvalidTransitionFund();
    error InvalidNoLayoffDeadline();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyWorkerCouncil() {
        if (msg.sender != workerCouncil) revert Unauthorized();
        _;
    }

    modifier deploymentExists(bytes32 id) {
        if (deployments[id].proposedAt == 0) revert DeploymentNotFound();
        _;
    }

    constructor(address initialWorkerCouncil) {
        if (initialWorkerCouncil == address(0)) revert ZeroAddress();

        governor = msg.sender;
        workerCouncil = initialWorkerCouncil;
    }

    function setWorkerCouncil(address newCouncil) external onlyGovernor {
        if (newCouncil == address(0)) revert ZeroAddress();

        emit WorkerCouncilChanged(workerCouncil, newCouncil);
        workerCouncil = newCouncil;
    }

    function proposeDeployment(
        bytes32 id,
        string calldata employer,
        string calldata aiSystem,
        bytes32 impactAssessmentHash,
        uint256 affectedWorkers,
        uint256 transitionFundBps,
        uint256 noLayoffUntil
    ) external onlyGovernor {
        if (deployments[id].proposedAt != 0) {
            revert DeploymentAlreadyExists();
        }
        if (impactAssessmentHash == bytes32(0)) revert ZeroAddress();
        if (transitionFundBps > 10_000) revert InvalidTransitionFund();
        if (noLayoffUntil <= block.timestamp) {
            revert InvalidNoLayoffDeadline();
        }

        deployments[id] = Deployment({
            id: id,
            employer: employer,
            aiSystem: aiSystem,
            impactAssessmentHash: impactAssessmentHash,
            affectedWorkers: affectedWorkers,
            transitionFundBps: transitionFundBps,
            noLayoffUntil: noLayoffUntil,
            workerCouncilApproved: false,
            status: DeploymentStatus.WORKER_COUNCIL_REVIEW,
            proposedAt: block.timestamp,
            updatedAt: block.timestamp,
            notes: ""
        });

        deploymentIds.push(id);

        emit DeploymentProposed(
            id, employer, aiSystem, impactAssessmentHash, affectedWorkers, transitionFundBps, noLayoffUntil
        );
    }

    function workerCouncilDecision(bytes32 id, bool approved, string calldata notes)
        external
        onlyWorkerCouncil
        deploymentExists(id)
    {
        Deployment storage deployment = deployments[id];

        if (deployment.status != DeploymentStatus.WORKER_COUNCIL_REVIEW) {
            revert AlreadyDecided();
        }

        deployment.workerCouncilApproved = approved;
        deployment.status = approved ? DeploymentStatus.APPROVED_WITH_TRANSITION_PLAN : DeploymentStatus.REJECTED;
        deployment.updatedAt = block.timestamp;
        deployment.notes = notes;

        emit WorkerCouncilDecision(id, approved, notes);
    }

    function updateStatus(bytes32 id, DeploymentStatus newStatus, string calldata notes)
        external
        onlyGovernor
        deploymentExists(id)
    {
        Deployment storage deployment = deployments[id];

        if (newStatus != DeploymentStatus.COMPLETED && newStatus != DeploymentStatus.ROLLED_BACK) {
            revert InvalidTransitionFund();
        }

        deployment.status = newStatus;
        deployment.updatedAt = block.timestamp;
        deployment.notes = notes;

        emit DeploymentStatusChanged(id, newStatus, notes);
    }

    function getDeployment(bytes32 id) external view deploymentExists(id) returns (Deployment memory) {
        return deployments[id];
    }

    function totalDeployments() external view returns (uint256) {
        return deploymentIds.length;
    }

    function getAllDeploymentIds() external view returns (bytes32[] memory) {
        return deploymentIds;
    }
}
