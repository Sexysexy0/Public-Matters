// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Resilience Oracle
/// @notice Ensures the constitution can withstand attacks, absorb shocks, and recover from systemic damage.
/// @dev Complements ConstitutionalContinuityOracle, ConstitutionalEvolutionOracle, MetaConstitutionOracle, and SystemicCoherenceOracle.

contract ConstitutionalResilienceOracle {
    address public guardian;
    uint256 public resilienceCount;
    uint256 public councilCount;

    enum ResilienceRule {
        ResilienceIsConstitutional,
        ShockAbsorptionRequired,
        AttackResistanceRequired,
        RecoveryMechanismEnabled,
        PublicBenefitPriority
    }

    enum ResilienceStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ResilienceConfirmed
    }

    struct Rule {
        uint256 id;
        ResilienceRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ResilienceCase {
        uint256 id;
        address proposer;
        string threatVector;
        string grounds;
        ResilienceStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping(uint256 => ResilienceCase> public resilienceCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, ResilienceRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ResilienceFiled(uint256 indexed id);
    event ResilienceStatusChanged(uint256 indexed id, ResilienceStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        resilienceCount = 0;
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
        _declare(ResilienceRule.ResilienceIsConstitutional, "Resilience is constitutional; denial prohibited.");
        _declare(ResilienceRule.ShockAbsorptionRequired, "Constitution must absorb systemic shocks.");
        _declare(ResilienceRule.AttackResistanceRequired, "Constitution must resist internal and external attacks.");
        _declare(ResilienceRule.RecoveryMechanismEnabled, "Constitution must recover from damage automatically.");
        _declare(ResilienceRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ResilienceRule ruleType, string memory description) internal {
        resilienceCount++;
        rules[resilienceCount] = Rule(
            resilienceCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(resilienceCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileResilienceCase(
        string calldata threatVector,
        string calldata grounds
    ) external {
        resilienceCount++;
        resilienceCases[resilienceCount] = ResilienceCase(
            resilienceCount,
            msg.sender,
            threatVector,
            grounds,
            ResilienceStatus.Filed,
            0,
            block.timestamp
        );

        emit ResilienceFiled(resilienceCount);
    }

    function beginReview(uint256 resilienceId) external onlyCouncil {
        ResilienceCase storage c = resilienceCases[resilienceId];
        require(c.status == ResilienceStatus.Filed, "Not filed");
        c.status = ResilienceStatus.UnderReview;
        emit ResilienceStatusChanged(resilienceId, ResilienceStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 resilienceId) external onlyCouncil {
        ResilienceCase storage c = resilienceCases[resilienceId];
        require(c.status == ResilienceStatus.UnderReview, "Not under review");
        c.status = ResilienceStatus.MultiCouncilReview;
        emit ResilienceStatusChanged(resilienceId, ResilienceStatus.MultiCouncilReview);
    }

    function confirmResilience(uint256 resilienceId) external onlyCouncil {
        ResilienceCase storage c = resilienceCases[resilienceId];
        require(c.status == ResilienceStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ResilienceStatus.ResilienceConfirmed;
            emit ResilienceStatusChanged(resilienceId, ResilienceStatus.ResilienceConfirmed);
        }
    }

    function rejectResilience(uint256 resilienceId) external onlyCouncil {
        ResilienceCase storage c = resilienceCases[resilienceId];
        require(
            c.status == ResilienceStatus.Filed ||
            c.status == ResilienceStatus.UnderReview ||
            c.status == ResilienceStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ResilienceStatus.Rejected;
        emit ResilienceStatusChanged(resilienceId, ResilienceStatus.Rejected);
    }
}
