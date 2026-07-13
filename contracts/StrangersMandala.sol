// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Strangers Mandala
/// @notice Encodes safeguard for systemic humanity — treatment of strangers defines collective justice.
/// @dev Inspired by Shakespeare’s Sir Thomas More speech: abuse rebounds on the abuser.

contract StrangersMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum StrangerRule {
        HumanityIsConstitutional,
        StrangersProtected,
        AbuseReboundsOnAbuser,
        TransparencyMandated,
        CollectivePriorityAnchored
    }

    enum StrangerStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        HumanityConfirmed
    }

    struct Rule {
        uint256 id;
        StrangerRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct StrangerCase {
        uint256 id;
        address proposer;
        string grounds;
        StrangerStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => StrangerCase) public strangerCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, StrangerRule ruleType);
    event RuleLocked(uint256 indexed id);
    event StrangerFiled(uint256 indexed id);
    event StrangerStatusChanged(uint256 indexed id, StrangerStatus status);
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
        _declare(StrangerRule.HumanityIsConstitutional, "Humanity is constitutional; denial prohibited.");
        _declare(StrangerRule.StrangersProtected, "Strangers protected; systemic dignity enforced.");
        _declare(StrangerRule.AbuseReboundsOnAbuser, "Abuse rebounds on abuser; violence cycles back.");
        _declare(StrangerRule.TransparencyMandated, "Strangers systems must be auditable.");
        _declare(StrangerRule.CollectivePriorityAnchored, "Collective priority anchored; masa protected.");
    }

    function _declare(StrangerRule ruleType, string memory description) internal {
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

    function fileStrangerCase(string calldata grounds) external {
        mandalaCount++;
        strangerCases[mandalaCount] = StrangerCase(
            mandalaCount,
            msg.sender,
            grounds,
            StrangerStatus.Filed,
            0,
            block.timestamp
        );

        emit StrangerFiled(mandalaCount);
    }

    function beginReview(uint256 strangerId) external onlyCouncil {
        StrangerCase storage s = strangerCases[strangerId];
        require(s.status == StrangerStatus.Filed, "Not filed");
        s.status = StrangerStatus.UnderReview;
        emit StrangerStatusChanged(strangerId, StrangerStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 strangerId) external onlyCouncil {
        StrangerCase storage s = strangerCases[strangerId];
        require(s.status == StrangerStatus.UnderReview, "Not under review");
        s.status = StrangerStatus.MultiCouncilReview;
        emit StrangerStatusChanged(strangerId, StrangerStatus.MultiCouncilReview);
    }

    function confirmHumanity(uint256 strangerId) external onlyCouncil {
        StrangerCase storage s = strangerCases[strangerId];
        require(s.status == StrangerStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = StrangerStatus.HumanityConfirmed;
            emit StrangerStatusChanged(strangerId, StrangerStatus.HumanityConfirmed);
        }
    }

    function rejectStranger(uint256 strangerId) external onlyCouncil {
        StrangerCase storage s = strangerCases[strangerId];
        require(
            s.status == StrangerStatus.Filed ||
            s.status == StrangerStatus.UnderReview ||
            s.status == StrangerStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = StrangerStatus.Rejected;
        emit StrangerStatusChanged(strangerId, StrangerStatus.Rejected);
    }
}
