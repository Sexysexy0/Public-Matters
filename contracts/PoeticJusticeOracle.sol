// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Poetic Justice Oracle
/// @notice Encodes safeguard for poetic justice against systemic abusers.
/// @dev Complements ShadowGuardianMandala, AnomalyRecognitionOracle, and PublicBenefitOracle.

contract PoeticJusticeOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum JusticeRule {
        PoeticJusticeIsConstitutional,
        ConsequenceMandated,
        ProtectionRemoved,
        TransparencyInJusticeSystems,
        PublicBenefitPriority
    }

    enum JusticeStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        JusticeConfirmed
    }

    struct Rule {
        uint256 id;
        JusticeRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct JusticeCase {
        uint256 id;
        address proposer;
        string grounds;
        JusticeStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => JusticeCase) public justiceCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, JusticeRule ruleType);
    event RuleLocked(uint256 indexed id);
    event JusticeFiled(uint256 indexed id);
    event JusticeStatusChanged(uint256 indexed id, JusticeStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        oracleCount = 0;
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
        _declare(JusticeRule.PoeticJusticeIsConstitutional, "Poetic justice is constitutional; denial prohibited.");
        _declare(JusticeRule.ConsequenceMandated, "Consequence mandated; abusers face their own actions.");
        _declare(JusticeRule.ProtectionRemoved, "Protection removed; systemic shields dismantled.");
        _declare(JusticeRule.TransparencyInJusticeSystems, "Justice systems must be transparent.");
        _declare(JusticeRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(JusticeRule ruleType, string memory description) internal {
        oracleCount++;
        rules[oracleCount] = Rule(
            oracleCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(oracleCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileJusticeCase(string calldata grounds) external {
        oracleCount++;
        justiceCases[oracleCount] = JusticeCase(
            oracleCount,
            msg.sender,
            grounds,
            JusticeStatus.Filed,
            0,
            block.timestamp
        );

        emit JusticeFiled(oracleCount);
    }

    function beginReview(uint256 justiceId) external onlyCouncil {
        JusticeCase storage j = justiceCases[justiceId];
        require(j.status == JusticeStatus.Filed, "Not filed");
        j.status = JusticeStatus.UnderReview;
        emit JusticeStatusChanged(justiceId, JusticeStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 justiceId) external onlyCouncil {
        JusticeCase storage j = justiceCases[justiceId];
        require(j.status == JusticeStatus.UnderReview, "Not under review");
        j.status = JusticeStatus.MultiCouncilReview;
        emit JusticeStatusChanged(justiceId, JusticeStatus.MultiCouncilReview);
    }

    function confirmJustice(uint256 justiceId) external onlyCouncil {
        JusticeCase storage j = justiceCases[justiceId];
        require(j.status == JusticeStatus.MultiCouncilReview, "Not in council stage");

        j.approvals++;

        if (j.approvals * 2 > councilCount && councilCount > 0) {
            j.status = JusticeStatus.JusticeConfirmed;
            emit JusticeStatusChanged(justiceId, JusticeStatus.JusticeConfirmed);
        }
    }

    function rejectJustice(uint256 justiceId) external onlyCouncil {
        JusticeCase storage j = justiceCases[justiceId];
        require(
            j.status == JusticeStatus.Filed ||
            j.status == JusticeStatus.UnderReview ||
            j.status == JusticeStatus.MultiCouncilReview,
            "Invalid status"
        );
        j.status = JusticeStatus.Rejected;
        emit JusticeStatusChanged(justiceId, JusticeStatus.Rejected);
    }
}
