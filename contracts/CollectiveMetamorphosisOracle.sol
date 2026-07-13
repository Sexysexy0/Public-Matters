// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Collective Metamorphosis Oracle
/// @notice Encodes safeguard for collective metamorphosis — systemic transformation at community scale.
/// @dev Complements TransformationMandala, DefenderSynergyOracle, and PublicBenefitOracle.

contract CollectiveMetamorphosisOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum MetamorphosisRule {
        CollectiveMetamorphosisIsConstitutional,
        CommunitySynergyMandated,
        FragmentationSuppressed,
        TransparencyInMetamorphosisSystems,
        PublicBenefitPriority
    }

    enum MetamorphosisStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        MetamorphosisConfirmed
    }

    struct Rule {
        uint256 id;
        MetamorphosisRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct MetamorphosisCase {
        uint256 id;
        address proposer;
        string grounds;
        MetamorphosisStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => MetamorphosisCase) public metamorphosisCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, MetamorphosisRule ruleType);
    event RuleLocked(uint256 indexed id);
    event MetamorphosisFiled(uint256 indexed id);
    event MetamorphosisStatusChanged(uint256 indexed id, MetamorphosisStatus status);
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
        _declare(MetamorphosisRule.CollectiveMetamorphosisIsConstitutional, "Collective metamorphosis is constitutional; denial prohibited.");
        _declare(MetamorphosisRule.CommunitySynergyMandated, "Community synergy mandated; fragmented change blocked.");
        _declare(MetamorphosisRule.FragmentationSuppressed, "Fragmentation suppressed; fairness required.");
        _declare(MetamorphosisRule.TransparencyInMetamorphosisSystems, "Metamorphosis systems must be transparent.");
        _declare(MetamorphosisRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(MetamorphosisRule ruleType, string memory description) internal {
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

    function fileMetamorphosisCase(string calldata grounds) external {
        oracleCount++;
        metamorphosisCases[oracleCount] = MetamorphosisCase(
            oracleCount,
            msg.sender,
            grounds,
            MetamorphosisStatus.Filed,
            0,
            block.timestamp
        );

        emit MetamorphosisFiled(oracleCount);
    }

    function beginReview(uint256 metamorphosisId) external onlyCouncil {
        MetamorphosisCase storage m = metamorphosisCases[metamorphosisId];
        require(m.status == MetamorphosisStatus.Filed, "Not filed");
        m.status = MetamorphosisStatus.UnderReview;
        emit MetamorphosisStatusChanged(metamorphosisId, MetamorphosisStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 metamorphosisId) external onlyCouncil {
        MetamorphosisCase storage m = metamorphosisCases[metamorphosisId];
        require(m.status == MetamorphosisStatus.UnderReview, "Not under review");
        m.status = MetamorphosisStatus.MultiCouncilReview;
        emit MetamorphosisStatusChanged(metamorphosisId, MetamorphosisStatus.MultiCouncilReview);
    }

    function confirmMetamorphosis(uint256 metamorphosisId) external onlyCouncil {
        MetamorphosisCase storage m = metamorphosisCases[metamorphosisId];
        require(m.status == MetamorphosisStatus.MultiCouncilReview, "Not in council stage");

        m.approvals++;

        if (m.approvals * 2 > councilCount && councilCount > 0) {
            m.status = MetamorphosisStatus.MetamorphosisConfirmed;
            emit MetamorphosisStatusChanged(metamorphosisId, MetamorphosisStatus.MetamorphosisConfirmed);
        }
    }

    function rejectMetamorphosis(uint256 metamorphosisId) external onlyCouncil {
        MetamorphosisCase storage m = metamorphosisCases[metamorphosisId];
        require(
            m.status == MetamorphosisStatus.Filed ||
            m.status == MetamorphosisStatus.UnderReview ||
            m.status == MetamorphosisStatus.MultiCouncilReview,
            "Invalid status"
        );
        m.status = MetamorphosisStatus.Rejected;
        emit MetamorphosisStatusChanged(metamorphosisId, MetamorphosisStatus.Rejected);
    }
}
