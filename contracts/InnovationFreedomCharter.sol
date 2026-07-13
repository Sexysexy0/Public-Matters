// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Freedom Charter
/// @notice Declares innovation, creation, and technological advancement as protected constitutional rights.
/// @dev Works with InnovationSafetyCovenant, ProcurementClarity, AntiWeaponization, RiskContextReview, PublicBenefitOracle, and InnovationMeritShield.

contract InnovationFreedomCharter {
    address public guardian;
    uint256 public freedomCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum RoleType {
        Innovator,
        Creator,
        Engineer,
        Founder,
        PublicServant,
        Council,
        Oversight,
        FutureEntity
    }

    enum FreedomRight {
        RightToInnovate,
        RightToCreate,
        RightToExperiment,
        RightToTakeRisk,
        RightToModernizeSystems,
        RightToAdvanceTechnology,
        RightToPublicBenefitCreation,
        RightToMeritRecognition,
        RightToProtectionFromFear,
        RightToProtectionFromSuppression,
        RightToProtectionFromRetaliation,
        RightToProtectionFromWeaponizedGovernance,
        RightToTransparentReview,
        RightToFairEvaluation,
        RightToGoodFaithPresumption,
        RightToInnovationFreedom
    }

    enum ViolationType {
        InnovationSuppression,
        Retaliation,
        FearInducement,
        WeaponizedGovernance,
        MeritErasure,
        PublicBenefitErasure,
        RiskPunishment,
        ExperimentPunishment,
        CreationPunishment,
        TechnologyBlock,
        SystemModernizationBlock,
        GoodFaithIgnored,
        FairEvaluationDenied
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Freedom {
        uint256 id;
        FreedomRight rightType;
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

    mapping(uint256 => Freedom) public freedoms;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event FreedomDeclared(uint256 indexed id, FreedomRight rightType);
    event FreedomLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, ViolationType violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        freedomCount = 0;
        violationCount = 0;
        councilCount = 0;

        _declareDefaultFreedoms();
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

    function _declareDefaultFreedoms() internal {
        _declareFreedom(FreedomRight.RightToInnovate, "Everyone has the right to innovate.");
        _declareFreedom(FreedomRight.RightToCreate, "Creation is a protected right.");
        _declareFreedom(FreedomRight.RightToExperiment, "Experimentation cannot be punished.");
        _declareFreedom(FreedomRight.RightToTakeRisk, "Risk-taking is a protected right.");
        _declareFreedom(FreedomRight.RightToModernizeSystems, "Modernizing systems is protected.");
        _declareFreedom(FreedomRight.RightToAdvanceTechnology, "Advancing technology is protected.");
        _declareFreedom(FreedomRight.RightToPublicBenefitCreation, "Creating public benefit is protected.");
        _declareFreedom(FreedomRight.RightToMeritRecognition, "Merit must be recognized and protected.");
        _declareFreedom(FreedomRight.RightToProtectionFromFear, "No innovator may be governed by fear.");
        _declareFreedom(FreedomRight.RightToProtectionFromSuppression, "Innovation cannot be suppressed.");
        _declareFreedom(FreedomRight.RightToProtectionFromRetaliation, "No retaliation for innovation.");
        _declareFreedom(FreedomRight.RightToProtectionFromWeaponizedGovernance, "Governance cannot be weaponized.");
        _declareFreedom(FreedomRight.RightToTransparentReview, "All innovation cases require transparent review.");
        _declareFreedom(FreedomRight.RightToFairEvaluation, "Innovators must receive fair evaluation.");
        _declareFreedom(FreedomRight.RightToGoodFaithPresumption, "Good faith is the default presumption.");
        _declareFreedom(FreedomRight.RightToInnovationFreedom, "Innovation freedom is constitutional.");
    }

    function _declareFreedom(FreedomRight rightType, string memory description) internal {
        freedomCount++;
        freedoms[freedomCount] = Freedom(
            freedomCount,
            rightType,
            description,
            false,
            block.timestamp
        );
        emit FreedomDeclared(freedomCount, rightType);
    }

    function lockFreedom(uint256 id) external onlyGuardian {
        Freedom storage f = freedoms[id];
        require(!f.immutableEntry, "Already immutable");
        f.immutableEntry = true;
        emit FreedomLocked(id);
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
