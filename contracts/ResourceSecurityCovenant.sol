// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Resource Security Covenant
/// @notice Firewall for critical resources (e.g., copper, rare earths, energy) to prevent weaponized hoarding, insider profiteering, and geopolitical manipulation.
/// @dev Integrates with InnovationSupremeCourt, PublicMattersIntegration, and GovernanceTransparencyShield.

contract ResourceSecurityCovenant {
    address public guardian;
    uint256 public safeguardCount;
    uint256 public violationCount;
    uint256 public councilCount;

    enum ResourceType {
        Copper,
        RareEarths,
        Energy,
        StrategicMetals,
        DataInfrastructure,
        Other
    }

    enum Safeguard {
        NoWeaponizedHoarding,
        NoInsiderProfiteering,
        MandatoryPublicLedgerEntry,
        MandatoryCouncilOversight,
        PublicBenefitPriority,
        TransparencyOverSpeculation,
        ResourceIntegrityIsConstitutional
    }

    enum ViolationType {
        Hoarding,
        InsiderProfiteering,
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
        Safeguard safeguardType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        ResourceType resourceType;
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
    event ViolationFiled(uint256 indexed id, ViolationType violationType, ResourceType resourceType);
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
        _declare(Safeguard.NoWeaponizedHoarding, "Critical resources cannot be hoarded for geopolitical leverage.");
        _declare(Safeguard.NoInsiderProfiteering, "Insiders cannot profit from resource contracts.");
        _declare(Safeguard.MandatoryPublicLedgerEntry, "All resource contracts must be logged in the InnovationLedger.");
        _declare(Safeguard.MandatoryCouncilOversight, "Council oversight required for strategic resource deals.");
        _declare(Safeguard.PublicBenefitPriority, "Public benefit overrides private speculation.");
        _declare(Safeguard.TransparencyOverSpeculation, "Transparency overrides speculative manipulation.");
        _declare(Safeguard.ResourceIntegrityIsConstitutional, "Resource integrity is constitutional.");
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
        ResourceType resourceType,
        ViolationType violationType,
        string calldata details
    ) external {
        violationCount++;
        violations[violationCount] = Violation(
            violationCount,
            msg.sender,
            accused,
            resourceType,
            violationType,
            details,
            CaseStatus.Filed,
            0,
            block.timestamp
        );

        emit ViolationFiled(violationCount, violationType, resourceType);
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
