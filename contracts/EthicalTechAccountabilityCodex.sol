// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Ethical Tech Accountability Codex
/// @notice Encodes consumer trust and ethical safeguards in technology adoption.
/// @dev Complements BureaucraticAccountability, DataOracle, and AITransparencyMandala.

contract EthicalTechAccountabilityCodex {
    address public guardian;
    uint256 public codexCount;
    uint256 public councilCount;

    enum EthicalRule {
        TrustIsConstitutional,
        EthicsMandated,
        ExploitationSuppressed,
        TransparencyInTechSystems,
        PublicBenefitPriority
    }

    enum EthicalStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EthicsConfirmed
    }

    struct Rule {
        uint256 id;
        EthicalRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct EthicalCase {
        uint256 id;
        address proposer;
        string grounds;
        EthicalStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => EthicalCase) public ethicalCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EthicalRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EthicsFiled(uint256 indexed id);
    event EthicsStatusChanged(uint256 indexed id, EthicalStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        codexCount = 0;
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
        _declare(EthicalRule.TrustIsConstitutional, "Consumer trust is constitutional; denial prohibited.");
        _declare(EthicalRule.EthicsMandated, "Ethics mandated; exploitation blocked.");
        _declare(EthicalRule.ExploitationSuppressed, "Exploitation suppressed; fairness required.");
        _declare(EthicalRule.TransparencyInTechSystems, "Tech systems must be transparent.");
        _declare(EthicalRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(EthicalRule ruleType, string memory description) internal {
        codexCount++;
        rules[codexCount] = Rule(
            codexCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(codexCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileEthicalCase(string calldata grounds) external {
        codexCount++;
        ethicalCases[codexCount] = EthicalCase(
            codexCount,
            msg.sender,
            grounds,
            EthicalStatus.Filed,
            0,
            block.timestamp
        );

        emit EthicsFiled(codexCount);
    }

    function beginReview(uint256 ethicsId) external onlyCouncil {
        EthicalCase storage e = ethicalCases[ethicsId];
        require(e.status == EthicalStatus.Filed, "Not filed");
        e.status = EthicalStatus.UnderReview;
        emit EthicsStatusChanged(ethicsId, EthicalStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 ethicsId) external onlyCouncil {
        EthicalCase storage e = ethicalCases[ethicsId];
        require(e.status == EthicalStatus.UnderReview, "Not under review");
        e.status = EthicalStatus.MultiCouncilReview;
        emit EthicsStatusChanged(ethicsId, EthicalStatus.MultiCouncilReview);
    }

    function confirmEthics(uint256 ethicsId) external onlyCouncil {
        EthicalCase storage e = ethicalCases[ethicsId];
        require(e.status == EthicalStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EthicalStatus.EthicsConfirmed;
            emit EthicsStatusChanged(ethicsId, EthicalStatus.EthicsConfirmed);
        }
    }

    function rejectEthics(uint256 ethicsId) external onlyCouncil {
        EthicalCase storage e = ethicalCases[ethicsId];
        require(
            e.status == EthicalStatus.Filed ||
            e.status == EthicalStatus.UnderReview ||
            e.status == EthicalStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EthicalStatus.Rejected;
        emit EthicsStatusChanged(ethicsId, EthicalStatus.Rejected);
    }
}
