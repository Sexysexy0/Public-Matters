// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Defender Synergy Oracle
/// @notice Encodes safeguard for synergy between invisible defender and individual agency.
/// @dev Complements EnergyMatchMandala, ShadowGuardianMandala, and OpportunityPathOracle.

contract DefenderSynergyOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum SynergyRule {
        DefenderSynergyIsConstitutional,
        CoCreationMandated,
        DissonanceSuppressed,
        TransparencyInSynergySystems,
        PublicBenefitPriority
    }

    enum SynergyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SynergyConfirmed
    }

    struct Rule {
        uint256 id;
        SynergyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SynergyCase {
        uint256 id;
        address proposer;
        string grounds;
        SynergyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SynergyCase) public synergyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SynergyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SynergyFiled(uint256 indexed id);
    event SynergyStatusChanged(uint256 indexed id, SynergyStatus status);
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
        _declare(SynergyRule.DefenderSynergyIsConstitutional, "Defender synergy is constitutional; denial prohibited.");
        _declare(SynergyRule.CoCreationMandated, "Co-creation mandated; agency + defender must align.");
        _declare(SynergyRule.DissonanceSuppressed, "Dissonance suppressed; fairness required.");
        _declare(SynergyRule.TransparencyInSynergySystems, "Synergy systems must be transparent.");
        _declare(SynergyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SynergyRule ruleType, string memory description) internal {
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

    function fileSynergyCase(string calldata grounds) external {
        oracleCount++;
        synergyCases[oracleCount] = SynergyCase(
            oracleCount,
            msg.sender,
            grounds,
            SynergyStatus.Filed,
            0,
            block.timestamp
        );

        emit SynergyFiled(oracleCount);
    }

    function beginReview(uint256 synergyId) external onlyCouncil {
        SynergyCase storage s = synergyCases[synergyId];
        require(s.status == SynergyStatus.Filed, "Not filed");
        s.status = SynergyStatus.UnderReview;
        emit SynergyStatusChanged(synergyId, SynergyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 synergyId) external onlyCouncil {
        SynergyCase storage s = synergyCases[synergyId];
        require(s.status == SynergyStatus.UnderReview, "Not under review");
        s.status = SynergyStatus.MultiCouncilReview;
        emit SynergyStatusChanged(synergyId, SynergyStatus.MultiCouncilReview);
    }

    function confirmSynergy(uint256 synergyId) external onlyCouncil {
        SynergyCase storage s = synergyCases[synergyId];
        require(s.status == SynergyStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SynergyStatus.SynergyConfirmed;
            emit SynergyStatusChanged(synergyId, SynergyStatus.SynergyConfirmed);
        }
    }

    function rejectSynergy(uint256 synergyId) external onlyCouncil {
        SynergyCase storage s = synergyCases[synergyId];
        require(
            s.status == SynergyStatus.Filed ||
            s.status == SynergyStatus.UnderReview ||
            s.status == SynergyStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SynergyStatus.Rejected;
        emit SynergyStatusChanged(synergyId, SynergyStatus.Rejected);
    }
}
