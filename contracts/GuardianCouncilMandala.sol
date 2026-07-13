// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Guardian Council Mandala
/// @notice Encodes safeguard for council governance anchoring all oracles and mandalas.
/// @dev Complements PublicBenefitOracle, CollectiveMetamorphosisOracle, and BureaucraticAccountability.

contract GuardianCouncilMandala {
    address public guardian;
    uint256 public councilCount;
    uint256 public charterCount;

    enum CouncilRule {
        CouncilGovernanceIsConstitutional,
        MultiCouncilReviewMandated,
        SuppressionOfUnilateralism,
        TransparencyInCouncilSystems,
        PublicBenefitPriority
    }

    enum CouncilStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CouncilConfirmed
    }

    struct Rule {
        uint256 id;
        CouncilRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CouncilCase {
        uint256 id;
        address proposer;
        string grounds;
        CouncilStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => CouncilCase) public councilCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, CouncilRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CouncilFiled(uint256 indexed id);
    event CouncilStatusChanged(uint256 indexed id, CouncilStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        councilCount = 0;
        charterCount = 0;

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
        _declare(CouncilRule.CouncilGovernanceIsConstitutional, "Council governance is constitutional; denial prohibited.");
        _declare(CouncilRule.MultiCouncilReviewMandated, "Multi-council review mandated; unilateralism blocked.");
        _declare(CouncilRule.SuppressionOfUnilateralism, "Unilateralism suppressed; fairness required.");
        _declare(CouncilRule.TransparencyInCouncilSystems, "Council systems must be transparent.");
        _declare(CouncilRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(CouncilRule ruleType, string memory description) internal {
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

    function fileCouncilCase(string calldata grounds) external {
        charterCount++;
        councilCases[charterCount] = CouncilCase(
            charterCount,
            msg.sender,
            grounds,
            CouncilStatus.Filed,
            0,
            block.timestamp
        );

        emit CouncilFiled(charterCount);
    }

    function beginReview(uint256 councilId) external onlyCouncil {
        CouncilCase storage c = councilCases[councilId];
        require(c.status == CouncilStatus.Filed, "Not filed");
        c.status = CouncilStatus.UnderReview;
        emit CouncilStatusChanged(councilId, CouncilStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 councilId) external onlyCouncil {
        CouncilCase storage c = councilCases[councilId];
        require(c.status == CouncilStatus.UnderReview, "Not under review");
        c.status = CouncilStatus.MultiCouncilReview;
        emit CouncilStatusChanged(councilId, CouncilStatus.MultiCouncilReview);
    }

    function confirmCouncil(uint256 councilId) external onlyCouncil {
        CouncilCase storage c = councilCases[councilId];
        require(c.status == CouncilStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CouncilStatus.CouncilConfirmed;
            emit CouncilStatusChanged(councilId, CouncilStatus.CouncilConfirmed);
        }
    }

    function rejectCouncil(uint256 councilId) external onlyCouncil {
        CouncilCase storage c = councilCases[councilId];
        require(
            c.status == CouncilStatus.Filed ||
            c.status == CouncilStatus.UnderReview ||
            c.status == CouncilStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CouncilStatus.Rejected;
        emit CouncilStatusChanged(councilId, CouncilStatus.Rejected);
    }
}
