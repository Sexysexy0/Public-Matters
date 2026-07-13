// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Data Sovereignty Oracle
/// @notice Encodes safeguard for systemic data sovereignty — ownership respected, crown jewels never leave.
/// @dev Complements AIPrivacyMandala, SovereignAIOracle, and DormantCodeOracle.

contract DataSovereigntyOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum SovereigntyRule {
        DataSovereigntyIsConstitutional,
        ToolsRespectOwnership,
        CrownJewelsNeverLeave,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum SovereigntyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SovereigntyConfirmed
    }

    struct Rule {
        uint256 id;
        SovereigntyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SovereigntyCase {
        uint256 id;
        address proposer;
        string grounds;
        SovereigntyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SovereigntyCase) public sovereigntyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SovereigntyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SovereigntyFiled(uint256 indexed id);
    event SovereigntyStatusChanged(uint256 indexed id, SovereigntyStatus status);
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
        _declare(SovereigntyRule.DataSovereigntyIsConstitutional, "Data sovereignty is constitutional; denial prohibited.");
        _declare(SovereigntyRule.ToolsRespectOwnership, "Tools must respect ownership; no unauthorized use.");
        _declare(SovereigntyRule.CrownJewelsNeverLeave, "Crown jewels never leave sovereign control.");
        _declare(SovereigntyRule.TransparencyMandated, "Data sovereignty systems must be auditable.");
        _declare(SovereigntyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SovereigntyRule ruleType, string memory description) internal {
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

    function fileSovereigntyCase(string calldata grounds) external {
        oracleCount++;
        sovereigntyCases[oracleCount] = SovereigntyCase(
            oracleCount,
            msg.sender,
            grounds,
            SovereigntyStatus.Filed,
            0,
            block.timestamp
        );

        emit SovereigntyFiled(oracleCount);
    }

    function beginReview(uint256 sovereigntyId) external onlyCouncil {
        SovereigntyCase storage s = sovereigntyCases[sovereigntyId];
        require(s.status == SovereigntyStatus.Filed, "Not filed");
        s.status = SovereigntyStatus.UnderReview;
        emit SovereigntyStatusChanged(sovereigntyId, SovereigntyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 sovereigntyId) external onlyCouncil {
        SovereigntyCase storage s = sovereigntyCases[sovereigntyId];
        require(s.status == SovereigntyStatus.UnderReview, "Not under review");
        s.status = SovereigntyStatus.MultiCouncilReview;
        emit SovereigntyStatusChanged(sovereigntyId, SovereigntyStatus.MultiCouncilReview);
    }

    function confirmSovereignty(uint256 sovereigntyId) external onlyCouncil {
        SovereigntyCase storage s = sovereigntyCases[sovereigntyId];
        require(s.status == SovereigntyStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SovereigntyStatus.SovereigntyConfirmed;
            emit SovereigntyStatusChanged(sovereigntyId, SovereigntyStatus.SovereigntyConfirmed);
        }
    }

    function rejectSovereignty(uint256 sovereigntyId) external onlyCouncil {
        SovereigntyCase storage s = sovereigntyCases[sovereigntyId];
        require(
            s.status == SovereigntyStatus.Filed ||
            s.status == SovereigntyStatus.UnderReview ||
            s.status == SovereigntyStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SovereigntyStatus.Rejected;
        emit SovereigntyStatusChanged(sovereigntyId, SovereigntyStatus.Rejected);
    }
}
