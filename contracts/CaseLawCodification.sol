// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Case Law Codification
/// @notice Encodes pan-Provider jurisprudence safeguard.
/// @dev Complements PanelistQuality, AppealsMandala, and RemedyCancellation.

contract CaseLawCodification {
    address public guardian;
    uint256 public codificationCount;
    uint256 public councilCount;

    enum CodificationRule {
        JurisprudenceIsConstitutional,
        ConsistencyRequired,
        PanProviderBindingEnabled,
        BiasSuppressed,
        TransparencyInCodificationSystems,
        PublicBenefitPriority
    }

    enum CodificationStatus {
        Filed,
        UnderReview,
        MultiCouncilReview,
        Rejected,
        CodificationConfirmed
    }

    struct Rule {
        uint256 id;
        CodificationRule ruleType;
        string description;
        bool immutableEntry;
        uint256 timestamp;
    }

    struct Codification {
        uint256 id;
        address proposer;
        string caseReference;
        string grounds;
        CodificationStatus status;
        uint256 approvals;
        uint256 timestamp;
    }

    mapping(uint256 => Rule) public rules;
    mapping(uint256 => Codification) public codifications;
    mapping(address => bool) public councilMember;

    event RuleDeclared(uint256 indexed id, CodificationRule ruleType);
    event RuleLocked(uint256 indexed id);
    event CodificationFiled(uint256 indexed id, string caseReference);
    event CodificationStatusChanged(uint256 indexed id, CodificationStatus status);
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
        _declare(CodificationRule.JurisprudenceIsConstitutional, "Jurisprudence is constitutional; denial prohibited.");
        _declare(CodificationRule.ConsistencyRequired, "Consistency required; divergence prohibited.");
        _declare(CodificationRule.PanProviderBindingEnabled, "Pan-Provider binding enabled; uniformity required.");
        _declare(CodificationRule.BiasSuppressed, "Bias suppressed; impartiality required.");
        _declare(CodificationRule.TransparencyInCodificationSystems, "Codification systems must be transparent.");
        _declare(CodificationRule.PublicBenefitPriority, "Public benefit overrides elite gain.");
    }

    function _declare(CodificationRule ruleType, string memory description) internal {
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

    function fileCodification(
        string calldata caseReference,
        string calldata grounds
    ) external {
        codificationCount++;
        codifications[codificationCount] = Codification(
            codificationCount,
            msg.sender,
            caseReference,
            grounds,
            CodificationStatus.Filed,
            0,
            block.timestamp
        );

        emit CodificationFiled(codificationCount, caseReference);
    }

    function beginReview(uint256 codificationId) external onlyCouncil {
        Codification storage c = codifications[codificationId];
        require(c.status == CodificationStatus.Filed, "Not filed");
        c.status = CodificationStatus.UnderReview;
        emit CodificationStatusChanged(codificationId, CodificationStatus.UnderReview);
    }

    function escalateToMultiCouncil(uint256 codificationId) external onlyCouncil {
        Codification storage c = codifications[codificationId];
        require(c.status == CodificationStatus.UnderReview, "Not under review");
        c.status = CodificationStatus.MultiCouncilReview;
        emit CodificationStatusChanged(codificationId, CodificationStatus.MultiCouncilReview);
    }

    function confirmCodification(uint256 codificationId) external onlyCouncil {
        Codification storage c = codifications[codificationId];
        require(c.status == CodificationStatus.MultiCouncilReview, "Not in council stage");

        c.approvals++;

        if (c.approvals * 2 > councilCount && councilCount > 0) {
            c.status = CodificationStatus.CodificationConfirmed;
            emit CodificationStatusChanged(codificationId, CodificationStatus.CodificationConfirmed);
        }
    }

    function rejectCodification(uint256 codificationId) external onlyCouncil {
        Codification storage c = codifications[codificationId];
        require(
            c.status == CodificationStatus.Filed ||
            c.status == CodificationStatus.UnderReview ||
            c.status == CodificationStatus.MultiCouncilReview,
            "Invalid status"
        );
        c.status = CodificationStatus.Rejected;
        emit CodificationStatusChanged(codificationId, CodificationStatus.Rejected);
    }
}
