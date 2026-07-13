// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Bureaucratic Accountability Covenant
/// @notice Encodes board alignment and leadership accountability safeguard.
/// @dev Complements DataOracle, AITransparencyMandala, and InnovationSafetyCovenant.

contract BureaucraticAccountability {
    address public guardian;
    uint256 public accountabilityCount;
    uint256 public councilCount;

    enum AccountabilityRule {
        AlignmentIsConstitutional,
        TransparencyMandated,
        DisconnectSuppressed,
        AccountabilityInLeadershipSystems,
        PublicBenefitPriority
    }

    enum AccountabilityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        AccountabilityConfirmed
    }

    struct Rule {
        uint256 id;
        AccountabilityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct AccountabilityCase {
        uint256 id;
        address proposer;
        string grounds;
        AccountabilityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => AccountabilityCase) public accountabilityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, AccountabilityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event AccountabilityFiled(uint256 indexed id);
    event AccountabilityStatusChanged(uint256 indexed id, AccountabilityStatus status);
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
        _declare(AccountabilityRule.AlignmentIsConstitutional, "Alignment is constitutional; denial prohibited.");
        _declare(AccountabilityRule.TransparencyMandated, "Transparency mandated; disconnect blocked.");
        _declare(AccountabilityRule.DisconnectSuppressed, "Disconnect suppressed; fairness required.");
        _declare(AccountabilityRule.AccountabilityInLeadershipSystems, "Leadership systems must be accountable.");
        _declare(AccountabilityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(AccountabilityRule ruleType, string memory description) internal {
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

    function fileAccountabilityCase(string calldata grounds) external {
        accountabilityCount++;
        accountabilityCases[accountabilityCount] = AccountabilityCase(
            accountabilityCount,
            msg.sender,
            grounds,
            AccountabilityStatus.Filed,
            0,
            block.timestamp
        );

        emit AccountabilityFiled(accountabilityCount);
    }

    function beginReview(uint256 accountabilityId) external onlyCouncil {
        AccountabilityCase storage a = accountabilityCases[accountabilityId];
        require(a.status == AccountabilityStatus.Filed, "Not filed");
        a.status = AccountabilityStatus.UnderReview;
        emit AccountabilityStatusChanged(accountabilityId, AccountabilityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 accountabilityId) external onlyCouncil {
        AccountabilityCase storage a = accountabilityCases[accountabilityId];
        require(a.status == AccountabilityStatus.UnderReview, "Not under review");
        a.status = AccountabilityStatus.MultiCouncilReview;
        emit AccountabilityStatusChanged(accountabilityId, AccountabilityStatus.MultiCouncilReview);
    }

    function confirmAccountability(uint256 accountabilityId) external onlyCouncil {
        AccountabilityCase storage a = accountabilityCases[accountabilityId];
        require(a.status == AccountabilityStatus.MultiCouncilReview, "Not in council stage");

        a.approvals++;

        if (a.approvals * 2 > councilCount && councilCount > 0) {
            a.status = AccountabilityStatus.AccountabilityConfirmed;
            emit AccountabilityStatusChanged(accountabilityId, AccountabilityStatus.AccountabilityConfirmed);
        }
    }

    function rejectAccountability(uint256 accountabilityId) external onlyCouncil {
        AccountabilityCase storage a = accountabilityCases[accountabilityId];
        require(
            a.status == AccountabilityStatus.Filed ||
            a.status == AccountabilityStatus.UnderReview ||
            a.status == AccountabilityStatus.MultiCouncilReview,
            "Invalid status"
        );
        a.status = AccountabilityStatus.Rejected;
        emit AccountabilityStatusChanged(accountabilityId, AccountabilityStatus.Rejected);
    }
}
