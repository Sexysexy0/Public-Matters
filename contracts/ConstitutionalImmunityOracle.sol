// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Constitutional Immunity Oracle
/// @notice Grants the constitution immunity against corruption, coercion, manipulation, capture, and systemic infiltration.
/// @dev Complements ConstitutionalDefenseOracle, ConstitutionalResilienceOracle, ConstitutionalContinuityOracle, and MetaConstitutionOracle.

contract ConstitutionalImmunityOracle {
    address public guardian;
    uint256 public immunityCount;
    uint256 public councilCount;

    enum ImmunityRule {
        ImmunityIsConstitutional,
        CorruptionImmunityRequired,
        CoercionImmunityRequired,
        ManipulationImmunityRequired,
        CaptureImmunityRequired,
        PublicBenefitPriority
    }

    enum ImmunityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ImmunityConfirmed
    }

    struct Rule {
        uint256 id;
        ImmunityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ImmunityCase {
        uint256 id;
        address proposer;
        string threatVector;
        string infiltrationMethod;
        string grounds;
        ImmunityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule> public rules;
    mapping<uint256 => ImmunityCase> public immunityCases;
    mapping(address => bool> public councilMember;

    event RuleDeclared(uint256 indexed id, ImmunityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ImmunityFiled(uint256 indexed id);
    event ImmunityStatusChanged(uint256 indexed id, ImmunityStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        immunityCount = 0;
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
        _declare(ImmunityRule.ImmunityIsConstitutional, "Immunity is constitutional; denial prohibited.");
        _declare(ImmunityRule.CorruptionImmunityRequired, "Constitution must be immune to corruption attempts.");
        _declare(ImmunityRule.CoercionImmunityRequired, "Constitution must be immune to coercion or forced influence.");
        _declare(ImmunityRule.ManipulationImmunityRequired, "Constitution must be immune to manipulation or distortion.");
        _declare(ImmunityRule.CaptureImmunityRequired, "Constitution must be immune to systemic capture or hijack.");
        _declare(ImmunityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ImmunityRule ruleType, string memory description) internal {
        immunityCount++;
        rules[immunityCount] = Rule(
            immunityCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(immunityCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileImmunityCase(
        string calldata threatVector,
        string calldata infiltrationMethod,
        string calldata grounds
    ) external {
        immunityCount++;
        immunityCases[immunityCount] = ImmunityCase(
            immunityCount,
            msg.sender,
            threatVector,
            infiltrationMethod,
            grounds,
            ImmunityStatus.Filed,
            0,
            block.timestamp
        );

        emit ImmunityFiled(immunityCount);
    }

    function beginReview(uint256 immunityId) external onlyCouncil {
        ImmunityCase storage c = immunityCases[immunityId];
        require(c.status == ImmunityStatus.Filed, "Not filed");
        c.status = ImmunityStatus.UnderReview;
        emit ImmunityStatusChanged(immunityId, ImmunityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 immunityId) external onlyCouncil {
        ImmunityCase storage c = immunityCases[immunityId];
        require(c.status == ImmunityStatus.UnderReview, "Not under review");
        c.status = ImmunityStatus.MultiCouncilReview;
        emit ImmunityStatusChanged(immunityId, ImmunityStatus.MultiCouncilReview);
    }

    function confirmImmunity(uint256 immunityId) external onlyCouncil {
        ImmunityCase storage c = immunityCases[immunityId];
        require(c.status == ImmunityStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ImmunityStatus.ImmunityConfirmed;
            emit ImmunityStatusChanged(immunityId, ImmunityStatus.ImmunityConfirmed);
        }
    }

    function rejectImmunity(uint256 immunityId) external onlyCouncil {
        ImmunityCase storage c = immunityCases[immunityId];
        require(
            c.status == ImmunityStatus.Filed ||
            c.status == ImmunityStatus.UnderReview ||
            c.status == ImmunityStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ImmunityStatus.Rejected;
        emit ImmunityStatusChanged(immunityId, ImmunityStatus.Rejected);
    }
}
