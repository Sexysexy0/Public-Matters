// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Systemic Coherence Oracle
/// @notice Ensures all Mandalas, Oracles, and Covenants remain internally consistent and non-contradictory.
/// @dev Complements IntegrityMandala, TruthMandala, EvidenceChainOracle, and InnovationConstitution.

contract SystemicCoherenceOracle {
    address public guardian;
    uint256 public coherenceCount;
    uint256 public councilCount;

    enum CoherenceRule {
        CoherenceIsConstitutional,
        NoContradictionAllowed,
        MandalaAlignmentRequired,
        ParadoxDetectionEnabled,
        PublicBenefitPriority
    }

    enum CoherenceStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CoherenceConfirmed
    }

    struct Rule {
        uint256 id;
        CoherenceRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CoherenceCase {
        uint256 id;
        address proposer;
        string conflictingMandalaA;
        string conflictingMandalaB;
        string grounds;
        CoherenceStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => CoherenceCase> public coherenceCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, CoherenceRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CoherenceFiled(uint256 indexed id);
    event CoherenceStatusChanged(uint256 indexed id, CoherenceStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        coherenceCount = 0;
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
        _declare(CoherenceRule.CoherenceIsConstitutional, "Systemic coherence is constitutional; denial prohibited.");
        _declare(CoherenceRule.NoContradictionAllowed, "No contradictions allowed across Mandalas and Oracles.");
        _declare(CoherenceRule.MandalaAlignmentRequired, "All Mandalas must remain aligned with constitutional backbone.");
        _declare(CoherenceRule.ParadoxDetectionEnabled, "Paradox detection enabled; contradictions flagged.");
        _declare(CoherenceRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(CoherenceRule ruleType, string memory description) internal {
        coherenceCount++;
        rules[coherenceCount] = Rule(
            coherenceCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(coherenceCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileCoherenceCase(
        string calldata conflictingMandalaA,
        string calldata conflictingMandalaB,
        string calldata grounds
    ) external {
        coherenceCount++;
        coherenceCases[coherenceCount] = CoherenceCase(
            coherenceCount,
            msg.sender,
            conflictingMandalaA,
            conflictingMandalaB,
            grounds,
            CoherenceStatus.Filed,
            0,
            block.timestamp
        );

        emit CoherenceFiled(coherenceCount);
    }

    function beginReview(uint256 coherenceId) external onlyCouncil {
        CoherenceCase storage c = coherenceCases[coherenceId];
        require(c.status == CoherenceStatus.Filed, "Not filed");
        c.status = CoherenceStatus.UnderReview;
        emit CoherenceStatusChanged(coherenceId, CoherenceStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 coherenceId) external onlyCouncil {
        CoherenceCase storage c = coherenceCases[coherenceId];
        require(c.status == CoherenceStatus.UnderReview, "Not under review");
        c.status = CoherenceStatus.MultiCouncilReview;
        emit CoherenceStatusChanged(coherenceId, CoherenceStatus.MultiCouncilReview);
    }

    function confirmCoherence(uint256 coherenceId) external onlyCouncil {
        CoherenceCase storage c = coherenceCases[coherenceId];
        require(c.status == CoherenceStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CoherenceStatus.CoherenceConfirmed;
            emit CoherenceStatusChanged(coherenceId, CoherenceStatus.CoherenceConfirmed);
        }
    }

    function rejectCoherence(uint256 coherenceId) external onlyCouncil {
        CoherenceCase storage c = coherenceCases[coherenceId];
        require(
            c.status == CoherenceStatus.Filed ||
            c.status == CoherenceStatus.UnderReview ||
            c.status == CoherenceStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CoherenceStatus.Rejected;
        emit CoherenceStatusChanged(coherenceId, CoherenceStatus.Rejected);
    }
}
