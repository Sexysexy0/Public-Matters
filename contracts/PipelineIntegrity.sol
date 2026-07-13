// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Pipeline Integrity
/// @notice Protects the development pipeline from corruption, sabotage, shortcuts, and external override
contract PipelineIntegrity {
    address public guardian;
    uint256 public stageCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum StageStatus {
        Pending,
        InProgress,
        Completed,
        Blocked
    }

    struct Stage {
        uint256 id;
        string name;
        string description;
        StageStatus status;
        address ownerCreator;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        uint256 stageId;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Stage) public stages;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event StageDeclared(uint256 indexed id, string name, address ownerCreator);
    event StageStatusChanged(uint256 indexed id, StageStatus status);
    event StageLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, uint256 stageId);

    constructor() {
        guardian = msg.sender;
        stageCount = 0;
        violationCount = 0;

        _declareDefaultStages();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultStages() internal {
        _declareStage("Concept", "Initial creative concept and direction", guardian);
        _declareStage("Pre-Production", "Planning, prototyping, pipeline setup", guardian);
        _declareStage("Production", "Full development of core systems and content", guardian);
        _declareStage("Polish", "Refinement, optimization, bug fixing", guardian);
        _declareStage("Finalization", "Locking content, preparing for release", guardian);
    }

    function _declareStage(
        string memory name,
        string memory description,
        address ownerCreator
    ) internal {
        stageCount++;
        stages[stageCount] = Stage(
            stageCount,
            name,
            description,
            StageStatus.Pending,
            ownerCreator,
            false,
            block.timestamp
        );

        emit StageDeclared(stageCount, name, ownerCreator);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareStage(
        string calldata name,
        string calldata description,
        address ownerCreator
    ) external onlyGuardian {
        require(roles[ownerCreator] == RoleType.Creator, "Owner must be creator");
        _declareStage(name, description, ownerCreator);
    }

    function updateStageStatus(uint256 id, StageStatus status) external onlyCreator {
        Stage storage s = stages[id];
        require(!s.locked, "Stage locked");
        require(s.ownerCreator == msg.sender, "Not owner");

        s.status = status;
        emit StageStatusChanged(id, status);
    }

    function lockStage(uint256 id) external onlyCreator {
        Stage storage s = stages[id];
        require(!s.locked, "Already locked");
        require(s.ownerCreator == msg.sender, "Not owner");

        s.locked = true;
        emit StageLocked(id);
    }

    function attemptPipelineOverride(
        uint256 stageId,
        string calldata reason
    ) external {
        RoleType role = roles[msg.sender];
        Stage storage s = stages[stageId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, stageId, reason);
            s.status = StageStatus.Blocked;
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        uint256 stageId,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            stageId,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, stageId);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
