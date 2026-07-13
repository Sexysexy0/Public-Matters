// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Participation Bonus Mandala
/// @notice Encodes safeguard for fair compensation of Introducer/Influencer roles.
/// @dev Complements InnovationMeritShield, PublicBenefitOracle, and ContributionReport logic.

contract ParticipationBonusMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum BonusRule {
        ParticipationBonusIsConstitutional,
        FairnessMandated,
        UnderpaymentSuppressed,
        TransparencyInParticipationSystems,
        PublicBenefitPriority
    }

    enum BonusStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        BonusConfirmed
    }

    struct Rule {
        uint256 id;
        BonusRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct BonusCase {
        uint256 id;
        address proposer;
        string grounds;
        BonusStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => BonusCase) public bonusCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, BonusRule ruleType);
    event RuleLocked(uint256 indexed id);
    event BonusFiled(uint256 indexed id);
    event BonusStatusChanged(uint256 indexed id, BonusStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        mandalaCount = 0;
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
        _declare(BonusRule.ParticipationBonusIsConstitutional, "Participation bonus is constitutional; denial prohibited.");
        _declare(BonusRule.FairnessMandated, "Fairness mandated; underpayment blocked.");
        _declare(BonusRule.UnderpaymentSuppressed, "Underpayment suppressed; fairness required.");
        _declare(BonusRule.TransparencyInParticipationSystems, "Participation systems must be transparent.");
        _declare(BonusRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(BonusRule ruleType, string memory description) internal {
        mandalaCount++;
        rules[mandalaCount] = Rule(
            mandalaCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(mandalaCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileBonusCase(string calldata grounds) external {
        mandalaCount++;
        bonusCases[mandalaCount] = BonusCase(
            mandalaCount,
            msg.sender,
            grounds,
            BonusStatus.Filed,
            0,
            block.timestamp
        );

        emit BonusFiled(mandalaCount);
    }

    function beginReview(uint256 bonusId) external onlyCouncil {
        BonusCase storage b = bonusCases[bonusId];
        require(b.status == BonusStatus.Filed, "Not filed");
        b.status = BonusStatus.UnderReview;
        emit BonusStatusChanged(bonusId, BonusStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 bonusId) external onlyCouncil {
        BonusCase storage b = bonusCases[bonusId];
        require(b.status == BonusStatus.UnderReview, "Not under review");
        b.status = BonusStatus.MultiCouncilReview;
        emit BonusStatusChanged(bonusId, BonusStatus.MultiCouncilReview);
    }

    function confirmBonus(uint256 bonusId) external onlyCouncil {
        BonusCase storage b = bonusCases[bonusId];
        require(b.status == BonusStatus.MultiCouncilReview, "Not in council stage");

        b.approvals++;

        if (b.approvals * 2 > councilCount && councilCount > 0) {
            b.status = BonusStatus.BonusConfirmed;
            emit BonusStatusChanged(bonusId, BonusStatus.BonusConfirmed);
        }
    }

    function rejectBonus(uint256 bonusId) external onlyCouncil {
        BonusCase storage b = bonusCases[bonusId];
        require(
            b.status == BonusStatus.Filed ||
            b.status == BonusStatus.UnderReview ||
            b.status == BonusStatus.MultiCouncilReview,
            "Invalid status"
        );
        b.status = BonusStatus.Rejected;
        emit BonusStatusChanged(bonusId, BonusStatus.Rejected);
    }
}
