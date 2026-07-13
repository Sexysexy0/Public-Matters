// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Procurement Clarity Covenant
/// @notice Encodes procurement clarity safeguard.
/// @dev Complements AntiWeaponization, PublicBenefitOracle, and BureaucraticAccountability.

contract ProcurementClarity {
    address public guardian;
    uint256 public clarityCount;
    uint256 public councilCount;

    enum ClarityRule {
        ProcurementIsConstitutional,
        TransparencyMandated,
        OpaqueContractsSuppressed,
        FairAllocationRequired,
        AccountabilityEnforced,
        PublicBenefitPriority
    }

    enum ClarityStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        ClarityConfirmed
    }

    struct Rule {
        uint256 id;
        ClarityRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct ClarityCase {
        uint256 id;
        address proposer;
        string grounds;
        ClarityStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => ClarityCase) public clarityCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, ClarityRule ruleType);
    event RuleLocked(uint256 indexed id);
    event ClarityFiled(uint256 indexed id);
    event ClarityStatusChanged(uint256 indexed id, ClarityStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        clarityCount = 0;
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
        _declare(ClarityRule.ProcurementIsConstitutional, "Procurement is constitutional; denial prohibited.");
        _declare(ClarityRule.TransparencyMandated, "Transparency mandated; opacity blocked.");
        _declare(ClarityRule.OpaqueContractsSuppressed, "Opaque contracts suppressed; fairness required.");
        _declare(ClarityRule.FairAllocationRequired, "Fair allocation required; inequity prohibited.");
        _declare(ClarityRule.AccountabilityEnforced, "Accountability enforced; neglect prohibited.");
        _declare(ClarityRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(ClarityRule ruleType, string memory description) internal {
        clarityCount++;
        rules[clarityCount] = Rule(
            clarityCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(clarityCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileClarityCase(string calldata grounds) external {
        clarityCount++;
        clarityCases[clarityCount] = ClarityCase(
            clarityCount,
            msg.sender,
            grounds,
            ClarityStatus.Filed,
            0,
            block.timestamp
        );

        emit ClarityFiled(clarityCount);
    }

    function beginReview(uint256 clarityId) external onlyCouncil {
        ClarityCase storage c = clarityCases[clarityId];
        require(c.status == ClarityStatus.Filed, "Not filed");
        c.status = ClarityStatus.UnderReview;
        emit ClarityStatusChanged(clarityId, ClarityStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 clarityId) external onlyCouncil {
        ClarityCase storage c = clarityCases[clarityId];
        require(c.status == ClarityStatus.UnderReview, "Not under review");
        c.status = ClarityStatus.MultiCouncilReview;
        emit ClarityStatusChanged(clarityId, ClarityStatus.MultiCouncilReview);
    }

    function confirmClarity(uint256 clarityId) external onlyCouncil {
        ClarityCase storage c = clarityCases[clarityId];
        require(c.status == ClarityStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = ClarityStatus.ClarityConfirmed;
            emit ClarityStatusChanged(clarityId, ClarityStatus.ClarityConfirmed);
        }
    }

    function rejectClarity(uint256 clarityId) external onlyCouncil {
        ClarityCase storage c = clarityCases[clarityId];
        require(
            c.status == ClarityStatus.Filed ||
            c.status == ClarityStatus.UnderReview ||
            c.status == ClarityStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = ClarityStatus.Rejected;
        emit ClarityStatusChanged(clarityId, ClarityStatus.Rejected);
    }
}
