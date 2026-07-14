// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Leadership Accountability Mandala
/// @notice Encodes safeguard for leadership auditability — authority must remain answerable to truth.
/// @dev Complements TransparencyMandala, PublicBenefitMandala, and BureaucraticAccountability.sol.

contract LeadershipAccountabilityMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum LeadershipRule {
        LeadershipIsAuditable,
        TruthOverridesRank,
        ReportCannotBeSuppressed,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum LeadershipStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AccountabilityConfirmed
    }

    struct Rule {
        uint256 id;
        LeadershipRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct LeadershipCase {
        uint256 id;
        address proposer;
        string grounds;
        LeadershipStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => LeadershipCase) public leadershipCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, LeadershipRule ruleType);
    event RuleLocked(uint256 indexed id);
    event LeadershipFiled(uint256 indexed id);
    event LeadershipStatusChanged(uint256 indexed id, LeadershipStatus status);
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
        _declare(LeadershipRule.LeadershipIsAuditable, "Leadership is auditable; denial prohibited.");
        _declare(LeadershipRule.TruthOverridesRank, "Truth overrides rank; hierarchy cannot silence evidence.");
        _declare(LeadershipRule.ReportCannotBeSuppressed, "Reports cannot be suppressed; findings must be public.");
        _declare(LeadershipRule.TransparencyMandated, "Leadership systems must be auditable.");
        _declare(LeadershipRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(LeadershipRule ruleType, string memory description) internal {
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

    function fileLeadershipCase(string calldata grounds) external {
        mandalaCount++;
        leadershipCases[mandalaCount] = LeadershipCase(
            mandalaCount,
            msg.sender,
            grounds,
            LeadershipStatus.Filed,
            0,
            block.timestamp
        );

        emit LeadershipFiled(mandalaCount);
    }

    function beginReview(uint256 leadershipId) external onlyCouncil {
        LeadershipCase storage l = leadershipCases[leadershipId];
        require(l.status == LeadershipStatus.Filed, "Not filed");
        l.status = LeadershipStatus.UnderReview;
        emit LeadershipStatusChanged(leadershipId, LeadershipStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 leadershipId) external onlyCouncil {
        LeadershipCase storage l = leadershipCases[leadershipId];
        require(l.status == LeadershipStatus.UnderReview, "Not under review");
        l.status = LeadershipStatus.MultiCouncilReview;
        emit LeadershipStatusChanged(leadershipId, LeadershipStatus.MultiCouncilReview);
    }

    function confirmAccountability(uint256 leadershipId) external onlyCouncil {
        LeadershipCase storage l = leadershipCases[leadershipId];
        require(l.status == LeadershipStatus.MultiCouncilReview, "Not in council stage");

        l.approvals++;

        if (l.approvals * 2 > councilCount && councilCount > 0) {
            l.status = LeadershipStatus.AccountabilityConfirmed;
            emit LeadershipStatusChanged(leadershipId, LeadershipStatus.AccountabilityConfirmed);
        }
    }

    function rejectLeadership(uint256 leadershipId) external onlyCouncil {
        LeadershipCase storage l = leadershipCases[leadershipId];
        require(
            l.status == LeadershipStatus.Filed ||
            l.status == LeadershipStatus.UnderReview ||
            l.status == LeadershipStatus.MultiCouncilReview,
            "Invalid status"
        );
        l.status = LeadershipStatus.Rejected;
        emit LeadershipStatusChanged(leadershipId, LeadershipStatus.Rejected);
    }
}
