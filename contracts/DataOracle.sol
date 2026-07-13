// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Data Oracle Covenant
/// @notice Encodes data foundation and integrity safeguard.
/// @dev Complements InnovationSafetyCovenant, BureaucraticAccountability, and AITransparencyMandala.

contract DataOracle {
    address public guardian;
    uint256 public oracleCount;
    uint256 public councilCount;

    enum DataRule {
        DataIntegrityIsConstitutional,
        ModernizationMandated,
        SilosSuppressed,
        TransparencyInDataSystems,
        PublicBenefitPriority
    }

    enum DataStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        DataConfirmed
    }

    struct Rule {
        uint256 id;
        DataRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct DataCase {
        uint256 id;
        address proposer;
        string grounds;
        DataStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => DataCase) public dataCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, DataRule ruleType);
    event RuleLocked(uint256 indexed id);
    event DataFiled(uint256 indexed id);
    event DataStatusChanged(uint256 indexed id, DataStatus status);
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
        _declare(DataRule.DataIntegrityIsConstitutional, "Data integrity is constitutional; denial prohibited.");
        _declare(DataRule.ModernizationMandated, "Modernization mandated; silos blocked.");
        _declare(DataRule.SilosSuppressed, "Silos suppressed; fairness required.");
        _declare(DataRule.TransparencyInDataSystems, "Data systems must be transparent.");
        _declare(DataRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(DataRule ruleType, string memory description) internal {
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

    function fileDataCase(string calldata grounds) external {
        oracleCount++;
        dataCases[oracleCount] = DataCase(
            oracleCount,
            msg.sender,
            grounds,
            DataStatus.Filed,
            0,
            block.timestamp
        );

        emit DataFiled(oracleCount);
    }

    function beginReview(uint256 dataId) external onlyCouncil {
        DataCase storage d = dataCases[dataId];
        require(d.status == DataStatus.Filed, "Not filed");
        d.status = DataStatus.UnderReview;
        emit DataStatusChanged(dataId, DataStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 dataId) external onlyCouncil {
        DataCase storage d = dataCases[dataId];
        require(d.status == DataStatus.UnderReview, "Not under review");
        d.status = DataStatus.MultiCouncilReview;
        emit DataStatusChanged(dataId, DataStatus.MultiCouncilReview);
    }

    function confirmData(uint256 dataId) external onlyCouncil {
        DataCase storage d = dataCases[dataId];
        require(d.status == DataStatus.MultiCouncilReview, "Not in council stage");

        d.approvals++;

        if (d.approvals * 2 > councilCount && councilCount > 0) {
            d.status = DataStatus.DataConfirmed;
            emit DataStatusChanged(dataId, DataStatus.DataConfirmed);
        }
    }

    function rejectData(uint256 dataId) external onlyCouncil {
        DataCase storage d = dataCases[dataId];
        require(
            d.status == DataStatus.Filed ||
            d.status == DataStatus.UnderReview ||
            d.status == DataStatus.MultiCouncilReview,
            "Invalid status"
        );
        d.status = DataStatus.Rejected;
        emit DataStatusChanged(dataId, DataStatus.Rejected);
    }
}
