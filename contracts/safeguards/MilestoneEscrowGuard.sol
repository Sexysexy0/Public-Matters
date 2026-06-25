// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MilestoneEscrowGuard
 * @notice Engineering solution providing dynamic capital routing locked tightly against strict operational delivery milestones, mitigating agency and contractor failure.
 */
contract MilestoneEscrowGuard {
    event EscrowInitialized(bytes32 indexed ProjectId, address indexed client, address indexed contractor, uint256 totalBudget);
    event MilestoneApproved(bytes32 indexed ProjectId, uint256 milestoneIndex, uint256 payoutDisbursed);
    event DisputeRaised(bytes32 indexed ProjectId, string justification);

    address public escrowArbiter; // Ang tatayong independent auditor o system governor

    struct ProjectEscrow {
        address client;
        address contractor;
        uint256 totalMilestonesCount;
        uint256 currentMilestoneStage;
        uint256 allocationPerStage;
        bool inDispute;
        bool isCompleted;
        bool initialized;
    }

    // Maps a unique project hash directly to its economic escrow parameters
    mapping(bytes32 => ProjectEscrow) public escrowLedger;

    constructor() {
        escrowArbiter = msg.sender;
    }

    modifier onlyArbiter() {
        require(msg.sender == escrowArbiter, "Access Denied: Master arbiter key verification failure");
        _;
    }

    modifier onlyClient(bytes32 _projectId) {
        require(escrowLedger[_projectId].client == msg.sender, "Access Denied: Caller identity is not the registered project owner");
        _;
    }

    /**
     * @notice Provisions a performance-backed escrow vault between a founder and a service partner.
     */
    function initializeProjectVault(
        bytes32 _projectId,
        address _contractor,
        uint256 _stagesCount,
        uint256 _stagePayout
    ) external payable {
        require(_projectId != bytes32(0) && _contractor != address(0), "Parameter Error: Zero addresses or signatures detected");
        require(!escrowLedger[_projectId].initialized, "Collision Intercept: Project ID record already exists");
        require(msg.value == (_stagesCount * _stagePayout), "Value Mismatch: Transmission capital fails to cover overall milestones");

        escrowLedger[_projectId] = ProjectEscrow({
            client: msg.sender,
            contractor: _contractor,
            totalMilestonesCount: _stagesCount,
            currentMilestoneStage: 0,
            allocationPerStage: _stagePayout,
            inDispute: false,
            isCompleted: false,
            initialized: true
        });

        emit EscrowInitialized(_projectId, msg.sender, _contractor, msg.value);
    }

    /**
     * @notice Clientes sign off and release specific funds immediately once a milestone output satisfies standard operational targets.
     */
    function releaseMilestonePayout(bytes32 _projectId) external onlyClient(_projectId) {
        ProjectEscrow storage project = escrowLedger[_projectId];
        require(project.initialized, "Registry Exception: Intended project configuration is missing");
        require(!project.isCompleted, "State Error: Action rejected, target deployment loop already completed");
        require(!project.inDispute, "Security Intervention: Project state is locked under active dispute arbitration");

        uint256 currentStage = project.currentMilestoneStage;
        project.currentMilestoneStage += 1;

        // Route the tranche payout directly to the verified service node
        (bool success, ) = payable(project.contractor).call{value: project.allocationPerStage}("");
        require(success, "Execution Failure: Token stream disbursement rejected by receiver node");

        emit MilestoneApproved(_projectId, currentStage, project.allocationPerStage);

        if (project.currentMilestoneStage == project.totalMilestonesCount) {
            project.isCompleted = true;
        }
    }

    /**
     * @notice Enforces an immediate funding freeze over the assets if a delivery deadline or blueprint requirement fails.
     */
    function toggleProjectDispute(bytes32 _projectId, bool _status, string calldata _reason) external onlyArbiter {
        ProjectEscrow storage project = escrowLedger[_projectId];
        require(project.initialized, "Registry Exception: Project reference uninstantiated");
        project.inDispute = _status;
        emit DisputeRaised(_projectId, _reason);
    }
}
