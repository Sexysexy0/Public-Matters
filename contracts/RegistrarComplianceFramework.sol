// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Registrar Compliance Framework
/// @notice Encodes compliance obligations for domain registrars.
/// @dev Complements RegistrarNoticeMandala, PublicBenefitOracle, and BureaucraticAccountability.

contract RegistrarComplianceFramework {
    address public guardian;
    uint256 public frameworkCount;
    uint256 public councilCount;

    enum ComplianceRule {
        AccurateDataIsConstitutional,
        VerificationMandated,
        FalseDataSuppressed,
        TransparencyInRegistrarSystems,
        PublicBenefitPriority
    }

    enum ComplianceStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ComplianceConfirmed
    }

    struct Rule {
        uint256 id;
        ComplianceRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ComplianceCase {
        uint256 id;
        address proposer;
        string grounds;
        ComplianceStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => ComplianceCase) public complianceCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ComplianceRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ComplianceFiled(uint256 indexed id);
    event ComplianceStatusChanged(uint256 indexed id, ComplianceStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        frameworkCount = 0;
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
        _declare(ComplianceRule.AccurateDataIsConstitutional, "Accurate data is constitutional; denial prohibited.");
        _declare(ComplianceRule.VerificationMandated, "Verification mandated; false data blocked.");
        _declare(ComplianceRule.FalseDataSuppressed, "False data suppressed; fairness required.");
        _declare(ComplianceRule.TransparencyInRegistrarSystems, "Registrar systems must be transparent.");
        _declare(ComplianceRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ComplianceRule ruleType, string memory description) internal {
        frameworkCount++;
        rules[frameworkCount] = Rule(
            frameworkCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(frameworkCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileComplianceCase(string calldata grounds) external {
        frameworkCount++;
        complianceCases[frameworkCount] = ComplianceCase(
            frameworkCount,
            msg.sender,
            grounds,
            ComplianceStatus.Filed,
            0,
            block.timestamp
        );

        emit ComplianceFiled(frameworkCount);
    }

    function beginReview(uint256 complianceId) external onlyCouncil {
        ComplianceCase storage c = complianceCases[complianceId];
        require(c.status == ComplianceStatus.Filed, "Not filed");
        c.status = ComplianceStatus.UnderReview;
        emit ComplianceStatusChanged(complianceId, ComplianceStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 complianceId) external onlyCouncil {
        ComplianceCase storage c = complianceCases[complianceId];
        require(c.status == ComplianceStatus.UnderReview, "Not under review");
        c.status = ComplianceStatus.MultiCouncilReview;
        emit ComplianceStatusChanged(complianceId, ComplianceStatus.MultiCouncilReview);
    }

    function confirmCompliance(uint256 complianceId) external onlyCouncil {
        ComplianceCase storage c = complianceCases[complianceId];
        require(c.status == ComplianceStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ComplianceStatus.ComplianceConfirmed;
            emit ComplianceStatusChanged(complianceId, ComplianceStatus.ComplianceConfirmed);
        }
    }

    function rejectCompliance(uint256 complianceId) external onlyCouncil {
        ComplianceCase storage c = complianceCases[complianceId];
        require(
            c.status == ComplianceStatus.Filed ||
            c.status == ComplianceStatus.UnderReview ||
            c.status == ComplianceStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ComplianceStatus.Rejected;
        emit ComplianceStatusChanged(complianceId, ComplianceStatus.Rejected);
    }
}
