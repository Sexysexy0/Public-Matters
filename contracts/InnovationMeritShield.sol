// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Innovation Merit Shield
/// @notice Encodes merit and fairness safeguard in innovation ecosystems.
/// @dev Complements PublicBenefitOracle, InnovationSafetyCovenant, and BureaucraticAccountability.

contract InnovationMeritShield {
    address public guardian;
    uint256 public shieldCount;
    uint256 public councilCount;

    enum MeritRule {
        MeritIsConstitutional,
        FairnessMandated,
        BiasSuppressed,
        TransparencyInMeritSystems,
        PublicBenefitPriority
    }

    enum MeritStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        MeritConfirmed
    }

    struct Rule {
        uint256 id;
        MeritRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct MeritCase {
        uint256 id;
        address proposer;
        string grounds;
        MeritStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => MeritCase) public meritCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, MeritRule ruleType);
    event RuleLocked(uint256 indexed id);
    event MeritFiled(uint256 indexed id);
    event MeritStatusChanged(uint256 indexed id, MeritStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        shieldCount = 0;
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
        _declare(MeritRule.MeritIsConstitutional, "Merit is constitutional; denial prohibited.");
        _declare(MeritRule.FairnessMandated, "Fairness mandated; bias blocked.");
        _declare(MeritRule.BiasSuppressed, "Bias suppressed; fairness required.");
        _declare(MeritRule.TransparencyInMeritSystems, "Merit systems must be transparent.");
        _declare(MeritRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(MeritRule ruleType, string memory description) internal {
        shieldCount++;
        rules[shieldCount] = Rule(
            shieldCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(shieldCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileMeritCase(string calldata grounds) external {
        shieldCount++;
        meritCases[shieldCount] = MeritCase(
            shieldCount,
            msg.sender,
            grounds,
            MeritStatus.Filed,
            0,
            block.timestamp
        );

        emit MeritFiled(shieldCount);
    }

    function beginReview(uint256 meritId) external onlyCouncil {
        MeritCase storage m = meritCases[meritId];
        require(m.status == MeritStatus.Filed, "Not filed");
        m.status = MeritStatus.UnderReview;
        emit MeritStatusChanged(meritId, MeritStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 meritId) external onlyCouncil {
        MeritCase storage m = meritCases[meritId];
        require(m.status == MeritStatus.UnderReview, "Not under review");
        m.status = MeritStatus.MultiCouncilReview;
        emit MeritStatusChanged(meritId, MeritStatus.MultiCouncilReview);
    }

    function confirmMerit(uint256 meritId) external onlyCouncil {
        MeritCase storage m = meritCases[meritId];
        require(m.status == MeritStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = MeritStatus.MeritConfirmed;
            emit MeritStatusChanged(meritId, MeritStatus.MeritConfirmed);
        }
    }

    function rejectMerit(uint256 meritId) external onlyCouncil {
        MeritCase storage m = meritCases[meritId];
        require(
            m.status == MeritStatus.Filed ||
            m.status == MeritStatus.UnderReview ||
            m.status == MeritStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = MeritStatus.Rejected;
        emit MeritStatusChanged(meritId, MeritStatus.Rejected);
    }
}
