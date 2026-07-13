// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Brand Trust Covenant
/// @notice Establishes brand trust as a constitutional governance principle.
/// @dev Works with CrisisLeadershipFramework and TransparencyCulture to ensure credibility, accountability, and long-term trust.

contract BrandTrustCovenant {
    address public guardian;
    uint256 public trustRuleCount;
    uint256 public caseCount;
    uint256 public councilCount;

    enum RoleType {
        Leader,
        Founder,
        Innovator,
        PublicServant,
        Employee,
        Council,
        Oversight,
        FutureEntity
    }

    enum TrustRule {
        NoTrustErosion,
        NoFalseNarratives,
        NoHiddenData,
        MandatoryTransparency,
        MandatoryPublicClarification,
        MandatoryRootCausePublication,
        AccountabilityOverImage,
        ReputationProtectionOverEgo,
        TrustIsConstitutional,
        TrustOverridesShortTermGain
    }

    enum TrustViolation {
        TrustErosion,
        FalseNarrative,
        HiddenData,
        TransparencyFailure,
        ClarificationFailure,
        RootCauseHidden,
        ImageOverAccountability,
        EgoDrivenDecision,
        ShortTermGainOverTrust
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
        TrustRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        TrustViolation violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, TrustRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, TrustViolation violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        trustRuleCount = 0;
        caseCount = 0;
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

    function assignRole(address account, RoleType role) external onlyGuardian {
        roles[account] = role;
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
        _declareRule(TrustRule.NoTrustErosion, "No decision may erode public trust.");
        _declareRule(TrustRule.NoFalseNarratives, "False narratives are prohibited.");
        _declareRule(TrustRule.NoHiddenData, "Data cannot be hidden.");
        _declareRule(TrustRule.MandatoryTransparency, "Transparency is mandatory.");
        _declareRule(TrustRule.MandatoryPublicClarification, "Public clarification is required after incidents.");
        _declareRule(TrustRule.MandatoryRootCausePublication, "Root cause analysis must be published.");
        _declareRule(TrustRule.AccountabilityOverImage, "Accountability overrides brand image management.");
        _declareRule(TrustRule.ReputationProtectionOverEgo, "Reputation protection overrides ego-driven decisions.");
        _declareRule(TrustRule.TrustIsConstitutional, "Trust is a constitutional principle.");
        _declareRule(TrustRule.TrustOverridesShortTermGain, "Trust overrides short-term gain.");
    }

    function _declareRule(TrustRule ruleType, string memory description) internal {
        trustRuleCount++;
        rules[trustRuleCount] = Rule(
            trustRuleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(trustRuleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileViolation(
        address accused,
        TrustViolation violationType,
        string calldata details
    ) external {
        caseCount++;
        violations[caseCount] = Violation(
            caseCount,
            msg.sender,
            accused,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(caseCount, violationType);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.Filed, "Not filed");
        v.status = CaseStatus.UnderReview;
        emit CaseStatusChanged(caseId, CaseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.UnderReview, "Not under review");
        v.status = CaseStatus.MultiCouncilReview;
        emit CaseStatusChanged(caseId, CaseStatus.MultiCouncilReview);
    }

    function approveViolation(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(v.status == CaseStatus.MultiCouncilReview, "Not in council stage");

        v.approvals++;

        if (v.approvals * 2 > councilCount && councilCount > 0) {
            v.status = CaseStatus.ConfirmedViolation;
            emit CaseStatusChanged(caseId, CaseStatus.ConfirmedViolation);
        }
    }

    function rejectCase(uint256 caseId) external onlyCouncil {
        Violation storage v = violations[caseId];
        require(
            v.status == CaseStatus.Filed ||
            v.status == CaseStatus.UnderReview ||
            v.status == CaseStatus.MultiCouncilReview,
            "Invalid status"
        );
        v.status = CaseStatus.Rejected;
        emit CaseStatusChanged(caseId, CaseStatus.Rejected);
    }
}
