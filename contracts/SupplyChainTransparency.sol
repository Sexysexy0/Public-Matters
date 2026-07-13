// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Supply Chain Transparency Covenant
/// @notice Extends transparency and accountability to global supply chains for critical resources.
/// @dev Complements ResourceSecurityCovenant, GovernanceTransparencyShield, and PublicMattersIntegration.

contract SupplyChainTransparency {
    address public guardian;
    uint256 public chainRuleCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum ChainRule {
        MandatoryLedgerEntry,
        NoHiddenSuppliers,
        NoSanctionBypass,
        MandatoryCouncilOversight,
        PublicBenefitPriority,
        TransparencyOverSecrecy,
        SupplyChainIntegrityIsConstitutional
    }

    enum ViolationType {
        HiddenSupplier,
        SanctionBypass,
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
        ChainRule ruleType;
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

    event RuleDeclared(uint256 indexed id, ChainRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        chainRuleCount = 0;
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
        _declare(ChainRule.MandatoryLedgerEntry, "All supply chain contracts must be logged.");
        _declare(ChainRule.NoHiddenSuppliers, "Hidden suppliers are prohibited.");
        _declare(ChainRule.NoSanctionBypass, "Sanction bypass is prohibited.");
        _declare(ChainRule.MandatoryCouncilOversight, "Council oversight required for global supply chain deals.");
        _declare(ChainRule.PublicBenefitPriority, "Public benefit overrides private secrecy.");
        _declare(ChainRule.TransparencyOverSecrecy, "Transparency overrides secrecy in supply chains.");
        _declare(ChainRule.SupplyChainIntegrityIsConstitutional, "Supply chain integrity is constitutional.");
    }

    function _declare(ChainRule ruleType, string memory description) internal {
        chainRuleCount++;
        rules[chainRuleCount] = Rule(
            chainRuleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(chainRuleCount, ruleType);
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
