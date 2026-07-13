// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Transparency Culture Covenant
/// @notice Establishes radical transparency as a constitutional governance principle.
/// @dev Works with InternalFeedbackLoop and ReputationRiskProtocol to ensure openness, accountability, and fearless culture.

contract TransparencyCulture {
    address public guardian;
    uint256 public principleCount;
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

    enum TransparencyPrinciple {
        NoDataSuppression,
        NoHiddenMistakes,
        NoRetaliationAgainstWhistleblowers,
        MandatoryPublicDisclosure,
        MandatoryRootCausePublication,
        MandatoryCouncilOversight,
        CriticismIsProtected,
        TransparencyOverNarrativeControl,
        AccountabilityOverImage,
        RadicalTransparencyIsConstitutional
    }

    enum TransparencyViolation {
        DataSuppression,
        HiddenMistake,
        WhistleblowerRetaliation,
        DisclosureFailure,
        RootCauseHidden,
        OversightBypassed,
        CriticismSilenced,
        NarrativeManipulation,
        ImageOverAccountability
    }

    enum CaseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ConfirmedViolation
    }

    struct Principle {
        uint256 id;
        TransparencyPrinciple principleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Violation {
        uint256 id;
        address accuser;
        address accused;
        TransparencyViolation violationType;
        string details;
        CaseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Principle) public principles;
    mapping(uint256 => Violation) public violations;
    mapping(address => RoleType) public roles;
    mapping(address => bool) public councilMember;

    event PrincipleDeclared(uint256 indexed id, TransparencyPrinciple principleType);
    event PrincipleLocked(uint256 indexed id);
    event ViolationFiled(uint256 indexed id, TransparencyViolation violationType);
    event CaseStatusChanged(uint256 indexed id, CaseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        principleCount = 0;
        caseCount = 0;
        councilCount = 0;

        _declareDefaultPrinciples();
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

    function _declareDefaultPrinciples() internal {
        _declare(TransparencyPrinciple.NoDataSuppression, "Data cannot be suppressed.");
        _declare(TransparencyPrinciple.NoHiddenMistakes, "Mistakes cannot be hidden.");
        _declare(TransparencyPrinciple.NoRetaliationAgainstWhistleblowers, "Whistleblowers cannot be retaliated against.");
        _declare(TransparencyPrinciple.MandatoryPublicDisclosure, "Public disclosure is mandatory for systemic issues.");
        _declare(TransparencyPrinciple.MandatoryRootCausePublication, "Root cause analysis must be published.");
        _declare(TransparencyPrinciple.MandatoryCouncilOversight, "Council oversight is mandatory.");
        _declare(TransparencyPrinciple.CriticismIsProtected, "Criticism is protected speech.");
        _declare(TransparencyPrinciple.TransparencyOverNarrativeControl, "Transparency overrides narrative control.");
        _declare(TransparencyPrinciple.AccountabilityOverImage, "Accountability overrides brand image management.");
        _declare(TransparencyPrinciple.RadicalTransparencyIsConstitutional, "Radical transparency is constitutional.");
    }

    function _declare(TransparencyPrinciple principleType, string memory description) internal {
        principleCount++;
        principles[principleCount] = Principle(
            principleCount,
            principleType,
            description,
            false,
            block.timestamp
        );
        emit PrincipleDeclared(principleCount, principleType);
    }

    function lockPrinciple(uint256 id) external onlyGuardian {
        Principle storage p = principles[id];
        require(!p.immutableEntry, "Already immutable");
        p.immutableEntry = true;
        emit PrincipleLocked(id);
    }

    function fileViolation(
        address accused,
        TransparencyViolation violationType,
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
