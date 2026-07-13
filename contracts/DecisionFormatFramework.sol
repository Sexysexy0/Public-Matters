// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Decision Format Framework
/// @notice Encodes decision format safeguard.
/// @dev Complements ProcurementClarity, RegistrarComplianceFramework, and ComplaintWithdrawalTreaty.

contract DecisionFormatFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public councilCount;

    enum FormatRule {
        FormatIsConstitutional,
        StructureRequired,
        ArbitraryRulingsSuppressed,
        PredictabilityMandated,
        TransparencyInDecisionSystems,
        PublicBenefitPriority
    }

    enum FormatStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        FormatConfirmed
    }

    struct Rule {
        uint256 id;
        FormatRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct FormatCase {
        uint256 id;
        address proposer;
        string grounds;
        FormatStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => FormatCase) public formats;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, FormatRule ruleType);
    event RuleLocked(uint256 indexed id);
    event FormatFiled(uint256 indexed id);
    event FormatStatusChanged(uint256 indexed id, FormatStatus status);
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
        _declare(FormatRule.FormatIsConstitutional, "Decision format is constitutional; denial prohibited.");
        _declare(FormatRule.StructureRequired, "Structure required; arbitrary rulings blocked.");
        _declare(FormatRule.ArbitraryRulingsSuppressed, "Arbitrary rulings suppressed; fairness required.");
        _declare(FormatRule.PredictabilityMandated, "Predictability mandated; clarity required.");
        _declare(FormatRule.TransparencyInDecisionSystems, "Decision systems must be transparent.");
        _declare(FormatRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(FormatRule ruleType, string memory description) internal {
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

    function fileFormatCase(string calldata grounds) external {
        frameworkCount++;
        formats[frameworkCount] = FormatCase(
            frameworkCount,
            msg.sender,
            grounds,
            FormatStatus.Filed,
            0,
            block.timestamp
        );

        emit FormatFiled(frameworkCount);
    }

    function beginReview(uint256 formatId) external onlyCouncil {
        FormatCase storage f = formats[formatId];
        require(f.status == FormatStatus.Filed, "Not filed");
        f.status = FormatStatus.UnderReview;
        emit FormatStatusChanged(formatId, FormatStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 formatId) external onlyCouncil {
        FormatCase storage f = formats[formatId];
        require(f.status == FormatStatus.UnderReview, "Not under review");
        f.status = FormatStatus.MultiCouncilReview;
        emit FormatStatusChanged(formatId, FormatStatus.MultiCouncilReview);
    }

    function confirmFormat(uint256 formatId) external onlyCouncil {
        FormatCase storage f = formats[formatId];
        require(f.status == FormatStatus.MultiCouncilReview, "Not in council stage");

        f.approvals++;

        if (f.approvals * 2 > councilCount && councilCount > 0) {
            f.status = FormatStatus.FormatConfirmed;
            emit FormatStatusChanged(formatId, FormatStatus.FormatConfirmed);
        }
    }

    function rejectFormat(uint256 formatId) external onlyCouncil {
        FormatCase storage f = formats[formatId];
        require(
            f.status == FormatStatus.Filed ||
            f.status == FormatStatus.UnderReview ||
            f.status == FormatStatus.MultiCouncilReview,
            "Invalid status"
        );
        f.status = FormatStatus.Rejected;
        emit FormatStatusChanged(formatId, FormatStatus.Rejected);
    }
}
