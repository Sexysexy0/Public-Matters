// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Laches Codification
/// @notice Encodes laches safeguard.
/// @dev Complements ExpeditedProcedureFramework, SupplementalFilingsTreaty, and CaseLawCodification.

contract LachesCodification {
    address public guardian;
    uint256 public codificationCount;
    uint256 public councilCount;

    enum LachesRule {
        LachesIsConstitutional,
        DelayConsidered,
        StaleClaimsSuppressed,
        CaseLawCodified,
        TransparencyInLachesSystems,
        PublicBenefitPriority
    }

    enum LachesStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        LachesConfirmed
    }

    struct Rule {
        uint256 id;
        LachesRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct LachesCase {
        uint256 id;
        address complainant;
        address respondent;
        string domainName;
        string grounds;
        LachesStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => LachesCase) public lachesCases;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, LachesRule ruleType);
    event RuleLocked(uint256 indexed id);
    event LachesFiled(uint256 indexed id, string domainName);
    event LachesStatusChanged(uint256 indexed id, LachesStatus status);
    event CouncilMemberAdded(address indexed member);
    event CouncilMemberRemoved(address indexed member);

    constructor() {
        guardian = msg.sender;
        codificationCount = 0;
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
        _declare(LachesRule.LachesIsConstitutional, "Laches is constitutional; denial prohibited.");
        _declare(LachesRule.DelayConsidered, "Delay considered; fairness required.");
        _declare(LachesRule.StaleClaimsSuppressed, "Stale claims suppressed; abuse blocked.");
        _declare(LachesRule.CaseLawCodified, "Case law codified; consistency required.");
        _declare(LachesRule.TransparencyInLachesSystems, "Laches systems must be transparent.");
        _declare(LachesRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(LachesRule ruleType, string memory description) internal {
        codificationCount++;
        rules[codificationCount] = Rule(
            codificationCount,
            ruleType,
            description,
            false,
            block.timestamp
        );
        emit RuleDeclared(codificationCount, ruleType);
    }

    function lockRule(uint256 id) external onlyGuardian {
        Rule storage r = rules[id];
        require(!r.immutableEntry, "Already immutable");
        r.immutableEntry = true;
        emit RuleLocked(id);
    }

    function fileLachesCase(
        address respondent,
        string calldata domainName,
        string calldata grounds
    ) external {
        codificationCount++;
        lachesCases[codificationCount] = LachesCase(
            codificationCount,
            msg.sender,
            respondent,
            domainName,
            grounds,
            LachesStatus.Filed,
            0,
            block.timestamp
        );

        emit LachesFiled(codificationCount, domainName);
    }

    function beginReview(uint256 caseId) external onlyCouncil {
        LachesCase storage c = lachesCases[caseId];
        require(c.status == LachesStatus.Filed, "Not filed");
        c.status = LachesStatus.UnderReview;
        emit LachesStatusChanged(caseId, LachesStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 caseId) external onlyCouncil {
        LachesCase storage c = lachesCases[caseId];
        require(c.status == LachesStatus.UnderReview, "Not under review");
        c.status = LachesStatus.MultiCouncilReview;
        emit LachesStatusChanged(caseId, LachesStatus.MultiCouncilReview);
    }

    function confirmLaches(uint256 caseId) external onlyCouncil {
        LachesCase storage c = lachesCases[caseId];
        require(c.status == LachesStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = LachesStatus.LachesConfirmed;
            emit LachesStatusChanged(caseId, LachesStatus.LachesConfirmed);
        }
    }

    function rejectLaches(uint256 caseId) external onlyCouncil {
        LachesCase storage c = lachesCases[caseId];
        require(
            c.status == LachesStatus.Filed ||
            c.status == LachesStatus.UnderReview ||
            c.status == LachesStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = LachesStatus.Rejected;
        emit LachesStatusChanged(caseId, LachesStatus.Rejected);
    }
}
