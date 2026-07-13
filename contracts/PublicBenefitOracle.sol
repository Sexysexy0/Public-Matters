// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Public Benefit Oracle
/// @notice Encodes public benefit safeguard.
/// @dev Complements InnovationSafetyCovenant, RiskContextReview, and BureaucraticAccountability.

contract PublicBenefitOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum BenefitRule {
        BenefitIsConstitutional,
        EliteCaptureSuppressed,
        MasaFirstMandated,
        OracleChecksRequired,
        TransparencyInBenefitSystems,
        PublicBenefitPriority
    }

    enum BenefitStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        BenefitConfirmed
    }

    struct Rule {
        uint256 id;
        BenefitRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct BenefitCase {
        uint256 id;
        address proposer;
        string grounds;
        BenefitStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => BenefitCase) public benefitCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, BenefitRule ruleType);
    event RuleLocked(uint256 indexed id);
    event BenefitFiled(uint256 indexed id);
    event BenefitStatusChanged(uint256 indexed id, BenefitStatus status);
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
        _declare(BenefitRule.BenefitIsConstitutional, "Public benefit is constitutional; denial prohibited.");
        _declare(BenefitRule.EliteCaptureSuppressed, "Elite capture suppressed; fairness required.");
        _declare(BenefitRule.MasaFirstMandated, "Masa-first mandated; inequity prohibited.");
        _declare(BenefitRule.OracleChecksRequired, "Oracle checks required; blind deployment blocked.");
        _declare(BenefitRule.TransparencyInBenefitSystems, "Benefit systems must be transparent.");
        _declare(BenefitRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(BenefitRule ruleType, string memory description) internal {
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

    function fileBenefitCase(string calldata grounds) external {
        oracleCount++;
        benefitCases[oracleCount] = BenefitCase(
            oracleCount,
            msg.sender,
            grounds,
            BenefitStatus.Filed,
            0,
            block.timestamp
        );

        emit BenefitFiled(oracleCount);
    }

    function beginReview(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.Filed, "Not filed");
        b.status = BenefitStatus.UnderReview;
        emit BenefitStatusChanged(benefitId, BenefitStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.UnderReview, "Not under review");
        b.status = BenefitStatus.MultiCouncilReview;
        emit BenefitStatusChanged(benefitId, BenefitStatus.MultiCouncilReview);
    }

    function confirmBenefit(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(b.status == BenefitStatus.MultiCouncilReview, "Not in council stage");

        b.approvals++;

        if (b.approvals * 2 > councilCount && councilCount > 0) {
            b.status = BenefitStatus.BenefitConfirmed;
            emit BenefitStatusChanged(benefitId, BenefitStatus.BenefitConfirmed);
        }
    }

    function rejectBenefit(uint256 benefitId) external onlyCouncil {
        BenefitCase storage b = benefitCases[benefitId];
        require(
            b.status == BenefitStatus.Filed ||
            b.status == BenefitStatus.UnderReview ||
            b.status == BenefitStatus.MultiCouncilReview,
            "Invalid status"
        );
        b.status = BenefitStatus.Rejected;
        emit BenefitStatusChanged(benefitId, BenefitStatus.Rejected);
    }
}
