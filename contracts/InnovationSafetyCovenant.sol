// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Safety Covenant
/// @notice Encodes safeguard balancing innovation and systemic safety.
/// @dev Complements DataOracle, AITransparencyMandala, and BureaucraticAccountability.

contract InnovationSafetyCovenant {
    address public guardian;
    uint256 public covenantCount;
    uint256 public councilCount;

    enum SafetyRule {
        InnovationIsConstitutional,
        SafetyMandated,
        RiskSuppressed,
        TransparencyInInnovationSystems,
        PublicBenefitPriority
    }

    enum SafetyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SafetyConfirmed
    }

    struct Rule {
        uint256 id;
        SafetyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SafetyCase {
        uint256 id;
        address proposer;
        string grounds;
        SafetyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SafetyCase) public safetyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SafetyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SafetyFiled(uint256 indexed id);
    event SafetyStatusChanged(uint256 indexed id, SafetyStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        covenantCount = 0;
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
        _declare(SafetyRule.InnovationIsConstitutional, "Innovation is constitutional; denial prohibited.");
        _declare(SafetyRule.SafetyMandated, "Safety mandated; risk blocked.");
        _declare(SafetyRule.RiskSuppressed, "Risk suppressed; fairness required.");
        _declare(SafetyRule.TransparencyInInnovationSystems, "Innovation systems must be transparent.");
        _declare(SafetyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SafetyRule ruleType, string memory description) internal {
        covenantCount++;
        rules[covenantCount] = Rule(
            covenantCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(covenantCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileSafetyCase(string calldata grounds) external {
        covenantCount++;
        safetyCases[covenantCount] = SafetyCase(
            covenantCount,
            msg.sender,
            grounds,
            SafetyStatus.Filed,
            0,
            block.timestamp
        );

        emit SafetyFiled(covenantCount);
    }

    function beginReview(uint256 safetyId) external onlyCouncil {
        SafetyCase storage s = safetyCases[safetyId];
        require(s.status == SafetyStatus.Filed, "Not filed");
        s.status = SafetyStatus.UnderReview;
        emit SafetyStatusChanged(safetyId, SafetyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 safetyId) external onlyCouncil {
        SafetyCase storage s = safetyCases[safetyId];
        require(s.status == SafetyStatus.UnderReview, "Not under review");
        s.status = SafetyStatus.MultiCouncilReview;
        emit SafetyStatusChanged(safetyId, SafetyStatus.MultiCouncilReview);
    }

    function confirmSafety(uint256 safetyId) external onlyCouncil {
        SafetyCase storage s = safetyCases[safetyId];
        require(s.status == SafetyStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SafetyStatus.SafetyConfirmed;
            emit SafetyStatusChanged(safetyId, SafetyStatus.SafetyConfirmed);
        }
    }

    function rejectSafety(uint256 safetyId) external onlyCouncil {
        SafetyCase storage s = safetyCases[safetyId];
        require(
            s.status == SafetyStatus.Filed ||
            s.status == SafetyStatus.UnderReview ||
            s.status == SafetyStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SafetyStatus.Rejected;
        emit SafetyStatusChanged(safetyId, SafetyStatus.Rejected);
    }
}
