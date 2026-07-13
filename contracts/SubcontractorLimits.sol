// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Subcontractor Limits
/// @notice Restricts subcontractors to support-only roles; core development must remain internal
contract SubcontractorLimits {
    address public guardian;
    uint256 public limitCount;
    uint256 public violationCount;

    enum RoleType {
        CoreGameplay,
        EngineDevelopment,
        SystemsDesign,
        WorldBuilding,
        NarrativeDesign,
        ArtProduction,
        Animation,
        Audio,
        Localization,
        QA,
        MarketingAssets,
        Porting,
        SupportRole
    }

    struct Limit {
        uint256 id;
        RoleType role;
        bool allowed;
    }

    struct Violation {
        uint256 id;
        address subcontractor;
        RoleType role;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => Limit) public limits;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event LimitDeclared(uint256 indexed id, RoleType role, bool allowed);
    event ViolationLogged(uint256 indexed id, address subcontractor, RoleType role, string reason);

    constructor() {
        guardian = msg.sender;
        limitCount = 0;
        violationCount = 0;

        _declareDefaultLimits();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function _declareDefaultLimits() internal {
        // Core roles = NOT allowed for subcontractors
        _declareLimit(RoleType.CoreGameplay, false);
        _declareLimit(RoleType.EngineDevelopment, false);
        _declareLimit(RoleType.SystemsDesign, false);
        _declareLimit(RoleType.WorldBuilding, false);
        _declareLimit(RoleType.NarrativeDesign, false);

        // Support roles = allowed
        _declareLimit(RoleType.Audio, true);
        _declareLimit(RoleType.Localization, true);
        _declareLimit(RoleType.QA, true);
        _declareLimit(RoleType.MarketingAssets, true);
        _declareLimit(RoleType.Porting, true);
        _declareLimit(RoleType.SupportRole, true);
    }

    function _declareLimit(RoleType role, bool allowed) internal {
        limitCount++;
        limits[limitCount] = Limit(limitCount, role, allowed);
        emit LimitDeclared(limitCount, role, allowed);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function declareLimit(RoleType role, bool allowed) external onlyGuardian {
        _declareLimit(role, allowed);
    }

    function logViolation(
        address subcontractor,
        RoleType role,
        string calldata reason
    ) external onlyGuardian {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            subcontractor,
            role,
            reason,
            block.timestamp
        );
        emit ViolationLogged(violationCount, subcontractor, role, reason);
    }

    function viewLimit(uint256 id) external view returns (Limit memory) {
        return limits[id];
    }

    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
