// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Bureaucratic Accountability
/// @notice Encodes bureaucratic accountability safeguard.
/// @dev Complements InnovationConstitution, InnovationFreedomCharter, and PublicBenefitOracle.

contract BureaucraticAccountability {
    address public guardian;
    uint256 public accountabilityCount;
    uint256 public councilCount;

    enum BureauRule {
        AccountabilityIsConstitutional,
        ChecksAndBalancesRequired,
        TransparencyMandated,
        ResponsibilityClarified,
        AbuseSuppressed,
        PublicBenefitPriority
    }

    enum BureauStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AccountabilityConfirmed
    }

    struct Rule {
        uint256 id;
        BureauRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Accountability {
        uint256 id;
        address proposer;
        string grounds;
        BureauStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Accountability) public accountabilities;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, BureauRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AccountabilityFiled(uint256 indexed id);
    event BureauStatusChanged(uint256 indexed id, BureauStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        accountabilityCount = 0;
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
        _declare(BureauRule.AccountabilityIsConstitutional, "Accountability is constitutional; denial prohibited.");
        _declare(BureauRule.ChecksAndBalancesRequired, "Checks and balances required; overreach prohibited.");
        _declare(BureauRule.TransparencyMandated, "Transparency mandated; opacity blocked.");
        _declare(BureauRule.ResponsibilityClarified, "Responsibility clarified; neglect prohibited.");
        _declare(BureauRule.AbuseSuppressed, "Abuse suppressed; fairness required.");
        _declare(BureauRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(BureauRule ruleType, string memory description) internal {
        accountabilityCount++;
        rules[accountabilityCount] = Rule(
            accountabilityCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(accountabilityCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileAccountability(string calldata grounds) external {
        accountabilityCount++;
        accountabilities[accountabilityCount] = Accountability(
            accountabilityCount,
            msg.sender,
            grounds,
            BureauStatus.Filed,
            0,
            block.timestamp
        );

        emit AccountabilityFiled(accountabilityCount);
    }

    function beginReview(uint256 accountabilityId) external onlyCouncil {
        Accountability storage a = accountabilities[accountabilityId];
        require(a.status == BureauStatus.Filed, "Not filed");
        a.status = BureauStatus.UnderReview;
        emit BureauStatusChanged(accountabilityId, BureauStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 accountabilityId) external onlyCouncil {
        Accountability storage a = accountabilities[accountabilityId];
        require(a.status == BureauStatus.UnderReview, "Not under review");
        a.status = BureauStatus.MultiCouncilReview;
        emit BureauStatusChanged(accountabilityId, BureauStatus.MultiCouncilReview);
    }

    function confirmAccountability(uint256 accountabilityId) external onlyCouncil {
        Accountability storage a = accountabilities[accountabilityId];
        require(a.status == BureauStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = BureauStatus.AccountabilityConfirmed;
            emit BureauStatusChanged(accountabilityId, BureauStatus.AccountabilityConfirmed);
        }
    }

    function rejectAccountability(uint256 accountabilityId) external onlyCouncil {
        Accountability storage a = accountabilities[accountabilityId];
        require(
            a.status == BureauStatus.Filed ||
            a.status == BureauStatus.UnderReview ||
            a.status == BureauStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = BureauStatus.Rejected;
        emit BureauStatusChanged(accountabilityId, BureauStatus.Rejected);
    }
}
