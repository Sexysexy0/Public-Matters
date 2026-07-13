// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Identity Rebuild Mandala
/// @notice Encodes safeguard for rebuilding identity and eliminating self-sabotage.
/// @dev Complements VictimhoodExitCharter, ResilienceShiftOracle, and InnovationFreedomCharter.

contract IdentityRebuildMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum IdentityRule {
        IdentityRebuildIsConstitutional,
        RenewalMandated,
        SelfSabotageSuppressed,
        TransparencyInIdentitySystems,
        PublicBenefitPriority
    }

    enum IdentityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        IdentityConfirmed
    }

    struct Rule {
        uint256 id;
        IdentityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct IdentityCase {
        uint256 id;
        address proposer;
        string grounds;
        IdentityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => IdentityCase) public identityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, IdentityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event IdentityFiled(uint256 indexed id);
    event IdentityStatusChanged(uint256 indexed id, IdentityStatus status);
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
        _declare(IdentityRule.IdentityRebuildIsConstitutional, "Identity rebuild is constitutional; denial prohibited.");
        _declare(IdentityRule.RenewalMandated, "Renewal mandated; stagnation blocked.");
        _declare(IdentityRule.SelfSabotageSuppressed, "Self-sabotage suppressed; fairness required.");
        _declare(IdentityRule.TransparencyInIdentitySystems, "Identity systems must be transparent.");
        _declare(IdentityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(IdentityRule ruleType, string memory description) internal {
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

    function fileIdentityCase(string calldata grounds) external {
        mandalaCount++;
        identityCases[mandalaCount] = IdentityCase(
            mandalaCount,
            msg.sender,
            grounds,
            IdentityStatus.Filed,
            0,
            block.timestamp
        );

        emit IdentityFiled(mandalaCount);
    }

    function beginReview(uint256 identityId) external onlyCouncil {
        IdentityCase storage i = identityCases[identityId];
        require(i.status == IdentityStatus.Filed, "Not filed");
        i.status = IdentityStatus.UnderReview;
        emit IdentityStatusChanged(identityId, IdentityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 identityId) external onlyCouncil {
        IdentityCase storage i = identityCases[identityId];
        require(i.status == IdentityStatus.UnderReview, "Not under review");
        i.status = IdentityStatus.MultiCouncilReview;
        emit IdentityStatusChanged(identityId, IdentityStatus.MultiCouncilReview);
    }

    function confirmIdentity(uint256 identityId) external onlyCouncil {
        IdentityCase storage i = identityCases[identityId];
        require(i.status == IdentityStatus.MultiCouncilReview, "Not in council stage");

        i.approvals++;

        if (i.approvals * 2 > councilCount && councilCount > 0) {
            i.status = IdentityStatus.IdentityConfirmed;
            emit IdentityStatusChanged(identityId, IdentityStatus.IdentityConfirmed);
        }
    }

    function rejectIdentity(uint256 identityId) external onlyCouncil {
        IdentityCase storage i = identityCases[identityId];
        require(
            i.status == IdentityStatus.Filed ||
            i.status == IdentityStatus.UnderReview ||
            i.status == IdentityStatus.MultiCouncilReview,
            "Invalid status"
        );
        i.status = IdentityStatus.Rejected;
        emit IdentityStatusChanged(identityId, IdentityStatus.Rejected);
    }
}
