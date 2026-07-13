// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Production Mandate
/// @notice Enforces internal production for core work; blocks managerial override and subcontractor takeover
contract ProductionMandate {
    address public guardian;
    uint256 public mandateCount;
    uint256 public violationCount;

    enum WorkType {
        CoreGameplay,
        EngineDevelopment,
        SystemsDesign,
        WorldBuilding,
        NarrativeDesign,
        LevelDesign,
        CoreArtPipeline,
        CoreAnimationPipeline,
        SupportAudio,
        SupportLocalization,
        SupportQA,
        SupportMarketing,
        SupportPorting
    }

    enum RoleType {
        Creator,
        Manager,
        Subcontractor
    }

    struct Mandate {
        uint256 id;
        WorkType work;
        bool internalOnly;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        WorkType work;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Mandate) public mandates;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event MandateDeclared(uint256 indexed id, WorkType work, bool internalOnly);
    event ViolationLogged(uint256 indexed id, address violator, WorkType work, string reason);

    constructor() {
        guardian = msg.sender;
        mandateCount = 0;
        violationCount = 0;

        _declareDefaultMandates();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function _declareDefaultMandates() internal {
        // Core work = internal only
        _declareMandate(WorkType.CoreGameplay, true);
        _declareMandate(WorkType.EngineDevelopment, true);
        _declareMandate(WorkType.SystemsDesign, true);
        _declareMandate(WorkType.WorldBuilding, true);
        _declareMandate(WorkType.NarrativeDesign, true);
        _declareMandate(WorkType.LevelDesign, true);
        _declareMandate(WorkType.CoreArtPipeline, true);
        _declareMandate(WorkType.CoreAnimationPipeline, true);

        // Support work = allowed external
        _declareMandate(WorkType.SupportAudio, false);
        _declareMandate(WorkType.SupportLocalization, false);
        _declareMandate(WorkType.SupportQA, false);
        _declareMandate(WorkType.SupportMarketing, false);
        _declareMandate(WorkType.SupportPorting, false);
    }

    function _declareMandate(WorkType work, bool internalOnly) internal {
        mandateCount++;
        mandates[mandateCount] = Mandate(
            mandateCount,
            work,
            internalOnly,
            block.timestamp
        );

        emit MandateDeclared(mandateCount, work, internalOnly);
    }

    function declareMandate(WorkType work, bool internalOnly) external onlyGuardian {
        _declareMandate(work, internalOnly);
    }

    function logViolation(
        address violator,
        RoleType role,
        WorkType work,
        string calldata reason
    ) external onlyGuardian {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            work,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, work, reason);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function viewMandate(uint256 id) external view returns (Mandate memory) {
        return mandates[id];
    }

    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
