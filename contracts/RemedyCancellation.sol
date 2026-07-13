// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Remedy Cancellation Framework
/// @notice Encodes true cancellation remedy safeguard.
/// @dev Complements PanelistQuality, CaseLawCodification, and AppealsMandala.

contract RemedyCancellation {
    address public guardian;
    uint256 public remedyCount;
    uint256 public councilCount;

    enum RemedyRule {
        CancellationIsConstitutional,
        RemedyMandated,
        AbuseSuppressed,
        TransparencyInRemedySystems,
        PublicBenefitPriority
    }

    enum RemedyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        RemedyConfirmed
    }

    struct Rule {
        uint256 id;
        RemedyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct RemedyCase {
        uint256 id;
        address proposer;
        string grounds;
        RemedyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => RemedyCase) public remedies;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, RemedyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event RemedyFiled(uint256 indexed id);
    event RemedyStatusChanged(uint256 indexed id, RemedyStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        remedyCount = 0;
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
        _declare(RemedyRule.CancellationIsConstitutional, "Cancellation is constitutional; denial prohibited.");
        _declare(RemedyRule.RemedyMandated, "Remedy mandated; abuse blocked.");
        _declare(RemedyRule.AbuseSuppressed, "Abuse suppressed; fairness required.");
        _declare(RemedyRule.TransparencyInRemedySystems, "Remedy systems must be transparent.");
        _declare(RemedyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(RemedyRule ruleType, string memory description) internal {
        remedyCount++;
        rules[remedyCount] = Rule(
            remedyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(remedyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileRemedyCase(string calldata grounds) external {
        remedyCount++;
        remedies[remedyCount] = RemedyCase(
            remedyCount,
            msg.sender,
            grounds,
            RemedyStatus.Filed,
            0,
            block.timestamp
        );

        emit RemedyFiled(remedyCount);
    }

    function beginReview(uint256 remedyId) external onlyCouncil {
        RemedyCase storage r = remedies[remedyId];
        require(r.status == RemedyStatus.Filed, "Not filed");
        r.status = RemedyStatus.UnderReview;
        emit RemedyStatusChanged(remedyId, RemedyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 remedyId) external onlyCouncil {
        RemedyCase storage r = remedies[remedyId];
        require(r.status == RemedyStatus.UnderReview, "Not under review");
        r.status = RemedyStatus.MultiCouncilReview;
        emit RemedyStatusChanged(remedyId, RemedyStatus.MultiCouncilReview);
    }

    function confirmRemedy(uint256 remedyId) external onlyCouncil {
        RemedyCase storage r = remedies[remedyId];
        require(r.status == RemedyStatus.MultiCouncilReview, "Not in council stage");

        r.approvals++;

        if (r.approvals * 2 > councilCount && councilCount > 0) {
            r.status = RemedyStatus.RemedyConfirmed;
            emit RemedyStatusChanged(remedyId, RemedyStatus.RemedyConfirmed);
        }
    }

    function rejectRemedy(uint256 remedyId) external onlyCouncil {
        RemedyCase storage r = remedies[remedyId];
        require(
            r.status == RemedyStatus.Filed ||
            r.status == RemedyStatus.UnderReview ||
            r.status == RemedyStatus.MultiCouncilReview,
            "Invalid status"
        );
        r.status = RemedyStatus.Rejected;
        emit RemedyStatusChanged(remedyId, RemedyStatus.Rejected);
    }
}
