// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Privacy Mandala
/// @notice Encodes safeguard for AI privacy — systemic, constitutional, non-optional.
/// @dev Complements SovereignAIOracle, DormantCodeOracle, and InnovationConstitution.

contract AIPrivacyMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum PrivacyRule {
        AIPrivacyIsConstitutional,
        ConsumerTierRestricted,
        EnterpriseTierMandated,
        SovereignDataProtected,
        TransparencyMandated,
        PublicBenefitPriority
    }

    enum PrivacyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        PrivacyConfirmed
    }

    struct Rule {
        uint256 id;
        PrivacyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct PrivacyCase {
        uint256 id;
        address proposer;
        string grounds;
        PrivacyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => PrivacyCase) public privacyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, PrivacyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event PrivacyFiled(uint256 indexed id);
    event PrivacyStatusChanged(uint256 indexed id, PrivacyStatus status);
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
        _declare(PrivacyRule.AIPrivacyIsConstitutional, "AI privacy is constitutional; denial prohibited.");
        _declare(PrivacyRule.ConsumerTierRestricted, "Consumer tier restricted; sensitive data banned.");
        _declare(PrivacyRule.EnterpriseTierMandated, "Enterprise tier mandated; contractual protections required.");
        _declare(PrivacyRule.SovereignDataProtected, "Sovereign data protected; crown jewels never leave.");
        _declare(PrivacyRule.TransparencyMandated, "AI privacy systems must be auditable.");
        _declare(PrivacyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(PrivacyRule ruleType, string memory description) internal {
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

    function filePrivacyCase(string calldata grounds) external {
        mandalaCount++;
        privacyCases[mandalaCount] = PrivacyCase(
            mandalaCount,
            msg.sender,
            grounds,
            PrivacyStatus.Filed,
            0,
            block.timestamp
        );

        emit PrivacyFiled(mandalaCount);
    }

    function beginReview(uint256 privacyId) external onlyCouncil {
        PrivacyCase storage p = privacyCases[privacyId];
        require(p.status == PrivacyStatus.Filed, "Not filed");
        p.status = PrivacyStatus.UnderReview;
        emit PrivacyStatusChanged(privacyId, PrivacyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 privacyId) external onlyCouncil {
        PrivacyCase storage p = privacyCases[privacyId];
        require(p.status == PrivacyStatus.UnderReview, "Not under review");
        p.status = PrivacyStatus.MultiCouncilReview;
        emit PrivacyStatusChanged(privacyId, PrivacyStatus.MultiCouncilReview);
    }

    function confirmPrivacy(uint256 privacyId) external onlyCouncil {
        PrivacyCase storage p = privacyCases[privacyId];
        require(p.status == PrivacyStatus.MultiCouncilReview, "Not in council stage");

        p.approvals++;

        if (p.approvals * 2 > councilCount && councilCount > 0) {
            p.status = PrivacyStatus.PrivacyConfirmed;
            emit PrivacyStatusChanged(privacyId, PrivacyStatus.PrivacyConfirmed);
        }
    }

    function rejectPrivacy(uint256 privacyId) external onlyCouncil {
        PrivacyCase storage p = privacyCases[privacyId];
        require(
            p.status == PrivacyStatus.Filed ||
            p.status == PrivacyStatus.UnderReview ||
            p.status == PrivacyStatus.MultiCouncilReview,
            "Invalid status"
        );
        p.status = PrivacyStatus.Rejected;
        emit PrivacyStatusChanged(privacyId, PrivacyStatus.Rejected);
    }
}
