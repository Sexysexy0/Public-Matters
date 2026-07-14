// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Meta Constitution Oracle
/// @notice Defines the unified meta-constitution produced by all covenants, mandalas, and oracles.
/// @dev Complements CovenantUnificationOracle, ConstitutionalHarmonyOracle, SystemicCoherenceOracle, and InnovationConstitution.

contract MetaConstitutionOracle {
    address public guardian;
    uint256 public constitutionCount;
    uint256 public councilCount;

    enum MetaRule {
        MetaConstitutionIsSupreme,
        AllCovenantsBindHere,
        NoLayerMayContradict,
        SelfCorrectionEnabled,
        PublicBenefitPriority
    }

    enum MetaStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        MetaConstitutionConfirmed
    }

    struct Rule {
        uint256 id;
        MetaRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct MetaCase {
        uint256 id;
        address proposer;
        string covenantSource;
        string grounds;
        MetaStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping<uint256 => MetaCase> public metaCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, MetaRule ruleType);
    event RuleLocked(uint256 indexed id);
    event MetaFiled(uint256 indexed id);
    event MetaStatusChanged(uint256 indexed id, MetaStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        constitutionCount = 0;
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
        _declare(MetaRule.MetaConstitutionIsSupreme, "Meta-constitution is supreme; denial prohibited.");
        _declare(MetaRule.AllCovenantsBindHere, "All covenants bind to the meta-constitution.");
        _declare(MetaRule.NoLayerMayContradict, "No layer may contradict the meta-constitution.");
        _declare(MetaRule.SelfCorrectionEnabled, "Self-correction enabled; meta-constitution evolves safely.");
        _declare(MetaRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(MetaRule ruleType, string memory description) internal {
        constitutionCount++;
        rules[constitutionCount] = Rule(
            constitutionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(constitutionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileMetaCase(
        string calldata covenantSource,
        string calldata grounds
    ) external {
        constitutionCount++;
        metaCases[constitutionCount] = MetaCase(
            constitutionCount,
            msg.sender,
            covenantSource,
            grounds,
            MetaStatus.Filed,
            0,
            block.timestamp
        );

        emit MetaFiled(constitutionCount);
    }

    function beginReview(uint256 metaId) external onlyCouncil {
        MetaCase storage m = metaCases[metaId];
        require(m.status == MetaStatus.Filed, "Not filed");
        m.status = MetaStatus.UnderReview;
        emit MetaStatusChanged(metaId, MetaStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 metaId) external onlyCouncil {
        MetaCase storage m = metaCases[metaId];
        require(m.status == MetaStatus.UnderReview, "Not under review");
        m.status = MetaStatus.MultiCouncilReview;
        emit MetaStatusChanged(metaId, MetaStatus.MultiCouncilReview);
    }

    function confirmMeta(uint256 metaId) external onlyCouncil {
        MetaCase storage m = metaCases[metaId];
        require(m.status == MetaStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = MetaStatus.MetaConstitutionConfirmed;
            emit MetaStatusChanged(metaId, MetaStatus.MetaConstitutionConfirmed);
        }
    }

    function rejectMeta(uint256 metaId) external onlyCouncil {
        MetaCase storage m = metaCases[metaId];
        require(
            m.status == MetaStatus.Filed ||
            m.status == MetaStatus.UnderReview ||
            m.status == MetaStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = MetaStatus.Rejected;
        emit MetaStatusChanged(metaId, MetaStatus.Rejected);
    }
}
