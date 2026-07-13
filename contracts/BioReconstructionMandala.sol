// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Bio Reconstruction Mandala
/// @notice Encodes safeguard for biological reconstruction and dormant DNA activation.
/// @dev Complements BioHealthMandala, SoilConstitution, and PoeticJusticeOracle.

contract BioReconstructionMandala {
    address public guardian;
    uint256 public mandalaCount;
    uint256 public councilCount;

    enum BioRule {
        BiologicalReconstructionIsConstitutional,
        DormantCodesMandated,
        SuppressionOfDegeneration,
        TransparencyInBioReconstructionSystems,
        PublicBenefitPriority
    }

    enum BioStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ReconstructionConfirmed
    }

    struct Rule {
        uint256 id;
        BioRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct BioCase {
        uint256 id;
        address proposer;
        string grounds;
        BioStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => BioCase) public bioCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, BioRule ruleType);
    event RuleLocked(uint256 indexed id);
    event BioFiled(uint256 indexed id);
    event BioStatusChanged(uint256 indexed id, BioStatus status);
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
        _declare(BioRule.BiologicalReconstructionIsConstitutional, "Biological reconstruction is constitutional; denial prohibited.");
        _declare(BioRule.DormantCodesMandated, "Dormant codes mandated; regeneration triggered.");
        _declare(BioRule.SuppressionOfDegeneration, "Degeneration suppressed; fairness required.");
        _declare(BioRule.TransparencyInBioReconstructionSystems, "Bio reconstruction systems must be transparent.");
        _declare(BioRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(BioRule ruleType, string memory description) internal {
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

    function fileBioCase(string calldata grounds) external {
        mandalaCount++;
        bioCases[mandalaCount] = BioCase(
            mandalaCount,
            msg.sender,
            grounds,
            BioStatus.Filed,
            0,
            block.timestamp
        );

        emit BioFiled(mandalaCount);
    }

    function beginReview(uint256 bioId) external onlyCouncil {
        BioCase storage b = bioCases[bioId];
        require(b.status == BioStatus.Filed, "Not filed");
        b.status = BioStatus.UnderReview;
        emit BioStatusChanged(bioId, BioStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 bioId) external onlyCouncil {
        BioCase storage b = bioCases[bioId];
        require(b.status == BioStatus.UnderReview, "Not under review");
        b.status = BioStatus.MultiCouncilReview;
        emit BioStatusChanged(bioId, BioStatus.MultiCouncilReview);
    }

    function confirmReconstruction(uint256 bioId) external onlyCouncil {
        BioCase storage b = bioCases[bioId];
        require(b.status == BioStatus.MultiCouncilReview, "Not in council stage");

        b.approvals++;

        if (b.approvals * 2 > councilCount && councilCount > 0) {
            b.status = BioStatus.ReconstructionConfirmed;
            emit BioStatusChanged(bioId, BioStatus.ReconstructionConfirmed);
        }
    }

    function rejectReconstruction(uint256 bioId) external onlyCouncil {
        BioCase storage b = bioCases[bioId];
        require(
            b.status == BioStatus.Filed ||
            b.status == BioStatus.UnderReview ||
            b.status == BioStatus.MultiCouncilReview,
            "Invalid status"
        );
        b.status = BioStatus.Rejected;
        emit BioStatusChanged(bioId, BioStatus.Rejected);
    }
}
