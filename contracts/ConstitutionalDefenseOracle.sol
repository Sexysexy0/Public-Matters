// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Defense Oracle
/// @notice Enables active defense mechanisms to protect the constitution from attacks, corruption vectors, and hostile takeover attempts.
/// @dev Complements ConstitutionalResilienceOracle, ConstitutionalContinuityOracle, MetaConstitutionOracle, and SystemicCoherenceOracle.

contract ConstitutionalDefenseOracle {
    address public guardian;
    uint256 public defenseCount;
    uint256 public councilCount;

    enum DefenseRule {
        DefenseIsConstitutional,
        ThreatDetectionRequired,
        AttackNeutralizationRequired,
        CorruptionVectorBlocking,
        PublicBenefitPriority
    }

    enum DefenseStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        DefenseConfirmed
    }

    struct Rule {
        uint256 id;
        DefenseRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct DefenseCase {
        uint256 id;
        address proposer;
        string threatVector;
        string threatSeverity;
        string grounds;
        DefenseStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => DefenseCase> public defenseCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, DefenseRule ruleType);
    event RuleLocked(uint256 indexed id);
    event DefenseFiled(uint256 indexed id);
    event DefenseStatusChanged(uint256 indexed id, DefenseStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        defenseCount = 0;
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
        _declare(DefenseRule.DefenseIsConstitutional, "Defense is constitutional; denial prohibited.");
        _declare(DefenseRule.ThreatDetectionRequired, "Constitution must detect threats proactively.");
        _declare(DefenseRule.AttackNeutralizationRequired, "Constitution must neutralize attacks automatically.");
        _declare(DefenseRule.CorruptionVectorBlocking, "Corruption vectors must be blocked at all layers.");
        _declare(DefenseRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(DefenseRule ruleType, string memory description) internal {
        defenseCount++;
        rules[defenseCount] = Rule(
            defenseCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(defenseCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileDefenseCase(
        string calldata threatVector,
        string calldata threatSeverity,
        string calldata grounds
    ) external {
        defenseCount++;
        defenseCases[defenseCount] = DefenseCase(
            defenseCount,
            msg.sender,
            threatVector,
            threatSeverity,
            grounds,
            DefenseStatus.Filed,
            0,
            block.timestamp
        );

        emit DefenseFiled(defenseCount);
    }

    function beginReview(uint256 defenseId) external onlyCouncil {
        DefenseCase storage d = defenseCases[defenseId];
        require(d.status == DefenseStatus.Filed, "Not filed");
        d.status = DefenseStatus.UnderReview;
        emit DefenseStatusChanged(defenseId, DefenseStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 defenseId) external onlyCouncil {
        DefenseCase storage d = defenseCases[defenseId];
        require(d.status == DefenseStatus.UnderReview, "Not under review");
        d.status = DefenseStatus.MultiCouncilReview;
        emit DefenseStatusChanged(defenseId, DefenseStatus.MultiCouncilReview);
    }

    function confirmDefense(uint256 defenseId) external onlyCouncil {
        DefenseCase storage d = defenseCases[defenseId];
        require(d.status == DefenseStatus.MultiCouncilReview, "Not in council stage");

        d.approvals++;

        if (d.approvals * 2 > councilCount && councilCount > 0) {
            d.status = DefenseStatus.DefenseConfirmed;
            emit DefenseStatusChanged(defenseId, DefenseStatus.DefenseConfirmed);
        }
    }

    function rejectDefense(uint256 defenseId) external onlyCouncil {
        DefenseCase storage d = defenseCases[defenseId];
        require(
            d.status == DefenseStatus.Filed ||
            d.status == DefenseStatus.UnderReview ||
            d.status == DefenseStatus.MultiCouncilReview,
            "Invalid status"
        );
        d.status = DefenseStatus.Rejected;
        emit DefenseStatusChanged(defenseId, DefenseStatus.Rejected);
    }
}
