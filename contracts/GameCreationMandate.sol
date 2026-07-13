// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Game Creation Mandate
/// @notice Ensures core game development is done internally, not outsourced
contract GameCreationMandate {
    address public guardian;
    uint256 public ruleCount;
    uint256 public violationCount;

    enum WorkType {
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

    struct Rule {
        uint256 id;
        WorkType workType;
        bool allowedForSubcontractors;
    }

    struct Violation {
        uint256 id;
        address subcontractor;
        WorkType workType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RuleDeclared(uint256 indexed id, WorkType workType, bool allowedForSubcontractors);
    event ViolationLogged(uint256 indexed id, address subcontractor, WorkType workType, string details);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        violationCount = 0;

        // Default rules: core work MUST be internal
        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    function _declareDefaultRules() internal {
        // Core work = NOT allowed for subcontractors
        _declareRule(WorkType.CoreGameplay, false);
        _declareRule(WorkType.EngineDevelopment, false);
        _declareRule(WorkType.SystemsDesign, false);
        _declareRule(WorkType.WorldBuilding, false);
        _declareRule(WorkType.NarrativeDesign, false);

        // Support work = allowed
        _declareRule(WorkType.Audio, true);
        _declareRule(WorkType.Localization, true);
        _declareRule(WorkType.QA, true);
        _declareRule(WorkType.MarketingAssets, true);
        _declareRule(WorkType.Porting, true);
        _declareRule(WorkType.SupportRole, true);
    }

    function _declareRule(WorkType workType, bool allowed) internal {
        ruleCount++;
        rules[ruleCount] = Rule(ruleCount, workType, allowed);
        emit RuleDeclared(ruleCount, workType, allowed);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    function declareRule(WorkType workType, bool allowed) external onlyGuardian {
        _declareRule(workType, allowed);
    }

    function logViolation(
        address subcontractor,
        WorkType workType,
        string calldata details
    ) external onlyGuardian {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            subcontractor,
            workType,
            details,
            block.timestamp
        );
        emit ViolationLogged(violationCount, subcontractor, workType, details);
    }

    function viewRule(uint256 id) external view returns (Rule memory) {
        return rules[id];
    }

    function viewViolation(uint256 id) external view returns (Violation memory) {
        return violations[id];
    }
}
