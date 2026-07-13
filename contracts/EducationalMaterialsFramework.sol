// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Educational Materials Framework
/// @notice Encodes educational materials safeguard.
/// @dev Complements ICANNContributionMandala, ComplaintWithdrawalTreaty, and RegistrarNoticeMandala.

contract EducationalMaterialsFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public councilCount;

    enum EducationRule {
        EducationIsConstitutional,
        MaterialsRequired,
        AwarenessAnchored,
        TransparencyInEducationSystems,
        PublicBenefitPriority
    }

    enum EducationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EducationConfirmed
    }

    struct Rule {
        uint256 id;
        EducationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Education {
        uint256 id;
        address proposer;
        string materialReference;
        string grounds;
        EducationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Education) public educations;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EducationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EducationFiled(uint256 indexed id, string materialReference);
    event EducationStatusChanged(uint256 indexed id, EducationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        frameworkCount = 0;
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
        _declare(EducationRule.EducationIsConstitutional, "Education is constitutional; denial prohibited.");
        _declare(EducationRule.MaterialsRequired, "Materials required; ignorance prohibited.");
        _declare(EducationRule.AwarenessAnchored, "Awareness anchored; fairness required.");
        _declare(EducationRule.TransparencyInEducationSystems, "Education systems must be transparent.");
        _declare(EducationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(EducationRule ruleType, string memory description) internal {
        frameworkCount++;
        rules[frameworkCount] = Rule(
            frameworkCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(frameworkCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileEducation(
        string calldata materialReference,
        string calldata grounds
    ) external {
        frameworkCount++;
        educations[frameworkCount] = Education(
            frameworkCount,
            msg.sender,
            materialReference,
            grounds,
            EducationStatus.Filed,
            0,
            block.timestamp
        );

        emit EducationFiled(frameworkCount, materialReference);
    }

    function beginReview(uint256 educationId) external onlyCouncil {
        Education storage e = educations[educationId];
        require(e.status == EducationStatus.Filed, "Not filed");
        e.status = EducationStatus.UnderReview;
        emit EducationStatusChanged(educationId, EducationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 educationId) external onlyCouncil {
        Education storage e = educations[educationId];
        require(e.status == EducationStatus.UnderReview, "Not under review");
        e.status = EducationStatus.MultiCouncilReview;
        emit EducationStatusChanged(educationId, EducationStatus.MultiCouncilReview);
    }

    function confirmEducation(uint256 educationId) external onlyCouncil {
        Education storage e = educations[educationId];
        require(e.status == EducationStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EducationStatus.EducationConfirmed;
            emit EducationStatusChanged(educationId, EducationStatus.EducationConfirmed);
        }
    }

    function rejectEducation(uint256 educationId) external onlyCouncil {
        Education storage e = educations[educationId];
        require(
            e.status == EducationStatus.Filed ||
            e.status == EducationStatus.UnderReview ||
            e.status == EducationStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EducationStatus.Rejected;
        emit EducationStatusChanged(educationId, EducationStatus.Rejected);
    }
}
