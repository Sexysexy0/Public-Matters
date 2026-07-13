// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Care Treaty
/// @notice Unifies care commitments into treaty law.
/// @dev Complements EmpathyMandala, KindnessFramework, and CompassionFramework.

contract CareTreaty {
    address public guardian;
    uint256 public treatyCount;
    uint256 public councilCount;

    enum CareRule {
        CareIsConstitutional,
        NurtureMandated,
        NeglectSuppressed,
        TransparencyInCareSystems,
        PublicBenefitPriority
    }

    enum CareStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CareConfirmed
    }

    struct Rule {
        uint256 id;
        CareRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct CareCase {
        uint256 id;
        address proposer;
        string grounds;
        CareStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => CareCase) public careCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, CareRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CareFiled(uint256 indexed id);
    event CareStatusChanged(uint256 indexed id, CareStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        treatyCount = 0;
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
        _declare(CareRule.CareIsConstitutional, "Care is constitutional; denial prohibited.");
        _declare(CareRule.NurtureMandated, "Nurture mandated; neglect blocked.");
        _declare(CareRule.NeglectSuppressed, "Neglect suppressed; fairness required.");
        _declare(CareRule.TransparencyInCareSystems, "Care systems must be transparent.");
        _declare(CareRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(CareRule ruleType, string memory description) internal {
        treatyCount++;
        rules[treatyCount] = Rule(
            treatyCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(treatyCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileCareCase(string calldata grounds) external {
        treatyCount++;
        careCases[treatyCount] = CareCase(
            treatyCount,
            msg.sender,
            grounds,
            CareStatus.Filed,
            0,
            block.timestamp
        );

        emit CareFiled(treatyCount);
    }

    function beginReview(uint256 careId) external onlyCouncil {
        CareCase storage c = careCases[careId];
        require(c.status == CareStatus.Filed, "Not filed");
        c.status = CareStatus.UnderReview;
        emit CareStatusChanged(careId, CareStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 careId) external onlyCouncil {
        CareCase storage c = careCases[careId];
        require(c.status == CareStatus.UnderReview, "Not under review");
        c.status = CareStatus.MultiCouncilReview;
        emit CareStatusChanged(careId, CareStatus.MultiCouncilReview);
    }

    function confirmCare(uint256 careId) external onlyCouncil {
        CareCase storage c = careCases[careId];
        require(c.status == CareStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CareStatus.CareConfirmed;
            emit CareStatusChanged(careId, CareStatus.CareConfirmed);
        }
    }

    function rejectCare(uint256 careId) external onlyCouncil {
        CareCase storage c = careCases[careId];
        require(
            c.status == CareStatus.Filed ||
            c.status == CareStatus.UnderReview ||
            c.status == CareStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CareStatus.Rejected;
        emit CareStatusChanged(careId, CareStatus.Rejected);
    }
}
