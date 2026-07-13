// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Sovereign AI Oracle
/// @notice Encodes safeguard for sovereign AI use — tools must come to family-owned data.
/// @dev Mirrors essay principle: trust depends on design, not hope.

contract SovereignAIOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum SovereignRule {
        SovereignAIIsConstitutional,
        ToolsComeToData,
        CrownJewelsNeverLeave,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum SovereignStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SovereignConfirmed
    }

    struct Rule {
        uint256 id;
        SovereignRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SovereignCase {
        uint256 id;
        address proposer;
        string grounds;
        SovereignStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SovereignCase) public sovereignCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SovereignRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SovereignFiled(uint256 indexed id);
    event SovereignStatusChanged(uint256 indexed id, SovereignStatus status);
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
        _declare(SovereignRule.SovereignAIIsConstitutional, "Sovereign AI is constitutional; denial prohibited.");
        _declare(SovereignRule.ToolsComeToData, "Tools must come to sovereign data.");
        _declare(SovereignRule.CrownJewelsNeverLeave, "Crown jewels never leave family control.");
        _declare(SovereignRule.TransparencyMandated, "Sovereign AI systems must be auditable.");
        _declare(SovereignRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SovereignRule ruleType, string memory description) internal {
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

    function fileSovereignCase(string calldata grounds) external {
        oracleCount++;
        sovereignCases[oracleCount] = SovereignCase(
            oracleCount,
            msg.sender,
            grounds,
            SovereignStatus.Filed,
            0,
            block.timestamp
        );

        emit SovereignFiled(oracleCount);
    }

    function beginReview(uint256 sovereignId) external onlyCouncil {
        SovereignCase storage s = sovereignCases[sovereignId];
        require(s.status == SovereignStatus.Filed, "Not filed");
        s.status = SovereignStatus.UnderReview;
        emit SovereignStatusChanged(sovereignId, SovereignStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 sovereignId) external onlyCouncil {
        SovereignCase storage s = sovereignCases[sovereignId];
        require(s.status == SovereignStatus.UnderReview, "Not under review");
        s.status = SovereignStatus.MultiCouncilReview;
        emit SovereignStatusChanged(sovereignId, SovereignStatus.MultiCouncilReview);
    }

    function confirmSovereign(uint256 sovereignId) external onlyCouncil {
        SovereignCase storage s = sovereignCases[sovereignId];
        require(s.status == SovereignStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SovereignStatus.SovereignConfirmed;
            emit SovereignStatusChanged(sovereignId, SovereignStatus.SovereignConfirmed);
        }
    }

    function rejectSovereign(uint256 sovereignId) external onlyCouncil {
        SovereignCase storage s = sovereignCases[sovereignId];
        require(
            s.status == SovereignStatus.Filed ||
            s.status == SovereignStatus.UnderReview ||
            s.status == SovereignStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SovereignStatus.Rejected;
        emit SovereignStatusChanged(sovereignId, SovereignStatus.Rejected);
    }
}
