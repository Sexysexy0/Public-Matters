// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Energy Match Mandala
/// @notice Encodes safeguard for aligning personal agency with defender intervention.
/// @dev Complements OpportunityPathOracle, IdentityRebuildMandala, and VictimhoodExitCharter.

contract EnergyMatchMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum EnergyRule {
        EnergyMatchIsConstitutional,
        AlignmentMandated,
        SelfSabotageSuppressed,
        TransparencyInEnergySystems,
        PublicBenefitPriority
    }

    enum EnergyStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        EnergyConfirmed
    }

    struct Rule {
        uint256 id;
        EnergyRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct EnergyCase {
        uint256 id;
        address proposer;
        string grounds;
        EnergyStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => EnergyCase) public energyCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, EnergyRule ruleType);
    event RuleLocked(uint256 indexed id);
    event EnergyFiled(uint256 indexed id);
    event EnergyStatusChanged(uint256 indexed id, EnergyStatus status);
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
        _declare(EnergyRule.EnergyMatchIsConstitutional, "Energy match is constitutional; denial prohibited.");
        _declare(EnergyRule.AlignmentMandated, "Alignment mandated; agency must match defender energy.");
        _declare(EnergyRule.SelfSabotageSuppressed, "Self-sabotage suppressed; fairness required.");
        _declare(EnergyRule.TransparencyInEnergySystems, "Energy systems must be transparent.");
        _declare(EnergyRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(EnergyRule ruleType, string memory description) internal {
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

    function fileEnergyCase(string calldata grounds) external {
        mandalaCount++;
        energyCases[mandalaCount] = EnergyCase(
            mandalaCount,
            msg.sender,
            grounds,
            EnergyStatus.Filed,
            0,
            block.timestamp
        );

        emit EnergyFiled(mandalaCount);
    }

    function beginReview(uint256 energyId) external onlyCouncil {
        EnergyCase storage e = energyCases[energyId];
        require(e.status == EnergyStatus.Filed, "Not filed");
        e.status = EnergyStatus.UnderReview;
        emit EnergyStatusChanged(energyId, EnergyStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 energyId) external onlyCouncil {
        EnergyCase storage e = energyCases[energyId];
        require(e.status == EnergyStatus.UnderReview, "Not under review");
        e.status = EnergyStatus.MultiCouncilReview;
        emit EnergyStatusChanged(energyId, EnergyStatus.MultiCouncilReview);
    }

    function confirmEnergy(uint256 energyId) external onlyCouncil {
        EnergyCase storage e = energyCases[energyId];
        require(e.status == EnergyStatus.MultiCouncilReview, "Not in council stage");

        e.approvals++;

        if (e.approvals * 2 > councilCount && councilCount > 0) {
            e.status = EnergyStatus.EnergyConfirmed;
            emit EnergyStatusChanged(energyId, EnergyStatus.EnergyConfirmed);
        }
    }

    function rejectEnergy(uint256 energyId) external onlyCouncil {
        EnergyCase storage e = energyCases[energyId];
        require(
            e.status == EnergyStatus.Filed ||
            e.status == EnergyStatus.UnderReview ||
            e.status == EnergyStatus.MultiCouncilReview,
            "Invalid status"
        );
        e.status = EnergyStatus.Rejected;
        emit EnergyStatusChanged(energyId, EnergyStatus.Rejected);
    }
}
