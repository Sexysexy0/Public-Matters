// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Sanctuary
/// @notice Protects creators from corporate harm, abuse, exploitation, crunch, and retaliation
contract StudioSanctuary {
    address public guardian;
    uint256 public sanctuaryRuleCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum HarmType {
        Crunch,
        Retaliation,
        Harassment,
        Exploitation,
        CreditRemoval,
        ForcedOverride,
        ForcedDirectionChange,
        CorporateSabotage
    }

    struct SanctuaryRule {
        uint256 id;
        HarmType harmType;
        string description;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        HarmType harmType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => SanctuaryRule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event SanctuaryRuleDeclared(uint256 indexed id, HarmType harmType);
    event SanctuaryRuleLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, HarmType harmType);

    constructor() {
        guardian = msg.sender;
        sanctuaryRuleCount = 0;
        violationCount = 0;

        _declareDefaultSanctuaryRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultSanctuaryRules() internal {
        _declareRule(HarmType.Crunch, "Creators cannot be forced into crunch.");
        _declareRule(HarmType.Retaliation, "Creators cannot be retaliated against for speaking up.");
        _declareRule(HarmType.Harassment, "Creators must be protected from harassment.");
        _declareRule(HarmType.Exploitation, "Creators cannot be exploited or overworked.");
        _declareRule(HarmType.CreditRemoval, "Creators cannot have their credit removed.");
        _declareRule(HarmType.ForcedOverride, "Creators cannot be overridden by managers or executives.");
        _declareRule(HarmType.ForcedDirectionChange, "Creators cannot be forced to change creative direction.");
        _declareRule(HarmType.CorporateSabotage, "Creators must be protected from corporate sabotage.");
    }

    function _declareRule(HarmType harmType, string memory description) internal {
        sanctuaryRuleCount++;
        rules[sanctuaryRuleCount] = SanctuaryRule(
            sanctuaryRuleCount,
            harmType,
            description,
            false,
            block.timestamp
        );

        emit SanctuaryRuleDeclared(sanctuaryRuleCount, harmType);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareRule(
        HarmType harmType,
        string calldata description
    ) external onlyGuardian {
        _declareRule(harmType, description);
    }

    function lockRule(uint256 id) external onlyCreator {
        SanctuaryRule storage r = rules[id];
        require(!r.locked, "Already locked");

        r.locked = true;
        emit SanctuaryRuleLocked(id);
    }

    function attemptHarm(
        uint256 ruleId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        SanctuaryRule storage r = rules[ruleId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, r.harmType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        HarmType harmType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            harmType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, harmType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
