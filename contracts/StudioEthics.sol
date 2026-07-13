// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Studio Ethics
/// @notice Ethical governance for studios; protects creators, culture, and integrity from corporate misconduct
contract StudioEthics {
    address public guardian;
    uint256 public ethicsRuleCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Executive,
        Publisher,
        Subcontractor
    }

    enum EthicsType {
        Transparency,
        FairCompensation,
        AntiManipulation,
        AntiGaslighting,
        AntiRetaliation,
        AntiExploitation,
        AntiCreditTheft,
        AntiSabotage,
        CulturalRespect,
        CreativeHonesty
    }

    struct EthicsRule {
        uint256 id;
        EthicsType ethicsType;
        string description;
        bool locked;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        EthicsType ethicsType;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => EthicsRule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event EthicsRuleDeclared(uint256 indexed id, EthicsType ethicsType);
    event EthicsRuleLocked(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, EthicsType ethicsType);

    constructor() {
        guardian = msg.sender;
        ethicsRuleCount = 0;
        violationCount = 0;

        _declareDefaultEthics();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultEthics() internal {
        _declareRule(EthicsType.Transparency, "Studio must operate with transparency toward creators.");
        _declareRule(EthicsType.FairCompensation, "Creators must receive fair and timely compensation.");
        _declareRule(EthicsType.AntiManipulation, "No manipulation or psychological pressure allowed.");
        _declareRule(EthicsType.AntiGaslighting, "No gaslighting creators about their work or concerns.");
        _declareRule(EthicsType.AntiRetaliation, "Creators cannot be retaliated against for speaking up.");
        _declareRule(EthicsType.AntiExploitation, "Creators cannot be exploited or overworked.");
        _declareRule(EthicsType.AntiCreditTheft, "Creators must receive accurate and full credit.");
        _declareRule(EthicsType.AntiSabotage, "No sabotage of creative work or pipeline.");
        _declareRule(EthicsType.CulturalRespect, "Studio must respect cultural values and diversity.");
        _declareRule(EthicsType.CreativeHonesty, "Studio must be honest about creative direction and changes.");
    }

    function _declareRule(EthicsType ethicsType, string memory description) internal {
        ethicsRuleCount++;
        rules[ethicsRuleCount] = EthicsRule(
            ethicsRuleCount,
            ethicsType,
            description,
            false,
            block.timestamp
        );

        emit EthicsRuleDeclared(ethicsRuleCount, ethicsType);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function declareRule(
        EthicsType ethicsType,
        string calldata description
    ) external onlyGuardian {
        _declareRule(ethicsType, description);
    }

    function lockRule(uint256 id) external onlyCreator {
        EthicsRule storage r = rules[id];
        require(!r.locked, "Already locked");

        r.locked = true;
        emit EthicsRuleLocked(id);
    }

    function attemptEthicsViolation(
        uint256 ruleId,
        string calldata details
    ) external {
        RoleType role = roles[msg.sender];
        EthicsRule storage r = rules[ruleId];

        if (role != RoleType.Creator) {
            _logViolation(msg.sender, role, r.ethicsType, details);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        EthicsType ethicsType,
        string memory details
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            ethicsType,
            details,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, ethicsType);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
