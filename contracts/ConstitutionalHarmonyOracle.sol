// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Harmony Oracle
/// @notice Ensures all constitutional layers operate in harmony as one unified governance system.
/// @dev Complements SystemicCoherenceOracle, IntegrityMandala, TruthMandala, and InnovationConstitution.

contract ConstitutionalHarmonyOracle {
    address public guardian;
    uint256 public harmonyCount;
    uint256 public councilCount;

    enum HarmonyRule {
        HarmonyIsConstitutional,
        LayersMustAlign,
        NoSubsystemFragmentation,
        UnifiedBackboneRequired,
        PublicBenefitPriority
    }

    enum HarmonyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        HarmonyConfirmed
    }

    struct Rule {
        uint256 id;
        HarmonyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct HarmonyCase {
        uint256 id;
        address proposer;
        string layerA;
        string layerB;
        string grounds;
        HarmonyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => HarmonyCase> public harmonyCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, HarmonyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event HarmonyFiled(uint256 indexed id);
    event HarmonyStatusChanged(uint256 indexed id, HarmonyStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        harmonyCount = 0;
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
        _declare(HarmonyRule.HarmonyIsConstitutional, "Harmony is constitutional; denial prohibited.");
        _declare(HarmonyRule.LayersMustAlign, "All constitutional layers must align with each other.");
        _declare(HarmonyRule.NoSubsystemFragmentation, "No subsystem fragmentation; all parts must cooperate.");
        _declare(HarmonyRule.UnifiedBackboneRequired, "Unified backbone required; governance must act as one.");
        _declare(HarmonyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(HarmonyRule ruleType, string memory description) internal {
        harmonyCount++;
        rules[harmonyCount] = Rule(
            harmonyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(harmonyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileHarmonyCase(
        string calldata layerA,
        string calldata layerB,
        string calldata grounds
    ) external {
        harmonyCount++;
        harmonyCases[harmonyCount] = HarmonyCase(
            harmonyCount,
            msg.sender,
            layerA,
            layerB,
            grounds,
            HarmonyStatus.Filed,
            0,
            block.timestamp
        );

        emit HarmonyFiled(harmonyCount);
    }

    function beginReview(uint256 harmonyId) external onlyCouncil {
        HarmonyCase storage h = harmonyCases[harmonyId];
        require(h.status == HarmonyStatus.Filed, "Not filed");
        h.status = HarmonyStatus.UnderReview;
        emit HarmonyStatusChanged(harmonyId, HarmonyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 harmonyId) external onlyCouncil {
        HarmonyCase storage h = harmonyCases[harmonyId];
        require(h.status == HarmonyStatus.UnderReview, "Not under review");
        h.status = HarmonyStatus.MultiCouncilReview;
        emit HarmonyStatusChanged(harmonyId, HarmonyStatus.MultiCouncilReview);
    }

    function confirmHarmony(uint256 harmonyId) external onlyCouncil {
        HarmonyCase storage h = harmonyCases[harmonyId];
        require(h.status == HarmonyStatus.MultiCouncilReview, "Not in council stage");

        h.approvals++;

        if (h.approvals * 2 > councilCount && councilCount > 0) {
            h.status = HarmonyStatus.HarmonyConfirmed;
            emit HarmonyStatusChanged(harmonyId, HarmonyStatus.HarmonyConfirmed);
        }
    }

    function rejectHarmony(uint256 harmonyId) external onlyCouncil {
        HarmonyCase storage h = harmonyCases[harmonyId];
        require(
            h.status == HarmonyStatus.Filed ||
            h.status == HarmonyStatus.UnderReview ||
            h.status == HarmonyStatus.MultiCouncilReview,
            "Invalid status"
        );
        h.status = HarmonyStatus.Rejected;
        emit HarmonyStatusChanged(harmonyId, HarmonyStatus.Rejected);
    }
}
