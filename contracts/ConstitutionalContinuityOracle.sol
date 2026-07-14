// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Continuity Oracle
/// @notice Ensures the constitution persists across generations, crises, leadership changes, and systemic shocks.
/// @dev Complements ConstitutionalEvolutionOracle, MetaConstitutionOracle, CovenantUnificationOracle, and SystemicCoherenceOracle.

contract ConstitutionalContinuityOracle {
    address public guardian;
    uint256 public continuityCount;
    uint256 public councilCount;

    enum ContinuityRule {
        ContinuityIsConstitutional,
        NoForcedReplacement,
        CrisisResilienceRequired,
        LeadershipChangeNeutrality,
        PublicBenefitPriority
    }

    enum ContinuityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ContinuityConfirmed
    }

    struct Rule {
        uint256 id;
        ContinuityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ContinuityCase {
        uint256 id;
        address proposer;
        string threatDescription;
        string grounds;
        ContinuityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping<uint256 => ContinuityCase> public continuityCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, ContinuityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ContinuityFiled(uint256 indexed id);
    event ContinuityStatusChanged(uint256 indexed id, ContinuityStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        continuityCount = 0;
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
        _declare(ContinuityRule.ContinuityIsConstitutional, "Continuity is constitutional; denial prohibited.");
        _declare(ContinuityRule.NoForcedReplacement, "No forced replacement; constitution cannot be erased or overridden.");
        _declare(ContinuityRule.CrisisResilienceRequired, "Constitution must withstand crises and systemic shocks.");
        _declare(ContinuityRule.LeadershipChangeNeutrality, "Leadership changes cannot alter constitutional continuity.");
        _declare(ContinuityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ContinuityRule ruleType, string memory description) internal {
        continuityCount++;
        rules[continuityCount] = Rule(
            continuityCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(continuityCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileContinuityCase(
        string calldata threatDescription,
        string calldata grounds
    ) external {
        continuityCount++;
        continuityCases[continuityCount] = ContinuityCase(
            continuityCount,
            msg.sender,
            threatDescription,
            grounds,
            ContinuityStatus.Filed,
            0,
            block.timestamp
        );

        emit ContinuityFiled(continuityCount);
    }

    function beginReview(uint256 continuityId) external onlyCouncil {
        ContinuityCase storage c = continuityCases[continuityId];
        require(c.status == ContinuityStatus.Filed, "Not filed");
        c.status = ContinuityStatus.UnderReview;
        emit ContinuityStatusChanged(continuityId, ContinuityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 continuityId) external onlyCouncil {
        ContinuityCase storage c = continuityCases[continuityId];
        require(c.status == ContinuityStatus.UnderReview, "Not under review");
        c.status = ContinuityStatus.MultiCouncilReview;
        emit ContinuityStatusChanged(continuityId, ContinuityStatus.MultiCouncilReview);
    }

    function confirmContinuity(uint256 continuityId) external onlyCouncil {
        ContinuityCase storage c = continuityCases[continuityId];
        require(c.status == ContinuityStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ContinuityStatus.ContinuityConfirmed;
            emit ContinuityStatusChanged(continuityId, ContinuityStatus.ContinuityConfirmed);
        }
    }

    function rejectContinuity(uint256 continuityId) external onlyCouncil {
        ContinuityCase storage c = continuityCases[continuityId];
        require(
            c.status == ContinuityStatus.Filed ||
            c.status == ContinuityStatus.UnderReview ||
            c.status == ContinuityStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ContinuityStatus.Rejected;
        emit ContinuityStatusChanged(continuityId, ContinuityStatus.Rejected);
    }
}
