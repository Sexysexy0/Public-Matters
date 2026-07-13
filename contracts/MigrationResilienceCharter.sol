// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Migration Resilience Charter
/// @notice Encodes safeguard for soil loss ↔ migration crisis.
/// @dev Complements SoilConstitution, BioHealthMandala, and PublicBenefitOracle.

contract MigrationResilienceCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public councilCount;

    enum MigrationRule {
        FoodSecurityIsConstitutional,
        ResilienceMandated,
        DisplacementSuppressed,
        TransparencyInMigrationSystems,
        PublicBenefitPriority
    }

    enum MigrationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        MigrationConfirmed
    }

    struct Rule {
        uint256 id;
        MigrationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct MigrationCase {
        uint256 id;
        address proposer;
        string grounds;
        MigrationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => MigrationCase) public migrationCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, MigrationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event MigrationFiled(uint256 indexed id);
    event MigrationStatusChanged(uint256 indexed id, MigrationStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
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
        _declare(MigrationRule.FoodSecurityIsConstitutional, "Food security is constitutional; denial prohibited.");
        _declare(MigrationRule.ResilienceMandated, "Resilience mandated; displacement blocked.");
        _declare(MigrationRule.DisplacementSuppressed, "Displacement suppressed; fairness required.");
        _declare(MigrationRule.TransparencyInMigrationSystems, "Migration systems must be transparent.");
        _declare(MigrationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(MigrationRule ruleType, string memory description) internal {
        charterCount++;
        rules[charterCount] = Rule(
            charterCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(charterCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileMigrationCase(string calldata grounds) external {
        charterCount++;
        migrationCases[charterCount] = MigrationCase(
            charterCount,
            msg.sender,
            grounds,
            MigrationStatus.Filed,
            0,
            block.timestamp
        );

        emit MigrationFiled(charterCount);
    }

    function beginReview(uint256 migrationId) external onlyCouncil {
        MigrationCase storage m = migrationCases[migrationId];
        require(m.status == MigrationStatus.Filed, "Not filed");
        m.status = MigrationStatus.UnderReview;
        emit MigrationStatusChanged(migrationId, MigrationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 migrationId) external onlyCouncil {
        MigrationCase storage m = migrationCases[migrationId];
        require(m.status == MigrationStatus.UnderReview, "Not under review");
        m.status = MigrationStatus.MultiCouncilReview;
        emit MigrationStatusChanged(migrationId, MigrationStatus.MultiCouncilReview);
    }

    function confirmMigration(uint256 migrationId) external onlyCouncil {
        MigrationCase storage m = migrationCases[migrationId];
        require(m.status == MigrationStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = MigrationStatus.MigrationConfirmed;
            emit MigrationStatusChanged(migrationId, MigrationStatus.MigrationConfirmed);
        }
    }

    function rejectMigration(uint256 migrationId) external onlyCouncil {
        MigrationCase storage m = migrationCases[migrationId];
        require(
            m.status == MigrationStatus.Filed ||
            m.status == MigrationStatus.UnderReview ||
            m.status == MigrationStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = MigrationStatus.Rejected;
        emit MigrationStatusChanged(migrationId, MigrationStatus.Rejected);
    }
}
