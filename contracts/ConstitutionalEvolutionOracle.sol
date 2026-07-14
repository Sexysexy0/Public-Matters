// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Evolution Oracle
/// @notice Governs safe, coherent, and public-benefit-driven evolution of the meta-constitution.
/// @dev Complements MetaConstitutionOracle, CovenantUnificationOracle, ConstitutionalHarmonyOracle, and SystemicCoherenceOracle.

contract ConstitutionalEvolutionOracle {
    address public guardian;
    uint256 public evolutionCount;
    uint256 public councilCount;

    enum EvolutionRule {
        EvolutionIsConstitutional,
        NoCorruptionInEvolution,
        CoherentEvolutionRequired,
        PublicBenefitAnchored,
        MetaConstitutionAlignment
    }

    enum EvolutionStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EvolutionApproved
    }

    struct Rule {
        uint256 id;
        EvolutionRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct EvolutionCase {
        uint256 id;
        address proposer;
        string proposedChange;
        string grounds;
        EvolutionStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => EvolutionCase> public evolutionCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, EvolutionRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EvolutionFiled(uint256 indexed id);
    event EvolutionStatusChanged(uint256 indexed id, EvolutionStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        evolutionCount = 0;
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
        _declare(EvolutionRule.EvolutionIsConstitutional, "Evolution is constitutional; denial prohibited.");
        _declare(EvolutionRule.NoCorruptionInEvolution, "Evolution cannot introduce corruption or systemic decay.");
        _declare(EvolutionRule.CoherentEvolutionRequired, "Evolution must remain coherent with all constitutional layers.");
        _declare(EvolutionRule.PublicBenefitAnchored, "Evolution must serve the public benefit, not elite gain.");
        _declare(EvolutionRule.MetaConstitutionAlignment, "Evolution must align with the meta-constitution.");
    }

    function _declare(EvolutionRule ruleType, string memory description) internal {
        evolutionCount++;
        rules[evolutionCount] = Rule(
            evolutionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(evolutionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileEvolutionCase(
        string calldata proposedChange,
        string calldata grounds
    ) external {
        evolutionCount++;
        evolutionCases[evolutionCount] = EvolutionCase(
            evolutionCount,
            msg.sender,
            proposedChange,
            grounds,
            EvolutionStatus.Filed,
            0,
            block.timestamp
        );

        emit EvolutionFiled(evolutionCount);
    }

    function beginReview(uint256 evolutionId) external onlyCouncil {
        EvolutionCase storage e = evolutionCases[evolutionId];
        require(e.status == EvolutionStatus.Filed, "Not filed");
        e.status = EvolutionStatus.UnderReview;
        emit EvolutionStatusChanged(evolutionId, EvolutionStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 evolutionId) external onlyCouncil {
        EvolutionCase storage e = evolutionCases[evolutionId];
        require(e.status == EvolutionStatus.UnderReview, "Not under review");
        e.status = EvolutionStatus.MultiCouncilReview;
        emit EvolutionStatusChanged(evolutionId, EvolutionStatus.MultiCouncilReview);
    }

    function approveEvolution(uint256 evolutionId) external onlyCouncil {
        EvolutionCase storage e = evolutionCases[evolutionId];
        require(e.status == EvolutionStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EvolutionStatus.EvolutionApproved;
            emit EvolutionStatusChanged(evolutionId, EvolutionStatus.EvolutionApproved);
        }
    }

    function rejectEvolution(uint256 evolutionId) external onlyCouncil {
        EvolutionCase storage e = evolutionCases[evolutionId];
        require(
            e.status == EvolutionStatus.Filed ||
            e.status == EvolutionStatus.UnderReview ||
            e.status == EvolutionStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EvolutionStatus.Rejected;
        emit EvolutionStatusChanged(evolutionId, EvolutionStatus.Rejected);
    }
}
