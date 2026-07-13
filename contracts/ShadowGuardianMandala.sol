// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Shadow Guardian Mandala
/// @notice Encodes safeguard for invisible defender archetype.
/// @dev Complements RiskContextReview, BioHealthMandala, and InnovationFreedomCharter.

contract ShadowGuardianMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum GuardianRule {
        InvisibleDefenderIsConstitutional,
        InterventionMandated,
        InjusticeSuppressed,
        TransparencyInGuardianSystems,
        PublicBenefitPriority
    }

    enum GuardianStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        GuardianConfirmed
    }

    struct Rule {
        uint256 id;
        GuardianRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct GuardianCase {
        uint256 id;
        address proposer;
        string grounds;
        GuardianStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => GuardianCase) public guardianCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, GuardianRule ruleType);
    event RuleLocked(uint256 indexed id);
    event GuardianFiled(uint256 indexed id);
    event GuardianStatusChanged(uint256 indexed id, GuardianStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        mandalaCount = 0;
        councilCount = 0;

        _declareDefaultRules();
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    modifier onlyCouncil() {
        require(councilMember[msg.sender], "Council only");
        _;
    }

    function addCouncilMember(address member) external onlyGuardian {
        require(!councilMember[member], "Already council");
        councilMember[member] = true;
        councilCount++;
        emit CouncilMemberAdded(member);
    }

    function removeCouncilMember(address member) external onlyGuardian {
        require(councilMember[member], "Not council");
        councilMember[member] = false;
        councilCount--;
        emit CouncilMemberRemoved(member);
    }

    function _declareDefaultRules() internal {
        _declare(GuardianRule.InvisibleDefenderIsConstitutional, "Invisible defender is constitutional; denial prohibited.");
        _declare(GuardianRule.InterventionMandated, "Intervention mandated; injustice blocked.");
        _declare(GuardianRule.InjusticeSuppressed, "Injustice suppressed; fairness required.");
        _declare(GuardianRule.TransparencyInGuardianSystems, "Guardian systems must be transparent.");
        _declare(GuardianRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(GuardianRule ruleType, string memory description) internal {
        mandalaCount++;
        rules[mandalaCount] = Rule(
            mandalaCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(mandalaCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileGuardianCase(string calldata grounds) external {
        mandalaCount++;
        guardianCases[mandalaCount] = GuardianCase(
            mandalaCount,
            msg.sender,
            grounds,
            GuardianStatus.Filed,
            0,
            block.timestamp
        );

        emit GuardianFiled(mandalaCount);
    }

    function beginReview(uint256 guardianId) external onlyCouncil {
        GuardianCase storage g = guardianCases[guardianId];
        require(g.status == GuardianStatus.Filed, "Not filed");
        g.status = GuardianStatus.UnderReview;
        emit GuardianStatusChanged(guardianId, GuardianStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 guardianId) external onlyCouncil {
        GuardianCase storage g = guardianCases[guardianId];
        require(g.status == GuardianStatus.UnderReview, "Not under review");
        g.status = GuardianStatus.MultiCouncilReview;
        emit GuardianStatusChanged(guardianId, GuardianStatus.MultiCouncilReview);
    }

    function confirmGuardian(uint256 guardianId) external onlyCouncil {
        GuardianCase storage g = guardianCases[guardianId];
        require(g.status == GuardianStatus.MultiCouncilReview, "Not in council stage");

        g.approvals++;

        if (g.approvals * 2 > councilCount && councilCount > 0) {
            g.status = GuardianStatus.GuardianConfirmed;
            emit GuardianStatusChanged(guardianId, GuardianStatus.GuardianConfirmed);
        }
    }

    function rejectGuardian(uint256 guardianId) external onlyCouncil {
        GuardianCase storage g = guardianCases[guardianId];
        require(
            g.status == GuardianStatus.Filed ||
            g.status == GuardianStatus.UnderReview ||
            g.status == GuardianStatus.MultiCouncilReview,
            "Invalid status"
        );
        g.status = GuardianStatus.Rejected;
        emit GuardianStatusChanged(guardianId, GuardianStatus.Rejected);
    }
}
