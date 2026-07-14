// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Unification Oracle
/// @notice Unifies all covenants, mandalas, and oracles into one meta-constitutional backbone.
/// @dev Complements ConstitutionalHarmonyOracle, SystemicCoherenceOracle, IntegrityMandala, and InnovationConstitution.

contract CovenantUnificationOracle {
    address public guardian;
    uint256 public unificationCount;
    uint256 public councilCount;

    enum UnificationRule {
        UnificationIsConstitutional,
        AllCovenantsMerge,
        NoFragmentedConstitutions,
        UnifiedMetaBackboneRequired,
        PublicBenefitPriority
    }

    enum UnificationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        UnificationConfirmed
    }

    struct Rule {
        uint256 id;
        UnificationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct UnificationCase {
        uint256 id;
        address proposer;
        string covenantA;
        string covenantB;
        string grounds;
        UnificationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => UnificationCase> public unificationCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, UnificationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event UnificationFiled(uint256 indexed id);
    event UnificationStatusChanged(uint256 indexed id, UnificationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        unificationCount = 0;
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
        _declare(UnificationRule.UnificationIsConstitutional, "Unification is constitutional; denial prohibited.");
        _declare(UnificationRule.AllCovenantsMerge, "All covenants must merge into one meta-constitution.");
        _declare(UnificationRule.NoFragmentedConstitutions, "No fragmented constitutions; no isolated subsystems.");
        _declare(UnificationRule.UnifiedMetaBackboneRequired, "Unified meta-backbone required for governance.");
        _declare(UnificationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(UnificationRule ruleType, string memory description) internal {
        unificationCount++;
        rules[unificationCount] = Rule(
            unificationCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(unificationCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileUnificationCase(
        string calldata covenantA,
        string calldata covenantB,
        string calldata grounds
    ) external {
        unificationCount++;
        unificationCases[unificationCount] = UnificationCase(
            unificationCount,
            msg.sender,
            covenantA,
            covenantB,
            grounds,
            UnificationStatus.Filed,
            0,
            block.timestamp
        );

        emit UnificationFiled(unificationCount);
    }

    function beginReview(uint256 unificationId) external onlyCouncil {
        UnificationCase storage u = unificationCases[unificationId];
        require(u.status == UnificationStatus.Filed, "Not filed");
        u.status = UnificationStatus.UnderReview;
        emit UnificationStatusChanged(unificationId, UnificationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 unificationId) external onlyCouncil {
        UnificationCase storage u = unificationCases[unificationId];
        require(u.status == UnificationStatus.UnderReview, "Not under review");
        u.status = UnificationStatus.MultiCouncilReview;
        emit UnificationStatusChanged(unificationId, UnificationStatus.MultiCouncilReview);
    }

    function confirmUnification(uint256 unificationId) external onlyCouncil {
        UnificationCase storage u = unificationCases[unificationId];
        require(u.status == UnificationStatus.MultiCouncilReview, "Not in council stage");

        u.approvals++;

        if (u.approvals * 2 > councilCount && councilCount > 0) {
            u.status = UnificationStatus.UnificationConfirmed;
            emit UnificationStatusChanged(unificationId, UnificationStatus.UnificationConfirmed);
        }
    }

    function rejectUnification(uint256 unificationId) external onlyCouncil {
        UnificationCase storage u = unificationCases[unificationId];
        require(
            u.status == UnificationStatus.Filed ||
            u.status == UnificationStatus.UnderReview ||
            u.status == UnificationStatus.MultiCouncilReview,
            "Invalid status"
        );
        u.status = UnificationStatus.Rejected;
        emit UnificationStatusChanged(unificationId, UnificationStatus.Rejected);
    }
}
