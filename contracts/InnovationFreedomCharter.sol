// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Freedom Charter
/// @notice Encodes innovation freedom safeguard.
/// @dev Complements ProviderAccountabilityMandala, InnovationConstitution, and PublicBenefitOracle.

contract InnovationFreedomCharter {
    address public guardian;
    uint256 public charterCount;
    uint256 public councilCount;

    enum FreedomRule {
        InnovationIsConstitutional,
        BureaucraticOverreachBlocked,
        ExperimentationEncouraged,
        RenewalEnabled,
        TransparencyInInnovationSystems,
        PublicBenefitPriority
    }

    enum FreedomStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        FreedomConfirmed
    }

    struct Rule {
        uint256 id;
        FreedomRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Freedom {
        uint256 id;
        address proposer;
        string grounds;
        FreedomStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Freedom) public freedoms;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, FreedomRule ruleType);
    event RuleLocked(uint256 indexed id);
    event FreedomFiled(uint256 indexed id);
    event FreedomStatusChanged(uint256 indexed id, FreedomStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        charterCount = 0;
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
        _declare(FreedomRule.InnovationIsConstitutional, "Innovation is constitutional; denial prohibited.");
        _declare(FreedomRule.BureaucraticOverreachBlocked, "Bureaucratic overreach blocked; fairness required.");
        _declare(FreedomRule.ExperimentationEncouraged, "Experimentation encouraged; stagnation prohibited.");
        _declare(FreedomRule.RenewalEnabled, "Renewal enabled; systemic vitality required.");
        _declare(FreedomRule.TransparencyInInnovationSystems, "Innovation systems must be transparent.");
        _declare(FreedomRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(FreedomRule ruleType, string memory description) internal {
        charterCount++;
        rules[charterCount] = Rule(
            charterCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(charterCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileFreedom(string calldata grounds) external {
        charterCount++;
        freedoms[charterCount] = Freedom(
            charterCount,
            msg.sender,
            grounds,
            FreedomStatus.Filed,
            0,
            block.timestamp
        );

        emit FreedomFiled(charterCount);
    }

    function beginReview(uint256 freedomId) external onlyCouncil {
        Freedom storage f = freedoms[freedomId];
        require(f.status == FreedomStatus.Filed, "Not filed");
        f.status = FreedomStatus.UnderReview;
        emit FreedomStatusChanged(freedomId, FreedomStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 freedomId) external onlyCouncil {
        Freedom storage f = freedoms[freedomId];
        require(f.status == FreedomStatus.UnderReview, "Not under review");
        f.status = FreedomStatus.MultiCouncilReview;
        emit FreedomStatusChanged(freedomId, FreedomStatus.MultiCouncilReview);
    }

    function confirmFreedom(uint256 freedomId) external onlyCouncil {
        Freedom storage f = freedoms[freedomId];
        require(f.status == FreedomStatus.MultiCouncilReview, "Not in council stage");

        f.approvals++;

        if (f.approvals * 2 > councilCount && councilCount > 0) {
            f.status = FreedomStatus.FreedomConfirmed;
            emit FreedomStatusChanged(freedomId, FreedomStatus.FreedomConfirmed);
        }
    }

    function rejectFreedom(uint256 freedomId) external onlyCouncil {
        Freedom storage f = freedoms[freedomId];
        require(
            f.status == FreedomStatus.Filed ||
            f.status == FreedomStatus.UnderReview ||
            f.status == FreedomStatus.MultiCouncilReview,
            "Invalid status"
        );
        f.status = FreedomStatus.Rejected;
        emit FreedomStatusChanged(freedomId, FreedomStatus.Rejected);
    }
}
