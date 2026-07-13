// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Defense Transparency Covenant
/// @notice Firewall for military and defense contracts, ensuring openness, accountability, and public benefit.
/// @dev Complements NationalSecurityCovenant and SupplyChainTransparency.

contract DefenseTransparency {
    address public guardian;
    uint256 public ruleCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum DefenseRule {
        MandatoryPublicLedgerEntry,
        NoHiddenDefenseContracts,
        NoWeaponizedProcurement,
        MandatoryCouncilOversight,
        PublicBenefitPriority,
        TransparencyOverSecrecy,
        DefenseIntegrityIsConstitutional
    }

    enum ViolationType {
        HiddenContract,
        WeaponizedProcurement,
        LedgerBypass,
        CouncilBypass,
        PublicBenefitErasure,
        TransparencyFailure
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Rule {
        uint256 id;
        DefenseRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        ViolationType violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, DefenseRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        ruleCount = 0;
        violationCount = 0;
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
        _declare(DefenseRule.MandatoryPublicLedgerEntry, "All defense contracts must be logged in the InnovationLedger.");
        _declare(DefenseRule.NoHiddenDefenseContracts, "Hidden defense contracts are prohibited.");
        _declare(DefenseRule.NoWeaponizedProcurement, "Procurement cannot be weaponized for corruption or manipulation.");
        _declare(DefenseRule.MandatoryCouncilOversight, "Council oversight required for defense procurement and contracts.");
        _declare(DefenseRule.PublicBenefitPriority, "Public benefit overrides private profiteering in defense.");
        _declare(DefenseRule.TransparencyOverSecrecy, "Transparency overrides secrecy in defense systems.");
        _declare(DefenseRule.DefenseIntegrityIsConstitutional, "Defense integrity is constitutional.");
    }

    function _declare(DefenseRule ruleType, string memory description) internal {
        ruleCount++;
        rules[ruleCount] = Rule(
            ruleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(ruleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileViolation(
        address accused,
        ViolationType violationType,
        string calldata details
    ) external {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(violationCount, violationType);
    }

    function beginReview(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(violationId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(violationId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(violationId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectViolation(uint256 violationId) external onlyCouncil {
        Violation storage v = violations[violationId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(violationId, CaseStatus.Rejected);
    }
}
