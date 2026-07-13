// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title National Security Covenant
/// @notice Firewall for treason and related national security crimes.
/// @dev Encodes safeguards for wartime betrayal, rebellion, espionage, and misprision of treason.

contract NationalSecurityCovenant {
    address public guardian;
    uint256 public safeguardCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum SecurityRule {
        TreasonIsCapital,
        RebellionIsGrave,
        EspionageIsPunishable,
        MisprisionIsAccountable,
        MandatoryCouncilOversight,
        PublicBenefitPriority,
        NationalSecurityIntegrityIsConstitutional
    }

    enum ViolationType {
        Treason,
        Rebellion,
        Espionage,
        Misprision,
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
        SecurityRule ruleType;
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

    event RuleDeclared(uint256 indexed id, SecurityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        safeguardCount = 0;
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
        _declare(SecurityRule.TreasonIsCapital, "Treason is capital — betrayal of the nation is punishable by reclusion perpetua to death.");
        _declare(SecurityRule.RebellionIsGrave, "Rebellion is grave — armed uprising against the state is punishable.");
        _declare(SecurityRule.EspionageIsPunishable, "Espionage is punishable — leaking defense secrets is prohibited.");
        _declare(SecurityRule.MisprisionIsAccountable, "Misprision of treason is accountable — failure to report treason is punishable.");
        _declare(SecurityRule.MandatoryCouncilOversight, "Council oversight required for national security cases.");
        _declare(SecurityRule.PublicBenefitPriority, "Public benefit overrides private gain in national security.");
        _declare(SecurityRule.NationalSecurityIntegrityIsConstitutional, "National security integrity is constitutional.");
    }

    function _declare(SecurityRule ruleType, string memory description) internal {
        safeguardCount++;
        rules[safeguardCount] = Rule(
            safeguardCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(safeguardCount, ruleType);
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
