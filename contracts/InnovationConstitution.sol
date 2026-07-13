// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Constitution
/// @notice Encodes innovation constitution safeguard.
/// @dev Complements InnovationFreedomCharter, ProviderAccountabilityMandala, and PublicBenefitOracle.

contract InnovationConstitution {
    address public guardian;
    uint256 public constitutionCount;
    uint256 public councilCount;

    enum ConstitutionRule {
        InnovationIsConstitutional,
        RenewalMandated,
        StagnationSuppressed,
        CyclesEnabled,
        TransparencyInInnovationConstitution,
        PublicBenefitPriority
    }

    enum ConstitutionStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConstitutionConfirmed
    }

    struct Rule {
        uint256 id;
        ConstitutionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Constitution {
        uint256 id;
        address proposer;
        string grounds;
        ConstitutionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Constitution) public constitutions;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ConstitutionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ConstitutionFiled(uint256 indexed id);
    event ConstitutionStatusChanged(uint256 indexed id, ConstitutionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        constitutionCount = 0;
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
        _declare(ConstitutionRule.InnovationIsConstitutional, "Innovation is constitutional; denial prohibited.");
        _declare(ConstitutionRule.RenewalMandated, "Renewal mandated; stagnation prohibited.");
        _declare(ConstitutionRule.StagnationSuppressed, "Stagnation suppressed; vitality required.");
        _declare(ConstitutionRule.CyclesEnabled, "Cycles enabled; systemic renewal required.");
        _declare(ConstitutionRule.TransparencyInInnovationConstitution, "Innovation constitution must be transparent.");
        _declare(ConstitutionRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ConstitutionRule ruleType, string memory description) internal {
        constitutionCount++;
        rules[constitutionCount] = Rule(
            constitutionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(constitutionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileConstitution(string calldata grounds) external {
        constitutionCount++;
        constitutions[constitutionCount] = Constitution(
            constitutionCount,
            msg.sender,
            grounds,
            ConstitutionStatus.Filed,
            0,
            block.timestamp
        );

        emit ConstitutionFiled(constitutionCount);
    }

    function beginReview(uint256 constitutionId) external onlyCouncil {
        Constitution storage c = constitutions[constitutionId];
        require(c.status == ConstitutionStatus.Filed, "Not filed");
        c.status = ConstitutionStatus.UnderReview;
        emit ConstitutionStatusChanged(constitutionId, ConstitutionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 constitutionId) external onlyCouncil {
        Constitution storage c = constitutions[constitutionId];
        require(c.status == ConstitutionStatus.UnderReview, "Not under review");
        c.status = ConstitutionStatus.MultiCouncilReview;
        emit ConstitutionStatusChanged(constitutionId, ConstitutionStatus.MultiCouncilReview);
    }

    function confirmConstitution(uint256 constitutionId) external onlyCouncil {
        Constitution storage c = constitutions[constitutionId];
        require(c.status == ConstitutionStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ConstitutionStatus.ConstitutionConfirmed;
            emit ConstitutionStatusChanged(constitutionId, ConstitutionStatus.ConstitutionConfirmed);
        }
    }

    function rejectConstitution(uint256 constitutionId) external onlyCouncil {
        Constitution storage c = constitutions[constitutionId];
        require(
            c.status == ConstitutionStatus.Filed ||
            c.status == ConstitutionStatus.UnderReview ||
            c.status == ConstitutionStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ConstitutionStatus.Rejected;
        emit ConstitutionStatusChanged(constitutionId, ConstitutionStatus.Rejected);
    }
}
