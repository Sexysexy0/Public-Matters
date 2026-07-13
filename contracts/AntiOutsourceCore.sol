// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Anti Outsource Core
/// @notice Hard ban on outsourcing core development; only internal teams may execute core work
contract AntiOutsourceCore {
    address public guardian;
    uint256 public violationCount;
    uint256 public coreListCount;

    enum CoreWork {
        GameplaySystems,
        EngineDevelopment,
        CombatDesign,
        AIProgramming,
        WorldBuilding,
        NarrativeDesign,
        LevelDesign,
        CoreArtPipeline,
        CoreAnimationPipeline
    }

    struct CoreItem {
        uint256 id;
        CoreWork work;
        bool internalOnly;
    }

    struct Violation {
        uint256 id;
        address subcontractor;
        CoreWork work;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => CoreItem) public coreList;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CoreDeclared(uint256 indexed id, CoreWork work);
    event ViolationLogged(uint256 indexed id, address subcontractor, CoreWork work, string details);

    constructor() {
        guardian = msg.sender;
        violationCount = 0;
        coreListCount = 0;

        _declareDefaultCore();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function _declareDefaultCore() internal {
        _declareCore(CoreWork.GameplaySystems);
        _declareCore(CoreWork.EngineDevelopment);
        _declareCore(CoreWork.CombatDesign);
        _declareCore(CoreWork.AIProgramming);
        _declareCore(CoreWork.WorldBuilding);
        _declareCore(CoreWork.NarrativeDesign);
        _declareCore(CoreWork.LevelDesign);
        _declareCore(CoreWork.CoreArtPipeline);
        _declareCore(CoreWork.CoreAnimationPipeline);
    }

    function _declareCore(CoreWork work) internal {
        coreListCount++;
        coreList[coreListCount] = CoreItem(coreListCount, work, true);
        emit CoreDeclared(coreListCount, work);
    }

    function declareCore(CoreWork work) external onlyGuardian {
        _declareCore(work);
    }

    function logViolation(
        address subcontractor,
        CoreWork work,
        string calldata details
    ) external onlyGuardian {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            subcontractor,
            work,
            details,
            block.timestamp
        );
        emit ViolationLogged(violationCount, subcontractor, work, details);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function viewCore(uint256 id) external view returns (CoreItem memory) {
        return coreList[id];
    }

    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
