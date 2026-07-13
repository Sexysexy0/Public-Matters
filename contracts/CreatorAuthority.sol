// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Creator Authority
/// @notice Gives creators final say across all systems; blocks managerial override and subcontractor interference
contract CreatorAuthority {
    address public guardian;
    uint256 public authorityCount;
    uint256 public decisionCount;
    uint256 public violationCount;

    enum RoleType {
        Creator,
        Manager,
        Subcontractor
    }

    enum DecisionStatus {
        Pending,
        Finalized,
        OverriddenAttempt
    }

    struct AuthorityRule {
        uint256 id;
        string domain;
        bool creatorHasFinalSay;
        uint256 timestamp;
    }

    struct Decision {
        uint256 id;
        string subject;
        address creator;
        DecisionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address violator;
        RoleType role;
        string subject;
        string reason;
        uint256 timestamp;
    }

    mapping(uint256 => AuthorityRule) public rules;
    mapping(uint256 => Decision) public decisions;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event RoleAssigned(address indexed account, RoleType role);
    event RuleDeclared(uint256 indexed id, string domain);
    event DecisionSubmitted(uint256 indexed id, string subject, address creator);
    event DecisionFinalized(uint256 indexed id);
    event ViolationLogged(uint256 indexed id, address violator, string subject);

    constructor() {
        guardian = msg.sender;
        authorityCount = 0;
        decisionCount = 0;
        violationCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    modifier onlyCreator() {
        require(roles[msg.sender] == RoleType.Creator, "Creator only");
        _;
    }

    function _declareDefaultRules() internal {
        _declareRule("Gameplay Direction");
        _declareRule("Engine Architecture");
        _declareRule("Systems Design");
        _declareRule("Narrative Direction");
        _declareRule("Worldbuilding");
        _declareRule("Art Style");
        _declareRule("Animation Style");
        _declareRule("Combat Philosophy");
    }

    function _declareRule(string memory domain) internal {
        authorityCount++;
        rules[authorityCount] = AuthorityRule(
            authorityCount,
            domain,
            true,
            block.timestamp
        );

        emit RuleDeclared(authorityCount, domain);
    }

    function declareRule(string calldata domain) external onlyGuardian {
        _declareRule(domain);
    }

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function submitDecision(string calldata subject) external onlyCreator {
        decisionCount++;
        decisions[decisionCount] = Decision(
            decisionCount,
            subject,
            msg.sender,
            DecisionStatus.Pending,
            0,
            block.timestamp
        );

        emit DecisionSubmitted(decisionCount, subject, msg.sender);
    }

    function finalizeDecision(uint256 id) external onlyCreator {
        Decision storage d = decisions[id];
        require(d.status == DecisionStatus.Pending, "Not pending");

        d.status = DecisionStatus.Finalized;
        emit DecisionFinalized(id);
    }

    function attemptOverride(uint256 decisionId, string calldata reason) external {
        RoleType role = roles[msg.sender];

        if (role != RoleType.Creator) {
            Decision storage d = decisions[decisionId];
            d.status = DecisionStatus.OverriddenAttempt;

            _logViolation(msg.sender, role, d.subject, reason);
        }
    }

    function _logViolation(
        address violator,
        RoleType role,
        string memory subject,
        string memory reason
    ) internal {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            violator,
            role,
            subject,
            reason,
            block.timestamp
        );

        emit ViolationLogged(violationCount, violator, subject);
    }

    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }
}
