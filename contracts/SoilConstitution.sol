// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Soil Constitution
/// @notice Encodes soil integrity as a constitutional safeguard.
/// @dev Complements PublicBenefitOracle, InnovationSafetyCovenant, and BioHealthMandala.

contract SoilConstitution {
    address public guardian;
    uint256 public constitutionCount;
    uint256 public councilCount;

    enum SoilRule {
        SoilIntegrityIsConstitutional,
        RegenerationMandated,
        DegradationSuppressed,
        TransparencyInSoilSystems,
        PublicBenefitPriority
    }

    enum SoilStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        SoilConfirmed
    }

    struct Rule {
        uint256 id;
        SoilRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct SoilCase {
        uint256 id;
        address proposer;
        string grounds;
        SoilStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => SoilCase) public soilCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, SoilRule ruleType);
    event RuleLocked(uint256 indexed id);
    event SoilFiled(uint256 indexed id);
    event SoilStatusChanged(uint256 indexed id, SoilStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        constitutionCount = 0;
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
        _declare(SoilRule.SoilIntegrityIsConstitutional, "Soil integrity is constitutional; denial prohibited.");
        _declare(SoilRule.RegenerationMandated, "Regeneration mandated; degradation blocked.");
        _declare(SoilRule.DegradationSuppressed, "Degradation suppressed; fairness required.");
        _declare(SoilRule.TransparencyInSoilSystems, "Soil systems must be transparent.");
        _declare(SoilRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(SoilRule ruleType, string memory description) internal {
        constitutionCount++;
        rules[constitutionCount] = Rule(
            constitutionCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(constitutionCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileSoilCase(string calldata grounds) external {
        constitutionCount++;
        soilCases[constitutionCount] = SoilCase(
            constitutionCount,
            msg.sender,
            grounds,
            SoilStatus.Filed,
            0,
            block.timestamp
        );

        emit SoilFiled(constitutionCount);
    }

    function beginReview(uint256 soilId) external onlyCouncil {
        SoilCase storage s = soilCases[soilId];
        require(s.status == SoilStatus.Filed, "Not filed");
        s.status = SoilStatus.UnderReview;
        emit SoilStatusChanged(soilId, SoilStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 soilId) external onlyCouncil {
        SoilCase storage s = soilCases[soilId];
        require(s.status == SoilStatus.UnderReview, "Not under review");
        s.status = SoilStatus.MultiCouncilReview;
        emit SoilStatusChanged(soilId, SoilStatus.MultiCouncilReview);
    }

    function confirmSoil(uint256 soilId) external onlyCouncil {
        SoilCase storage s = soilCases[soilId];
        require(s.status == SoilStatus.MultiCouncilReview, "Not in council stage");

        s.approvals++;

        if (s.approvals * 2 > councilCount && councilCount > 0) {
            s.status = SoilStatus.SoilConfirmed;
            emit SoilStatusChanged(soilId, SoilStatus.SoilConfirmed);
        }
    }

    function rejectSoil(uint256 soilId) external onlyCouncil {
        SoilCase storage s = soilCases[soilId];
        require(
            s.status == SoilStatus.Filed ||
            s.status == SoilStatus.UnderReview ||
            s.status == SoilStatus.MultiCouncilReview,
            "Invalid status"
        );
        s.status = SoilStatus.Rejected;
        emit SoilStatusChanged(soilId, SoilStatus.Rejected);
    }
}
