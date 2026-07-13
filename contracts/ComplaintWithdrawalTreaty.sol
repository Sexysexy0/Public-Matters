// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Complaint Withdrawal Treaty
/// @notice Encodes safeguard for withdrawal of complaints in domain dispute resolution.
/// @dev Complements AppealsMandala, RegistrarComplianceFramework, and PublicBenefitOracle.

contract ComplaintWithdrawalTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public councilCount;

    enum WithdrawalRule {
        WithdrawalIsConstitutional,
        TransparencyMandated,
        AbuseSuppressed,
        RespectForCourtMandated,
        PublicBenefitPriority
    }

    enum WithdrawalStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        WithdrawalConfirmed
    }

    struct Rule {
        uint256 id;
        WithdrawalRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct WithdrawalCase {
        uint256 id;
        address proposer;
        string grounds;
        WithdrawalStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => WithdrawalCase) public withdrawalCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, WithdrawalRule ruleType);
    event RuleLocked(uint256 indexed id);
    event WithdrawalFiled(uint256 indexed id);
    event WithdrawalStatusChanged(uint256 indexed id, WithdrawalStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        treatyCount = 0;
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
        _declare(WithdrawalRule.WithdrawalIsConstitutional, "Withdrawal is constitutional; denial prohibited.");
        _declare(WithdrawalRule.TransparencyMandated, "Transparency mandated; abuse blocked.");
        _declare(WithdrawalRule.AbuseSuppressed, "Abuse suppressed; fairness required.");
        _declare(WithdrawalRule.RespectForCourtMandated, "Respect for court mandated; supremacy recognized.");
        _declare(WithdrawalRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(WithdrawalRule ruleType, string memory description) internal {
        treatyCount++;
        rules[treatyCount] = Rule(
            treatyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(treatyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileWithdrawalCase(string calldata grounds) external {
        treatyCount++;
        withdrawalCases[treatyCount] = WithdrawalCase(
            treatyCount,
            msg.sender,
            grounds,
            WithdrawalStatus.Filed,
            0,
            block.timestamp
        );

        emit WithdrawalFiled(treatyCount);
    }

    function beginReview(uint256 withdrawalId) external onlyCouncil {
        WithdrawalCase storage w = withdrawalCases[withdrawalId];
        require(w.status == WithdrawalStatus.Filed, "Not filed");
        w.status = WithdrawalStatus.UnderReview;
        emit WithdrawalStatusChanged(withdrawalId, WithdrawalStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 withdrawalId) external onlyCouncil {
        WithdrawalCase storage w = withdrawalCases[withdrawalId];
        require(w.status == WithdrawalStatus.UnderReview, "Not under review");
        w.status = WithdrawalStatus.MultiCouncilReview;
        emit WithdrawalStatusChanged(withdrawalId, WithdrawalStatus.MultiCouncilReview);
    }

    function confirmWithdrawal(uint256 withdrawalId) external onlyCouncil {
        WithdrawalCase storage w = withdrawalCases[withdrawalId];
        require(w.status == WithdrawalStatus.MultiCouncilReview, "Not in council stage");

        w.approvals++;

        if (w.approvals * 2 > councilCount && councilCount > 0) {
            w.status = WithdrawalStatus.WithdrawalConfirmed;
            emit WithdrawalStatusChanged(withdrawalId, WithdrawalStatus.WithdrawalConfirmed);
        }
    }

    function rejectWithdrawal(uint256 withdrawalId) external onlyCouncil {
        WithdrawalCase storage w = withdrawalCases[withdrawalId];
        require(
            w.status == WithdrawalStatus.Filed ||
            w.status == WithdrawalStatus.UnderReview ||
            w.status == WithdrawalStatus.MultiCouncilReview,
            "Invalid status"
        );
        w.status = WithdrawalStatus.Rejected;
        emit WithdrawalStatusChanged(withdrawalId, WithdrawalStatus.Rejected);
    }
}
