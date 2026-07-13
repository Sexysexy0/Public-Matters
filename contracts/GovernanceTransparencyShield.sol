// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Governance Transparency Shield
/// @notice Prevents shell company drains, insider funds, and political profiteering from government procurement.
/// @dev Integrates with PublicMattersIntegration, InnovationLedger, and SupremeCourt oversight.

contract GovernanceTransparencyShield {
    address public guardian;
    uint256 public safeguardCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum Safeguard {
        NoShellCompanyProcurement,
        NoPoliticalFamilyFunds,
        MandatoryConflictDisclosure,
        MandatoryPublicLedgerEntry,
        MandatoryCouncilOversight,
        NoRapidContractAfterInvestment,
        TransparencyOverAccess,
        PublicBenefitOverPrivateGain,
        ProcurementIntegrityIsConstitutional
    }

    enum ViolationType {
        ShellCompanyDrain,
        PoliticalFamilyFund,
        HiddenConflict,
        LedgerBypass,
        CouncilBypass,
        RapidContractAfterInvestment,
        TransparencyFailure,
        PublicBenefitErasure
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
        Safeguard safeguardType;
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

    mapping(uint256 => Rule) public safeguards;
    mapping(uint256 => Violation) public violations;
    mapping(address => bool) public councilMember;

    event SafeguardDeclared(uint256 indexed id, Safeguard safeguardType);
    event SafeguardLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        safeguardCount = 0;
        violationCount = 0;
        councilCount = 0;

        _declareDefaultSafeguards();
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

    function _declareDefaultSafeguards() internal {
        _declare(Safeguard.NoShellCompanyProcurement, "Shell companies cannot receive procurement contracts.");
        _declare(Safeguard.NoPoliticalFamilyFunds, "Political family investment funds cannot profit from contracts.");
        _declare(Safeguard.MandatoryConflictDisclosure, "Conflicts of interest must be disclosed.");
        _declare(Safeguard.MandatoryPublicLedgerEntry, "All contracts must be recorded in the InnovationLedger.");
        _declare(Safeguard.MandatoryCouncilOversight, "Council oversight is mandatory for large contracts.");
        _declare(Safeguard.NoRapidContractAfterInvestment, "No contract may be awarded within 12 months of insider investment.");
        _declare(Safeguard.TransparencyOverAccess, "Transparency overrides insider access.");
        _declare(Safeguard.PublicBenefitOverPrivateGain, "Public benefit overrides private enrichment.");
        _declare(Safeguard.ProcurementIntegrityIsConstitutional, "Procurement integrity is constitutional.");
    }

    function _declare(Safeguard safeguardType, string memory description) internal {
        safeguardCount++;
        safeguards[safeguardCount] = Rule(
            safeguardCount,
            safeguardType,
            description,
            false,
            block.timestamp
        );
        emit SafeguardDeclared(safeguardCount, safeguardType);
    }

    function lockSafeguard(uint256 id) external onlyGuardian {
        Rule storage r = safeguards[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit SafeguardLocked(id);
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
