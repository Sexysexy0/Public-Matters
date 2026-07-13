// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Kindness Framework
/// @notice Encodes kindness safeguard.
/// @dev Complements EmpathyMandala, CareTreaty, and CompassionFramework.

contract KindnessFramework {
    address public guardian;
    uint256 public kindnessCount;
    uint256 public councilCount;

    enum KindnessRule {
        KindnessIsConstitutional,
        CompassionMandated,
        CrueltySuppressed,
        TransparencyInKindnessSystems,
        PublicBenefitPriority
    }

    enum KindnessStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        KindnessConfirmed
    }

    struct Rule {
        uint256 id;
        KindnessRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct KindnessCase {
        uint256 id;
        address proposer;
        string grounds;
        KindnessStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => KindnessCase) public kindnessCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, KindnessRule ruleType);
    event RuleLocked(uint256 indexed id);
    event KindnessFiled(uint256 indexed id);
    event KindnessStatusChanged(uint256 indexed id, KindnessStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        kindnessCount = 0;
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
        _declare(KindnessRule.KindnessIsConstitutional, "Kindness is constitutional; denial prohibited.");
        _declare(KindnessRule.CompassionMandated, "Compassion mandated; cruelty blocked.");
        _declare(KindnessRule.CrueltySuppressed, "Cruelty suppressed; fairness required.");
        _declare(KindnessRule.TransparencyInKindnessSystems, "Kindness systems must be transparent.");
        _declare(KindnessRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(KindnessRule ruleType, string memory description) internal {
        kindnessCount++;
        rules[kindnessCount] = Rule(
            kindnessCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(kindnessCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileKindnessCase(string calldata grounds) external {
        kindnessCount++;
        kindnessCases[kindnessCount] = KindnessCase(
            kindnessCount,
            msg.sender,
            grounds,
            KindnessStatus.Filed,
            0,
            block.timestamp
        );

        emit KindnessFiled(kindnessCount);
    }

    function beginReview(uint256 kindnessId) external onlyCouncil {
        KindnessCase storage k = kindnessCases[kindnessId];
        require(k.status == KindnessStatus.Filed, "Not filed");
        k.status = KindnessStatus.UnderReview;
        emit KindnessStatusChanged(kindnessId, KindnessStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 kindnessId) external onlyCouncil {
        KindnessCase storage k = kindnessCases[kindnessId];
        require(k.status == KindnessStatus.UnderReview, "Not under review");
        k.status = KindnessStatus.MultiCouncilReview;
        emit KindnessStatusChanged(kindnessId, KindnessStatus.MultiCouncilReview);
    }

    function confirmKindness(uint256 kindnessId) external onlyCouncil {
        KindnessCase storage k = kindnessCases[kindnessId];
        require(k.status == KindnessStatus.MultiCouncilReview, "Not in council stage");

        k.approvals++;

        if (k.approvals * 2 > councilCount && councilCount > 0) {
            k.status = KindnessStatus.KindnessConfirmed;
            emit KindnessStatusChanged(kindnessId, KindnessStatus.KindnessConfirmed);
        }
    }

    function rejectKindness(uint256 kindnessId) external onlyCouncil {
        KindnessCase storage k = kindnessCases[kindnessId];
        require(
            k.status == KindnessStatus.Filed ||
            k.status == KindnessStatus.UnderReview ||
            k.status == KindnessStatus.MultiCouncilReview,
            "Invalid status"
        );
        k.status = KindnessStatus.Rejected;
        emit KindnessStatusChanged(kindnessId, KindnessStatus.Rejected);
    }
}
